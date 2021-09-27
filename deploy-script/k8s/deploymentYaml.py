import utils


class DeploymentYamlDirectEnvInfo:
  def __init__(self, name, value):
    self.name = name
    self.value = value

  def yaml(self):
    template = ' ' * 8 + '- name: {0}\n' + ' ' * 10 + 'value: {1}'
    return template.format(self.name, self.value)


class DeploymentYamlAnnotation:
  def __init__(self, name, value):
    self.name = name
    self.value = value

  def yaml(self):
    template = ' ' * 8 + '{0}: {1}'
    return template.format(self.name, self.value)


class DeploymentYamlSecretEnvReference:
  def __init__(self, name, secretKey, secretName):
    self.name = name
    self.secretKey = secretKey
    self.secretName = secretName

  def yaml(self):
    template = ' ' * 8 + '- name: {0}\n' + \
        ' ' * 10 + 'valueFrom:\n' + ' ' * 12 + 'secretKeyRef:\n' + \
        ' ' * 14 + 'key: {1}\n' + ' ' * 14 + 'name: {2}'
    return template.format(self.name, self.secretKey, self.secretName)


class DeploymentYamlVolume:
  def __init__(self, name, claimName, mountPath):
    self.name = name
    self.claimName = claimName
    self.mountPath = mountPath

  def volumeMountYaml(self):
    template = ' ' * 8 + '- mountPath: {0}\n' + ' ' * 10 + 'name: {1}'
    return template.format(self.mountPath, self.name)

  def volumeYaml(self):
    template = ' ' * 6 + '- name: {0}\n' + ' ' * \
        8 + 'persistentVolumeClaim:\n' + ' ' * 10 + 'claimName: {1}'
    return template.format(self.name, self.claimName)


class DeploymentYamlInfo:
  __template = '''apiVersion: apps/v1
kind: Deployment
metadata:
  name: {0}
  namespace: {1}
spec:
  selector:
    matchLabels:
      app: {2}
  replicas: 1
  template:
    metadata:
      labels:
        app: {2}
{5}
    spec:
      containers:
      - name: {3}
        image: {4}
        imagePullPolicy: Always{11}{12}
        env:
{6}{7}{8}
      imagePullSecrets:
      - name: {9}
      nodeSelector: 
        node-tag: {10}'''

  __livenessProbeTemplate_InformationExtraction = '''
        livenessProbe:
          exec:
            command:
            - env
            - "PYTHONPATH=/app"
            - python3.8
            - /app/package/healthcheck/general.py
          initialDelaySeconds: 60
          periodSeconds: 60
          timeoutSeconds: 5
          failureThreshold: 2'''

  def __init__(self, name, namespace, selectorLabel, containerName, image, imagePullSecret, nodeTag, annotations, envs, volumes, needPrivilegedPermission, livenessProbe):
    self.name = name
    self.namespace = namespace
    self.selectorLabel = selectorLabel
    self.containerName = containerName
    self.image = image
    self.imagePullSecret = imagePullSecret
    self.nodeTag = nodeTag
    self.annotations = annotations
    self.envs = envs
    self.volumes = volumes
    if needPrivilegedPermission is not None and needPrivilegedPermission:
      self.needPrivilegedPermission = True
    else:
      self.needPrivilegedPermission = False

    if livenessProbe is None or len(livenessProbe) == 0:
      self.livenessProbeTemplate = ''
    elif livenessProbe == 'information_extraction_livenessProbe':
      self.livenessProbeTemplate = self.__livenessProbeTemplate_InformationExtraction

  def create(self, fileName):
    utils.createDirForFile(fileName)
    targetFile = open(fileName, 'w', encoding='utf-8')

    annotations_value = ''
    if self.annotations is not None:
      annotations_value = '      annotations:\n'
      annotation_count = len(self.annotations)
      for index, annotation in enumerate(self.annotations):
        temp_annotation = annotation.yaml()
        if index < annotation_count - 1:
          temp_annotation += '\n'
        annotations_value += temp_annotation

    envs_value = ''
    for index, oneEnv in enumerate(self.envs):
      temp_env = oneEnv.yaml()
      if index < (len(self.envs) - 1):
        temp_env += '\n'
      envs_value += temp_env

    volumeMountsYaml = ''
    volumesYaml = ''

    if self.volumes is not None:
      volumeMountsYaml = '\n        volumeMounts:\n'
      volumesYaml = '\n      volumes:\n'

      for index, oneVolume in enumerate(self.volumes):
        temp_volumeMount = oneVolume.volumeMountYaml()
        temp_volume = oneVolume.volumeYaml()
        if index < (len(self.volumes) - 1):
          temp_volumeMount += '\n'
          temp_volume += '\n'
        volumeMountsYaml += temp_volumeMount
        volumesYaml += temp_volume

    if self.needPrivilegedPermission:
      securityContext = '''
        securityContext:
          allowPrivilegeEscalation: true
          capabilities: {}
          privileged: true
          procMount: Default
          readOnlyRootFilesystem: false
          runAsNonRoot: false'''
    else:
      securityContext = ''

    targetFile.write(self.__template.format(self.name,
                                            self.namespace,
                                            self.selectorLabel,
                                            self.containerName,
                                            self.image,
                                            annotations_value,
                                            envs_value,
                                            volumeMountsYaml,
                                            volumesYaml,
                                            self.imagePullSecret,
                                            self.nodeTag,
                                            securityContext,
                                            self.livenessProbeTemplate))
    return
