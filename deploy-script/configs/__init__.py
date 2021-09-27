import json
import os.path

from .decoder import decoder
from utils import printSectionLine

'''
加载JSON配置文件
'''


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


'''
打印JSON配置文件的关键信息
'''


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
