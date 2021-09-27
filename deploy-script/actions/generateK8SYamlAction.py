from config import K8SDeploymentDirectEnv, K8SDeploymentSecretReferenceEnv, EFKLoggingService, RabbitMQService, RedisService
from k8s.clusterIPYaml import ClusterIPYamlPortInfo, ClusterIPYamlInfo
from k8s.deploymentYaml import DeploymentYamlInfo, DeploymentYamlDirectEnvInfo, DeploymentYamlAnnotation, DeploymentYamlSecretEnvReference, DeploymentYamlVolume
from k8s.nodePortYaml import NodePortYamlPortInfo, NodePortYamlInfo
from k8s.ingressYaml import IngressYamlInfo
from k8s.volumeYaml import VolumeYamlInfo, VolumeInfo
from k8s.externalNameYaml import ExternalNameYamlInfo
from actions.actionHandler import ActionHandlerBase
import log
import utils
import os.path


class YamlGenerator:
  __clusterIPNamePrefix = 'cluster-ip-'
  __deploymentPrefix = 'deployment-'
  __nodePortNamePrefix = 'node-port-'
  __ingressNamePrefix = 'ingress-'
  __externalNamePrefix = 'external-'

  def __init__(self, yamlRootDir, config, service):
    if yamlRootDir is None or yamlRootDir == '':
      self.yamlRootDir = None
    else:
      self.yamlRootDir = yamlRootDir

    self.config = config
    self.service = service
    self.dockerContext = config.dockerContext
    self.name = service.name
    self.namespace = service.namespace
    self.k8s = service.k8s

  def addYamlRoot(self, filePath):
    if self.yamlRootDir is None:
      return filePath

    return os.path.join(self.yamlRootDir, filePath)

  def create(self):
    log.highlight('create k8s yaml file for service {0}:{1}'.format(
        self.namespace, self.name))
    self.createVolume()
    self.createExternalName()
    self.createDeployment()
    self.createClusterIP()
    self.createNodePort()
    self.createIngress()
    return

  def createDeployment(self):
    selectorLabel = self.__deploymentPrefix + self.name
    image = self.dockerContext.targetRegistryBase + self.service.deployImage

    annotations = None
    if self.k8s.deployment.annotations is not None:
      annotations = []
      for annotation in self.k8s.deployment.annotations:
        annotationYaml = DeploymentYamlAnnotation(
            annotation.name, annotation.value)
        annotations.append(annotationYaml)

    envs = []
    for oneEnv in self.k8s.deployment.envs:
      if isinstance(oneEnv, K8SDeploymentDirectEnv):
        envYaml = DeploymentYamlDirectEnvInfo(oneEnv.name, oneEnv.value)
      elif isinstance(oneEnv, K8SDeploymentSecretReferenceEnv):
        envYaml = DeploymentYamlSecretEnvReference(
            oneEnv.name, oneEnv.secretKey, oneEnv.secretName)

      envs.append(envYaml)

    volumes = None
    if self.k8s.deployment.volumes is not None:
      volumes = []
      for oneVolume in self.k8s.deployment.volumes:
        volumes.append(DeploymentYamlVolume(oneVolume.name,
                                            '{0}-{1}'.format(self.namespace,
                                                             oneVolume.claimName),
                                            oneVolume.mountPath))

    info = DeploymentYamlInfo(self.name,
                              self.namespace,
                              selectorLabel,
                              self.name,
                              image,
                              self.config.k8sContext.imagePullSecrets,
                              self.k8s.deployment.nodeTag,
                              annotations,
                              envs,
                              volumes,
                              self.k8s.deployment.needPrivilegedPermission,
                              self.k8s.deployment.livenessProbe)

    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'deployment')

    info.create(self.addYamlRoot(filePath))
    return

  def createClusterIP(self):
    if self.k8s.clusterIPPorts is None or len(self.k8s.clusterIPPorts) == 0:
      return

    name = self.__clusterIPNamePrefix + self.name
    appSelector = self.__deploymentPrefix + self.name

    ports = []
    for onePort in self.k8s.clusterIPPorts:
      ports.append(ClusterIPYamlPortInfo(
          'TCP', onePort.port, onePort.targetPort))

    info = ClusterIPYamlInfo(name, self.namespace, appSelector, ports)

    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'cluster-ip')

    info.create(self.addYamlRoot(filePath))
    return

  def createNodePort(self):
    if self.k8s.nodePortPorts is None or len(self.k8s.nodePortPorts) == 0:
      return

    name = self.__nodePortNamePrefix + self.name
    appSelector = self.__deploymentPrefix + self.name

    ports = []
    for onePort in self.k8s.nodePortPorts:
      ports.append(NodePortYamlPortInfo(
          'TCP', onePort.nodePort, onePort.port, onePort.targetPort))

    info = NodePortYamlInfo(name, self.namespace, appSelector, ports)
    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'node-port')
    info.create(self.addYamlRoot(filePath))
    return

  def createIngress(self):
    if self.k8s.ingressInfo is None:
      return

    name = self.__ingressNamePrefix + self.name
    serviceName = self.__clusterIPNamePrefix + self.name

    info = IngressYamlInfo(name, self.namespace, self.k8s.ingressInfo.host, '/',
                           serviceName, self.k8s.ingressInfo.servicePort, self.config.k8sContext.ingressCertSecretName)
    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'ingress')
    info.create(self.addYamlRoot(filePath))
    return

  def createVolume(self):
    if self.k8s.volumes is None or len(self.k8s.volumes) == 0:
      return

    dataPathRoot = os.path.abspath(self.config.context.dataPathRoot)
    volumes = []
    for oneVolume in self.k8s.volumes:
      volumes.append(VolumeInfo('{0}-{1}'.format(self.namespace, oneVolume.name),
                                self.namespace,
                                oneVolume.capacityStorage,
                                dataPathRoot + '/' + oneVolume.hostPath))

    info = VolumeYamlInfo(volumes)
    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'volume')
    info.create(self.addYamlRoot(filePath))
    return

  def createExternalName(self):
    if self.k8s.externalName is None:
      return

    info = ExternalNameYamlInfo(self.__externalNamePrefix + self.k8s.externalName.name,
                                self.namespace,
                                self.k8s.externalName.externalName,
                                'TCP',
                                self.k8s.externalName.port,
                                self.k8s.externalName.targetPort)
    filePath = '{0}-config/{1}/{2}.yaml'.format(self.namespace,
                                                self.name, 'external')
    info.create(self.addYamlRoot(filePath))
    return


class ELKServiceYamlGenerator:
  def __init__(self, yamlRootDir, config, service):
    if yamlRootDir is None or yamlRootDir == '':
      self.yamlRootDir = None
    else:
      self.yamlRootDir = yamlRootDir

    self.config = config
    self.service = service
    self.dockerContext = config.dockerContext
    self.name = service.name
    self.namespace = service.namespace
    self.k8s = service.k8s

  def addYamlRoot(self, filePath):
    if self.yamlRootDir is None:
      return filePath

    return os.path.join(self.yamlRootDir, filePath)

  def create(self):
    log.highlight('create k8s yaml file for service {0}:{1}'.format(
        self.namespace, self.name))
    if self.name == 'log-elasticsearch':
      self.createElasticsearchYaml()
    elif self.name == 'fluent-bit':
      self.createFluentbitYaml()
    elif self.name == 'log-kibana':
      self.createKibanaYaml()

    return

  def createElasticsearchYaml(self):
    dataPathRoot = os.path.abspath(self.config.context.dataPathRoot)

    volumeTemplatePath = './yaml-template/logging-template/efk-elasticsearch/volume.yaml'
    clusterIPTemplatePath = './yaml-template/logging-template/efk-elasticsearch/cluster-ip.yaml'
    deploymentTemplatePath = './yaml-template/logging-template/efk-elasticsearch/deployment.yaml'

    volumeTargetPath = self.addYamlRoot(
        '{0}-config/efk-elasticsearch/volume.yaml'.format(self.namespace))
    clusterIPTargetPath = self.addYamlRoot(
        '{0}-config/efk-elasticsearch/cluster-ip.yaml'.format(self.namespace))
    deploymentTargetPath = self.addYamlRoot(
        '{0}-config/efk-elasticsearch/deployment.yaml'.format(self.namespace))

    image = self.dockerContext.targetRegistryBase + self.service.deployImage

    if self.k8s.volumes is not None:
      with open(volumeTemplatePath, 'r', encoding='utf-8') as f:
        read_data = f.read()
        utils.createDirForFile(volumeTargetPath)
        with open(volumeTargetPath, 'w', encoding='utf-8') as output:
          indexList = [i for i, value in enumerate(
              self.k8s.volumes) if value.name == 'elasticsearch']
          volume = None
          if len(indexList) == 1:
            volume = self.k8s.volumes[indexList[0]]
          volumePath = dataPathRoot + '/' + volume.hostPath if volume is not None else ''
          volumeSize = volume.capacityStorage if volume is not None else ''

          output.write(read_data.replace('VOLUME_PATH_PLACEHOLDER',
                                         volumePath).replace('VOLUME_SIZE_PLACEHOLDER', volumeSize))

    with open(clusterIPTemplatePath, 'r', encoding='utf-8') as f:
      read_data = f.read()
      utils.createDirForFile(clusterIPTargetPath)
      with open(clusterIPTargetPath, 'w', encoding='utf-8') as output:
        output.write(read_data)

    with open(deploymentTemplatePath, 'r', encoding='utf-8') as f:
      read_data = f.read()
      utils.createDirForFile(deploymentTargetPath)
      with open(deploymentTargetPath, 'w', encoding='utf-8') as output:
        output.write(read_data.replace('IMAGE_PLACEHOLDER', image)
                     .replace('NODE_SELECTOR_PLACEHOLDER', self.k8s.nodeTag)
                     .replace('IMAGE_PULL_SECRET_PLACEHOLDER', self.config.k8sContext.imagePullSecrets))

    return

  def createFluentbitYaml(self):
    templateDirBase = './yaml-template/logging-template/efk-fluent-bit/'
    justCopyFiles = ['fluent-bit-configmap.yaml', 'fluent-bit-role-binding.yaml',
                     'fluent-bit-role.yaml', 'fluent-bit-service-account.yaml']

    for one in justCopyFiles:
      src = templateDirBase + one
      target = self.addYamlRoot(
          '{0}-config/efk-fluent-bit/{1}'.format(self.namespace, one))
      with open(src, 'r', encoding='utf-8') as f:
        read_data = f.read()
        utils.createDirForFile(target)
        with open(target, 'w', encoding='utf-8') as output:
          output.write(read_data)

    srcDeploymentFilePath = templateDirBase + 'fluent-bit-ds.yaml'
    targetDeploymentFilePath = self.addYamlRoot(
        '{0}-config/efk-fluent-bit/fluent-bit-ds.yaml'.format(self.namespace))

    image = self.dockerContext.targetRegistryBase + self.service.deployImage
    with open(srcDeploymentFilePath, 'r', encoding='utf-8') as f:
      read_data = f.read()
      utils.createDirForFile(targetDeploymentFilePath)
      with open(targetDeploymentFilePath, 'w', encoding='utf-8') as output:
        output.write(read_data.replace('IMAGE_PLACEHOLDER', image)
                     .replace('NODE_SELECTOR_PLACEHOLDER', self.k8s.nodeTag)
                     .replace('IMAGE_PULL_SECRET_PLACEHOLDER', self.config.k8sContext.imagePullSecrets))
    return

  def createKibanaYaml(self):
    templateDirBase = './yaml-template/logging-template/efk-kibana/'
    justCopyFiles = ['cluster-ip.yaml', 'node-port.yaml']

    for one in justCopyFiles:
      src = templateDirBase + one
      target = self.addYamlRoot(
          '{0}-config/efk-kibana/{1}'.format(self.namespace, one))
      with open(src, 'r', encoding='utf-8') as f:
        read_data = f.read()
        utils.createDirForFile(target)
        with open(target, 'w', encoding='utf-8') as output:
          output.write(read_data)

    srcDeploymentFilePath = templateDirBase + 'deployment.yaml'
    targetDeploymentFilePath = self.addYamlRoot(
        '{0}-config/efk-kibana/deployment.yaml'.format(self.namespace))

    image = self.dockerContext.targetRegistryBase + self.service.deployImage
    with open(srcDeploymentFilePath, 'r', encoding='utf-8') as f:
      read_data = f.read()
      utils.createDirForFile(targetDeploymentFilePath)
      with open(targetDeploymentFilePath, 'w', encoding='utf-8') as output:
        output.write(read_data.replace('IMAGE_PLACEHOLDER', image)
                     .replace('NODE_SELECTOR_PLACEHOLDER', self.k8s.nodeTag)
                     .replace('IMAGE_PULL_SECRET_PLACEHOLDER', self.config.k8sContext.imagePullSecrets))
    return


class RabbitMQServiceYamlGenerator:
  def __init__(self, yamlRootDir, config, service):
    if yamlRootDir is None or yamlRootDir == '':
      self.yamlRootDir = None
    else:
      self.yamlRootDir = yamlRootDir

    self.config = config
    self.service = service
    self.dockerContext = config.dockerContext
    self.name = service.name
    self.namespace = service.namespace
    self.k8s = service.k8s

  def addYamlRoot(self, filePath):
    if self.yamlRootDir is None:
      return filePath

    return os.path.join(self.yamlRootDir, filePath)

  def create(self):
    log.highlight('create k8s yaml file for service {0}:{1}'.format(
        self.namespace, self.name))

    templateDirBase = './yaml-template/rabbitmq-template/'
    fileList = ['deployment.yaml', 'cluster-ip.yaml', 'node-port.yaml']

    image = self.dockerContext.targetRegistryBase + self.service.deployImage

    if self.k8s.rabbitMQUser == '' and self.k8s.rabbitMQPassword == '':
      rabbitMQUserPasswordPlaceHolder = ''
    elif self.k8s.rabbitMQUser != '' and self.k8s.rabbitMQPassword != '':
      rabbitMQUserPasswordPlaceHolder = '''
            - name: RABBITMQ_DEFAULT_PASS
              value: {0}
            - name: RABBITMQ_DEFAULT_USER
              value: {1}'''.format(self.k8s.rabbitMQPassword, self.k8s.rabbitMQUser)
    else:
      raise ValueError(
          'rabbitMQUser and rabbitMQPassword both must be empty or not empty')

    for one in fileList:
      src = templateDirBase + one
      target = self.addYamlRoot(
          '{0}-config/{1}/{2}'.format(self.namespace, self.name, one))

      with open(src, 'r', encoding='utf-8') as f:
        read_data = f.read()
        read_data = read_data.replace('NAME_PLACEHOLDER', self.name)
        read_data = read_data.replace('NAMESPACE_PLACEHOLDER', self.namespace)
        read_data = read_data.replace('IMAGE_PLACEHOLDER', image)
        read_data = read_data.replace(
            'RABBITMQ_ERLANG_COOKIE_PLACEHOLDER', self.k8s.rabbitMQErlangCookie)
        read_data = read_data.replace(
            'IMAGE_PULL_SECRET_PLACEHOLDER', self.config.k8sContext.imagePullSecrets)
        read_data = read_data.replace(
            'NODE_SELECTOR_PLACEHOLDER', self.k8s.nodeTag)
        read_data = read_data.replace(
            'NODEPORT_PORT_PLACEHOLDER', str(self.k8s.nodePort))
        read_data = read_data.replace(
            'OPTIONAL_USER_PASSWORD_PLACEHOLDER', rabbitMQUserPasswordPlaceHolder)

        utils.createDirForFile(target)
        with open(target, 'w', encoding='utf-8') as output:
          output.write(read_data)

    return


class RedisServiceYamlGenerator:
  def __init__(self, yamlRootDir, config, service):
    if yamlRootDir is None or yamlRootDir == '':
      self.yamlRootDir = None
    else:
      self.yamlRootDir = yamlRootDir

    self.config = config
    self.service = service
    self.dockerContext = config.dockerContext
    self.name = service.name
    self.namespace = service.namespace
    self.k8s = service.k8s

  def addYamlRoot(self, filePath):
    if self.yamlRootDir is None:
      return filePath

    return os.path.join(self.yamlRootDir, filePath)

  def create(self):
    log.highlight('create k8s yaml file for service {0}:{1}'.format(
        self.namespace, self.name))

    templateDirBase = './yaml-template/redis-template/'
    fileList = ['deployment.yaml', 'cluster-ip.yaml']

    image = self.dockerContext.targetRegistryBase + self.service.deployImage

    for one in fileList:
      src = templateDirBase + one
      target = self.addYamlRoot(
          '{0}-config/{1}/{2}'.format(self.namespace, self.name, one))

      with open(src, 'r', encoding='utf-8') as f:
        read_data = f.read()
        read_data = read_data.replace('NAME_PLACEHOLDER', self.name)
        read_data = read_data.replace('NAMESPACE_PLACEHOLDER', self.namespace)
        read_data = read_data.replace('IMAGE_PLACEHOLDER', image)
        read_data = read_data.replace(
            'REDIS_PASSWORD_PLACEHOLDER', self.k8s.redisPassword)
        read_data = read_data.replace(
            'IMAGE_PULL_SECRET_PLACEHOLDER', self.config.k8sContext.imagePullSecrets)
        read_data = read_data.replace(
            'NODE_SELECTOR_PLACEHOLDER', self.k8s.nodeTag)
        utils.createDirForFile(target)
        with open(target, 'w', encoding='utf-8') as output:
          output.write(read_data)

    return


class GenerateK8SYamlAction(ActionHandlerBase):
  def doWork(self, config, cmdArgs):
    utils.printSectionLine('GENERATE K8S YAML FILE', 80, '*')
    for service in config.services:
      generator = None
      if isinstance(service, EFKLoggingService):
        generator = ELKServiceYamlGenerator(
            config.k8sContext.yamlOutputRootDir, config, service)
      elif isinstance(service, RabbitMQService):
        generator = RabbitMQServiceYamlGenerator(
            config.k8sContext.yamlOutputRootDir, config, service)
      elif isinstance(service, RedisService):
        generator = RedisServiceYamlGenerator(
            config.k8sContext.yamlOutputRootDir, config, service)
      else:
        generator = YamlGenerator(
            config.k8sContext.yamlOutputRootDir, config, service)
      generator.create()

  def actionName(self):
    return 'K8S Service --- generate k8s YAML files'
