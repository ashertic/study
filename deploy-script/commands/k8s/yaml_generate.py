import os
import log
import jinja2
import utils

from configs.efk_logging_service import EFKLoggingService
from configs.rabbitmq_service import RabbitMQService
from configs.redis_service import RedisService
from commands.cmd_action_base import CommandActionBase


class Generator:
  def __init__(self, yamlRootDir, config, service, jinja_template_root) -> None:
    self.yamlRootDir = yamlRootDir
    self.config = config
    self.service = service
    self.dockerContext = config.dockerContext
    self.name = service.name
    self.namespace = service.namespace
    self.k8s = service.k8s
    self.jinja_template_root = jinja_template_root

  def generate_from_jinja_template(self, template, values, yaml_file):
    template_root = os.path.abspath(self.jinja_template_root)
    template_loader = jinja2.FileSystemLoader(template_root)
    template_env = jinja2.Environment(loader=template_loader)
    template = template_env.get_template(template)
    content = template.render(values)

    if self.yamlRootDir is not None and self.yamlRootDir != '':
      yaml_file = os.path.join(self.yamlRootDir, yaml_file)
    utils.createDirForFile(yaml_file)
    targetFile = open(yaml_file, 'w', encoding='utf-8')
    targetFile.write(content)
    targetFile.close()

  def create(self):
    pass


class GeneralGenerator(Generator):
  __clusterIPNamePrefix = 'cluster-ip-'
  __deploymentPrefix = 'deployment-'
  __externalNamePrefix = 'external-'
  __nodePortNamePrefix = 'node-port-'
  __ingressNamePrefix = 'ingress-'

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

  def createVolume(self):
    if self.k8s.volumes is None or len(self.k8s.volumes) == 0:
      return

    dataPathRoot = os.path.abspath(self.config.context.dataPathRoot)
    volumes = []
    for oneVolume in self.k8s.volumes:
      one_volume_obj = {}
      one_volume_obj['name'] = f'{self.namespace}-{oneVolume.name}'
      one_volume_obj['namespace'] = self.namespace
      one_volume_obj['capacityStorage'] = oneVolume.capacityStorage
      one_volume_obj['hostPath'] = os.path.join(
          dataPathRoot, oneVolume.hostPath)
      volumes.append(one_volume_obj)

    filePath = f'{self.namespace}-config/{self.name}/volume.yaml'
    self.generate_from_jinja_template(
        'volume.yaml.jinja', {'volumes': volumes}, filePath)
    return

  def createExternalName(self):
    if self.k8s.externalName is None:
      return

    externalname_obj = {}
    externalname_obj['name'] = self.__externalNamePrefix + \
        self.k8s.externalName.name
    externalname_obj['namespace'] = self.namespace
    externalname_obj['externalName'] = self.k8s.externalName.externalName
    externalname_obj['protocol'] = 'TCP'
    externalname_obj['port'] = self.k8s.externalName.port
    externalname_obj['targetPort'] = self.k8s.externalName.targetPort

    filePath = f'{self.namespace}-config/{self.name}/external.yaml'
    self.generate_from_jinja_template(
        'externalname.yaml.jinja', externalname_obj, filePath)
    return

  def createDeployment(self):
    deployment_obj = dict()
    deployment_obj['name'] = self.name
    deployment_obj['namespace'] = self.namespace
    deployment_obj['selectorLabel'] = self.__deploymentPrefix + self.name
    deployment_obj['containerName'] = self.name
    deployment_obj['image'] = self.dockerContext.targetRegistryBase + \
        self.service.deployImage

    deployment_obj['imagePullSecrets'] = [
        self.config.k8sContext.imagePullSecrets]
    deployment_obj['nodeTag'] = self.k8s.deployment.nodeTag

    if self.k8s.deployment.annotations is not None:
      deployment_obj['annotations'] = []
      for annotation in self.k8s.deployment.annotations:
        deployment_obj['annotations'].append(
            (annotation.name, annotation.value))

    if self.k8s.deployment.envs is not None:
      deployment_obj['envs'] = []
      for oneEnv in self.k8s.deployment.envs:
        deployment_obj['envs'].append((oneEnv.name, oneEnv.value))

    if self.k8s.deployment.volumes is not None:
      deployment_obj['volumes'] = []
      for oneVolume in self.k8s.deployment.volumes:
        volume_obj = dict()
        volume_obj['name'] = oneVolume.name
        volume_obj['claimName'] = f'{self.namespace}-{oneVolume.claimName}'
        volume_obj['mountPath'] = oneVolume.mountPath
        deployment_obj['volumes'].append(volume_obj)

    if self.k8s.deployment.needPrivilegedPermission is not None and self.k8s.deployment.needPrivilegedPermission:
      deployment_obj['needPrivilegedPermission'] = True
    else:
      deployment_obj['needPrivilegedPermission'] = False

    deployment_obj['livenessProbe'] = self.k8s.deployment.livenessProbe

    filePath = f'{self.namespace}-config/{self.name}/deployment.yaml'
    self.generate_from_jinja_template(
        'deployment.yaml.jinja', deployment_obj, filePath)
    return

  def createClusterIP(self):
    if self.k8s.clusterIPPorts is None or len(self.k8s.clusterIPPorts) == 0:
      return

    clusterip_obj = {}
    clusterip_obj['name'] = self.__clusterIPNamePrefix + self.name
    clusterip_obj['namespace'] = self.namespace
    clusterip_obj['appSelector'] = self.__deploymentPrefix + self.name

    ports = []
    for onePort in self.k8s.clusterIPPorts:
      one_port_obj = {}
      one_port_obj['protocol'] = 'TCP'
      one_port_obj['port'] = onePort.port
      one_port_obj['targetPort'] = onePort.targetPort
      ports.append(one_port_obj)
    clusterip_obj['ports'] = ports

    filePath = f'{self.namespace}-config/{self.name}/cluster-ip.yaml'
    self.generate_from_jinja_template(
        'clusterip.yaml.jinja', clusterip_obj, filePath)
    return

  def createNodePort(self):
    if self.k8s.nodePortPorts is None or len(self.k8s.nodePortPorts) == 0:
      return

    nodeport_obj = {}
    nodeport_obj['name'] = self.__nodePortNamePrefix + self.name
    nodeport_obj['namespace'] = self.namespace
    nodeport_obj['appSelector'] = self.__deploymentPrefix + self.name

    ports = []
    for onePort in self.k8s.nodePortPorts:
      one_port_obj = {}
      one_port_obj['protocol'] = 'TCP'
      one_port_obj['nodePort'] = onePort.nodePort
      one_port_obj['port'] = onePort.port
      one_port_obj['targetPort'] = onePort.targetPort
      ports.append(one_port_obj)
    nodeport_obj['ports'] = ports

    filePath = f'{self.namespace}-config/{self.name}/node-port.yaml'
    self.generate_from_jinja_template(
        'nodeport.yaml.jinja', nodeport_obj, filePath)
    return

  def createIngress(self):
    if self.k8s.ingressInfo is None:
      return

    ingress_obj = {}
    ingress_obj['name'] = self.__ingressNamePrefix + self.name
    ingress_obj['namespace'] = self.namespace
    ingress_obj['host'] = self.k8s.ingressInfo.host
    ingress_obj['path'] = '/'
    ingress_obj['serviceName'] = self.__clusterIPNamePrefix + self.name
    ingress_obj['servicePort'] = self.k8s.ingressInfo.servicePort
    ingress_obj['secretName'] = self.config.k8sContext.ingressCertSecretName

    filePath = f'{self.namespace}-config/{self.name}/ingress.yaml'
    self.generate_from_jinja_template(
        'ingress.yaml.jinja', ingress_obj, filePath)
    return


class RedisServiceGenerator(Generator):
  def create(self):
    log.highlight(
        f'create k8s yaml file for service {self.namespace}:{self.name}')

    selectorLabel = f'deployment-{self.name}'

    deployment_obj = {
        'name': self.name,
        'namespace': self.namespace,
        'selectorLabel': selectorLabel,
        'containerName': self.name,
        'image': self.dockerContext.targetRegistryBase + self.service.deployImage,
        'redis_password': self.k8s.redisPassword,
        'imagePullSecrets': self.config.k8sContext.imagePullSecrets,
        'nodeTag': self.k8s.nodeTag
    }
    deployment_yaml_file = f'{self.namespace}-config/{self.name}/deployment.yaml'
    self.generate_from_jinja_template(
        'deployment.yaml.jinja', deployment_obj, deployment_yaml_file)

    clusterip_obj = {
        'name': f'cluster-ip-{self.name}',
        'namespace': self.namespace,
        'selectorLabel': selectorLabel,
    }
    clusterip_yaml_file = f'{self.namespace}-config/{self.name}/cluster-ip.yaml'
    self.generate_from_jinja_template(
        'clusterip.yaml.jinja', clusterip_obj, clusterip_yaml_file)
    return


class RabbitMQServiceGenerator(Generator):
  def create(self):
    log.highlight(
        f'create k8s yaml file for service {self.namespace}:{self.name}')

    selectorLabel = f'deployment-{self.name}'

    deployment_obj = {
        'name': self.name,
        'namespace': self.namespace,
        'selectorLabel': selectorLabel,
        'containerName': self.name,
        'image': self.dockerContext.targetRegistryBase + self.service.deployImage,
        'imagePullSecrets': self.config.k8sContext.imagePullSecrets,
        'nodeTag': self.k8s.nodeTag,
        'rabbitMQErlangCookie': self.k8s.rabbitMQErlangCookie,
    }
    if self.k8s.rabbitMQUser is not None and self.k8s.rabbitMQUser != '':
      deployment_obj['defaultUser'] = self.k8s.rabbitMQUser
    if self.k8s.rabbitMQPassword is not None and self.k8s.rabbitMQPassword != '':
      deployment_obj['defaultPassword'] = self.k8s.rabbitMQPassword
    deployment_yaml_file = f'{self.namespace}-config/{self.name}/deployment.yaml'
    self.generate_from_jinja_template(
        'deployment.yaml.jinja', deployment_obj, deployment_yaml_file)

    clusterip_obj = {
        'name': f'cluster-ip-{self.name}',
        'namespace': self.namespace,
        'selectorLabel': selectorLabel,
    }
    clusterip_yaml_file = f'{self.namespace}-config/{self.name}/cluster-ip.yaml'
    self.generate_from_jinja_template(
        'cluster-ip.yaml.jinja', clusterip_obj, clusterip_yaml_file)

    nodeport_obj = {
        'name': f'node-port-{self.name}-management',
        'namespace': self.namespace,
        'selectorLabel': selectorLabel,
        'nodeport': str(self.k8s.nodePort)
    }
    nodeport_yaml_file = f'{self.namespace}-config/{self.name}/node-port.yaml'
    self.generate_from_jinja_template(
        'node-port.yaml.jinja', nodeport_obj, nodeport_yaml_file)
    return


class ELKServiceGenerator(Generator):
  def create(self):
    log.highlight(
        f'create k8s yaml file for service {self.namespace}:{self.name}')
    if self.name == 'log-elasticsearch':
      self.jinja_template_root = './k8s/templates/logging/efk-elasticsearch'
      self.createElasticsearchYaml()
    elif self.name == 'fluent-bit':
      self.jinja_template_root = './k8s/templates/logging/efk-fluent-bit'
      self.createFluentbitYaml()
    elif self.name == 'log-kibana':
      self.jinja_template_root = './k8s/templates/logging/efk-kibana'
      self.createKibanaYaml()
    return

  def createElasticsearchYaml(self):
    dataPathRoot = os.path.abspath(self.config.context.dataPathRoot)
    image = self.dockerContext.targetRegistryBase + self.service.deployImage

    if self.k8s.volumes is not None:
      volume = None
      indexList = [i for i, value in enumerate(
          self.k8s.volumes) if value.name == 'elasticsearch']
      if len(indexList) == 1:
        volume = self.k8s.volumes[indexList[0]]
      if volume is not None:
        volumePath = os.path.join(dataPathRoot, volume.hostPath)
        volumeSize = volume.capacityStorage
        volume_obj = {
            'volumeSize': volumeSize,
            'volumePath': volumePath
        }
        volume_yaml_file = f'{self.namespace}-config/efk-elasticsearch/volume.yaml'
        self.generate_from_jinja_template(
            'volume.yaml.jinja', volume_obj, volume_yaml_file)

    clusterip_obj = {}
    clusterip_yaml_file = f'{self.namespace}-config/efk-elasticsearch/cluster-ip.yaml'
    self.generate_from_jinja_template(
        'cluster-ip.yaml.jinja', clusterip_obj, clusterip_yaml_file)

    deployment_obj = {
        'image': image,
        'nodeTag': self.k8s.nodeTag,
        'imagePullSecrets': self.config.k8sContext.imagePullSecrets
    }
    deployment_yaml_file = f'{self.namespace}-config/efk-elasticsearch/deployment.yaml'
    self.generate_from_jinja_template(
        'deployment.yaml.jinja', deployment_obj, deployment_yaml_file)
    return

  def createFluentbitYaml(self):
    only_copied_files = [
        ('fluent-bit-configmap.yaml.jinja', 'fluent-bit-configmap.yaml'),
        ('fluent-bit-role-binding.yaml.jinja', 'fluent-bit-role-binding.yaml'),
        ('fluent-bit-role.yaml.jinja', 'fluent-bit-role.yaml'),
        ('fluent-bit-service-account.yaml.jinja', 'fluent-bit-service-account.yaml')
    ]
    for template, target_name in only_copied_files:
      target = f'{self.namespace}-config/efk-fluent-bit/{target_name}'
      self.generate_from_jinja_template(template, {}, target)

    deployment_obj = {
        'image': self.dockerContext.targetRegistryBase + self.service.deployImage,
        'imagePullSecrets': self.config.k8sContext.imagePullSecrets
    }
    deployment_yaml = f'{self.namespace}-config/efk-fluent-bit/fluent-bit-ds.yaml'
    self.generate_from_jinja_template(
        'fluent-bit-ds.yaml.jinja', deployment_obj, deployment_yaml)
    return

  def createKibanaYaml(self):
    only_copied_files = [
        ('cluster-ip.yaml.jinja', 'cluster-ip.yaml'),
        ('node-port.yaml.jinja', 'node-port.yaml')
    ]
    for template, target_name in only_copied_files:
      target = f'{self.namespace}-config/efk-kibana/{target_name}'
      self.generate_from_jinja_template(template, {}, target)

    deployment_obj = {
        'image': self.dockerContext.targetRegistryBase + self.service.deployImage,
        'nodeTag': self.k8s.nodeTag,
        'imagePullSecrets': self.config.k8sContext.imagePullSecrets
    }
    deployment_yaml = f'{self.namespace}-config/efk-kibana/deployment.yaml'
    self.generate_from_jinja_template(
        'deployment.yaml.jinja', deployment_obj, deployment_yaml)
    return


class K8SYamlGenerateAction(CommandActionBase):
  def __init__(self, config) -> None:
    self.config = config
    self.services = config.services

  def execute(self):
    print(f'generate yaml config from JSON')
    yamlOutputRootDir = self.config.k8sContext.yamlOutputRootDir
    for service in self.services:
      generator = None
      if isinstance(service, EFKLoggingService):
        generator = ELKServiceGenerator(
            yamlOutputRootDir, self.config, service, '')
      elif isinstance(service, RabbitMQService):
        generator = RabbitMQServiceGenerator(
            yamlOutputRootDir, self.config, service, './k8s/templates/rabbitmq')
      elif isinstance(service, RedisService):
        generator = RedisServiceGenerator(
            yamlOutputRootDir, self.config, service, './k8s/templates/redis')
      else:
        generator = GeneralGenerator(
            yamlOutputRootDir, self.config, service, './k8s/templates/general')
      generator.create()
