import json
import os.path

from utils import printSectionLine
from prompt import confirm


class ConfigBase:
  def __init__(self, *pArgs):
    for index, p in enumerate(self.required()):
      setattr(self, p, pArgs[index])

    indexOffset = len(self.required())
    for index, p in enumerate(self.optional()):
      setattr(self, p, pArgs[indexOffset + index])

  def validate(self):
    pass

  @classmethod
  def required(cls):
    return []

  @classmethod
  def optional(cls):
    return []


class Config(ConfigBase):
  @classmethod
  def required(cls):
    return ['context', 'services', 'dockerContext']

  @classmethod
  def optional(cls):
    return ['k8sContext', 'dbInitializers', 'nginxContext', 'dbBackupAndRestoreContext']


class Context(ConfigBase):
  @classmethod
  def required(cls):
    return ['customer', 'project', 'env', 'description', 'mode', 'os', 'osVersion', 'imageOutputRootDir', 'dataPathRoot']


class Service(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'namespace', 'imageCategory', 'srcImage']

  @classmethod
  def optional(cls):
    return ['k8s', 'docker', 'deployImage']

  def validate(self):
    if getattr(self, 'k8s') is None and getattr(self, 'docker') is None:
      raise ValueError('{0} must have k8s or docker config, but both are None'.format(
          self.__class__.__name__))


class ServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['deployment']

  @classmethod
  def optional(cls):
    return ['clusterIPPorts',
            'nodePortPorts',
            'ingressInfo',
            'volumes',
            'externalName']


class ServiceDockerConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['containerName', 'restart', 'useHostNetwork', 'ports', 'envs', 'volumes', 'command']

  @classmethod
  def optional(cls):
    return ['privileged', 'dockerRunOptions']


class K8SDeploymentDirectEnv(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'value']


class K8SDeploymentAnnotation(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'value']


class K8SDeploymentSecretReferenceEnv(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'secretKey', 'secretName']


class K8SDeploymentVolume(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'claimName', 'mountPath']


class K8SDeployment(ConfigBase):
  @classmethod
  def required(cls):
    return ['nodeTag', 'envs']

  @classmethod
  def optional(cls):
    return ['annotations', 'volumes', 'needPrivilegedPermission', 'livenessProbe']


class K8SExternalName(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'externalName', 'port', 'targetPort']


class K8SVolume(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'capacityStorage', 'hostPath']


class K8SClusterIPPort(ConfigBase):
  @classmethod
  def required(cls):
    return ["port", "targetPort"]


class K8SNodePortPort(ConfigBase):
  @classmethod
  def required(cls):
    return ['nodePort', 'port', 'targetPort']


class K8SIngress(ConfigBase):
  @classmethod
  def required(cls):
    return ['host', 'servicePort']


class K8SContext(ConfigBase):
  @classmethod
  def required(cls):
    return ['namespaces', 'imagePullSecrets', 'yamlOutputRootDir']

  @classmethod
  def optional(cls):
    return ['ingressCertSecretName', 'ingressSecretCertPath', 'ingressSecretKeyPath']


class DockerContext(ConfigBase):
  @classmethod
  def required(cls):
    return ['srcRegistryBase']

  @classmethod
  def optional(cls):
    return ['targetRegistryBase', 'targetRegistryUser', 'targetRegistryPassword']


class NginxContext(ConfigBase):
  @classmethod
  def required(cls):
    return ['certDir', 'targetNginxDir', 'servers', 'containerName', 'srcImage', 'imageCategory']


class NginxServerConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['comment', 'sslListenPort', 'serverName', 'proxyPass']


class DatabaseInitializer(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'imageCategory', 'srcImage', 'envs']

  @classmethod
  def optional(cls):
    return ['useHostNetwork']


class DBBackupAndRestoreContext(ConfigBase):
  @classmethod
  def required(cls):
    return ['imageCategory', 'srcImage', 'databases']


class DatabaseInfo(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'server', 'port', 'user', 'password', 'diskDir', 'useHostNetwork']


class EFKLoggingService(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'namespace', 'imageCategory', 'srcImage']

  @classmethod
  def optional(cls):
    return ['k8s', 'deployImage']


class EFKLoggingServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['nodeTag']

  @classmethod
  def optional(cls):
    return ['volumes']


class RabbitMQService(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'namespace', 'imageCategory', 'srcImage']

  @classmethod
  def optional(cls):
    return ['k8s', 'deployImage']


class RabbitMQServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['nodeTag', 'nodePort', 'rabbitMQErlangCookie', 'rabbitMQUser', 'rabbitMQPassword']


class RedisService(ConfigBase):
  @classmethod
  def required(cls):
    return ['name', 'namespace', 'imageCategory', 'srcImage']

  @classmethod
  def optional(cls):
    return ['k8s', 'deployImage']


class RedisServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return ['nodeTag', 'redisPassword']


def __decoder(cls, obj):
  requiredProperties = []
  optionalProperties = []

  for p in cls.required():
    if p not in obj:
      raise ValueError(
          '{0} is missing required property {1}'.format(cls.__name__, p))
    requiredProperties.append(obj[p])

  for p in cls.optional():
    if p not in obj:
      optionalProperties.append(None)
    else:
      optionalProperties.append(obj[p])

  instance = cls(*requiredProperties, *optionalProperties)
  instance.validate()
  return instance


def decoder(obj):
  configClassesDict = {
      'Config': Config,
      'Context': Context,
      'Service': Service,
      'ServiceK8SConfig': ServiceK8SConfig,
      'ServiceDockerConfig': ServiceDockerConfig,
      'K8SClusterIPPort': K8SClusterIPPort,
      'K8SNodePortPort': K8SNodePortPort,
      'K8SDeployment': K8SDeployment,
      'K8SDeploymentAnnotation': K8SDeploymentAnnotation,
      'K8SDeploymentDirectEnv': K8SDeploymentDirectEnv,
      'K8SDeploymentSecretReferenceEnv': K8SDeploymentSecretReferenceEnv,
      'K8SDeploymentVolume': K8SDeploymentVolume,
      'K8SIngress': K8SIngress,
      'K8SVolume': K8SVolume,
      'K8SExternalName': K8SExternalName,
      'DockerContext': DockerContext,
      'K8SContext': K8SContext,
      'NginxContext': NginxContext,
      'NginxServerConfig': NginxServerConfig,
      'DatabaseInitializer': DatabaseInitializer,
      'EFKLoggingService': EFKLoggingService,
      'EFKLoggingServiceK8SConfig': EFKLoggingServiceK8SConfig,
      'RabbitMQService': RabbitMQService,
      'RabbitMQServiceK8SConfig': RabbitMQServiceK8SConfig,
      'RedisService': RedisService,
      'RedisServiceK8SConfig': RedisServiceK8SConfig,
      'DBBackupAndRestoreContext': DBBackupAndRestoreContext,
      'DatabaseInfo': DatabaseInfo
  }

  if '__type__' in obj and obj['__type__'] in configClassesDict:
    return __decoder(configClassesDict[obj['__type__']], obj)

  return obj


def printKeyInformation(config):
  printSectionLine('HERE IS CONFIG', 80, '#')

  printSectionLine('CONTEXT', 80)
  print('customer={0}'.format(config.context.customer))
  print('project={0}'.format(config.context.project))
  print('env={0}'.format(config.context.env))
  print('mode={0}'.format(config.context.mode))
  print('os={0}'.format(config.context.os))
  print('osVersion={0}'.format(config.context.osVersion))
  print('dataPathRoot={0}'.format(config.context.dataPathRoot))

  printSectionLine('DOCKER CONTEXT', 80)
  print('srcRegistryBase={0}'.format(config.dockerContext.srcRegistryBase))
  if config.dockerContext.targetRegistryBase is not None:
    print('targetRegistryBase={0}'.format(
        config.dockerContext.targetRegistryBase))

  printSectionLine('SERVICES', 80)
  for index, service in enumerate(config.services):
    print('[{}] {}:{}, imageCategory={}, srcImage={}'.format(
        index + 1, service.namespace, service.name, service.imageCategory, service.srcImage))

  if config.k8sContext is not None:
    printSectionLine('K8S CONTEXT', 80)
    print('imagePullSecrets={0}'.format(config.k8sContext.imagePullSecrets))
    print('ingressCertSecretName={0}'.format(
        config.k8sContext.ingressCertSecretName))
    print('yamlOutputRootDir={0}'.format(config.k8sContext.yamlOutputRootDir))

  if config.nginxContext is not None:
    printSectionLine('NGINX CONTEXT', 80)
    print('certDir={0}'.format(config.nginxContext.certDir))
    print('targetNginxDir={0}'.format(config.nginxContext.targetNginxDir))
    print('containerName={0}'.format(config.nginxContext.containerName))
    print('srcImage={0}'.format(config.nginxContext.srcImage))
    print('include servers as below:')
    for index, oneServer in enumerate(config.nginxContext.servers):
      print('  [{}] {:30}\t{}\t{}\t{}'.format(index+1,
                                              oneServer.comment,
                                              oneServer.sslListenPort,
                                              oneServer.serverName,
                                              oneServer.proxyPass))

  printSectionLine('', 80, '#')
  return


def loadConfig(configPath, showKeyInfo=True):
  if not os.path.isfile(configPath):
    raise ValueError(
        'config {0} is not exist or not a file'.format(configPath))

  configFile = open(configPath, 'r', encoding='utf-8')
  content = configFile.read()

  try:
    jsonConfig = json.loads(content, object_hook=decoder)
    if showKeyInfo:
      printKeyInformation(jsonConfig)
    return jsonConfig
  except Exception as e:
    raise Exception('parse config with error: {0}'.format(e))
