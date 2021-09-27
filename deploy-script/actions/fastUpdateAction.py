from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import time
import subprocess
from config import EFKLoggingService, RabbitMQService, RedisService


class FastUpdateAction(ActionHandlerBase):
  def __saveImageToFile(self, imageTag, filePath):

    print('save image {0} to: '.format(imageTag), end='')
    log.highlight(filePath)
    utils.createDirForFile(filePath)

    with open(filePath, "wb") as imageFile:
      p1 = subprocess.Popen(
          ['docker', 'save', imageTag], stdout=subprocess.PIPE)
      p2 = subprocess.Popen(
          ['gzip'], stdin=p1.stdout, stdout=imageFile)
      p1.stdout.close()
      p2.communicate()[0]
      log.highlight('save image to file successfully')
    return

  def __loadImageFromFile(self, filePath):
    cmd1 = ['gunzip', '-c', filePath]
    cmd2 = ['docker', 'load']
    isSuccessful = command.executeWithPipe(cmd1, cmd2)

    if isSuccessful:
      log.highlight('load image from file successfully')
    else:
      log.error('load image from file failed')
    return

  def __saveOneServiceImage(self, service, dockerContext, imageOutputRootDir):
    fullSrcImage = dockerContext.srcRegistryBase + service.srcImage

    if fullSrcImage in self.already_downloaded_images:
      print('skip pulling image because it already pulled with other services: {0}'.format(
          fullSrcImage))
      return

    self.already_downloaded_images.add(fullSrcImage)
    print('pull {0}:{1} source image from: '.format(
        service.namespace, service.name), end='')
    log.highlight(fullSrcImage)
    isSuccessfull = command.execute(['docker', 'pull', fullSrcImage])
    if isSuccessfull:
      log.highlight('pull image successfully')
    else:
      log.error('pull image failed')
      # TODO: should exit script

    imageFilePath = self.getServiceImageFilePath(service, imageOutputRootDir)
    self.__saveImageToFile(fullSrcImage, imageFilePath)

  def __pushImageToPrivateRegistry(self, imageTag):
    isSuccessful = command.execute(['docker', 'push', imageTag])
    if isSuccessful:
      log.highlight('push image successfully')
    else:
      log.error('push image failed')
    return

  def __loadPushOneServiceImage(self, service, dockerContext, imageOutputRootDir):
    imageFilePath = self.getServiceImageFilePath(service, imageOutputRootDir)

    if imageFilePath in self.file_already_loaded:
      print('skip load image from file because it already loaded with other services: {0}'.format(
          imageFilePath))
      return

    self.file_already_loaded.add(imageFilePath)
    print('load {0}:{1} service image from: '.format(
        service.namespace, service.name), end='')
    log.highlight(imageFilePath)
    self.__loadImageFromFile(imageFilePath)

    fullSrcImage = dockerContext.srcRegistryBase + service.srcImage
    deploytImage = dockerContext.targetRegistryBase + service.deployImage
    print('tag image {0} with new tag: '.format(fullSrcImage), end='')
    log.highlight(deploytImage)
    command.execute(['docker', 'tag', fullSrcImage, deploytImage])

    print('push {0}:{1} service image: '.format(
        service.namespace, service.name), end='')
    log.highlight(deploytImage)
    self.__pushImageToPrivateRegistry(deploytImage)

    cmd = ['docker', 'image', 'rm', fullSrcImage]
    command.execute(cmd)
    return

  def __loginPrivateResgistry(self, dockerContext):
    target = dockerContext.targetRegistryBase.replace('/', '')
    user = dockerContext.targetRegistryUser
    password = dockerContext.targetRegistryPassword
    command.execute(
        ['docker', 'login', '--username', user, '--password', password, target])
    return

  def __installFromYaml(self, service, config, kind, logKind):
    filePath = '{0}-config/{1}/{2}.yaml'.format(
        service.namespace, service.name, kind)
    filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
    isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
    if isSuccessful:
      log.highlight('{0}:{1} create {2} sucessfully'.format(
          service.namespace, service.name, logKind))
    else:
      log.error('{0}:{1} create {2} failed'.format(
          service.namespace, service.name, logKind))

  def __installEFKLoggingElasticsearch(self, service, config):
    serviceDir = 'efk-elasticsearch'
    allPartsInOrder = [
        ('deployment.yaml', 'related K8S Deployment'),
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} create {2} sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} create {2} failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __installEFKLoggingFluentbit(self, service, config):
    serviceDir = 'efk-fluent-bit'
    allPartsInOrder = [
        ('fluent-bit-service-account.yaml', 'related K8S service account'),
        ('fluent-bit-role.yaml', 'related K8S role'),
        ('fluent-bit-role-binding.yaml', 'related K8S role binding'),
        ('fluent-bit-configmap.yaml', 'related K8S configmap'),
        ('fluent-bit-ds.yaml', 'related K8S DaemonSet Service'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} create {2} sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} create {2} failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __installEFKLoggingKibana(self, service, config):
    serviceDir = 'efk-kibana'
    allPartsInOrder = [
        ('deployment.yaml', 'related K8S Deployment'),
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
        ('node-port.yaml', 'related K8S NodePort Service')
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} create {2} sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} create {2} failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __installSpecialService(self, service, config):
    k8s = service.k8s

    self.__installFromYaml(service, config, 'deployment',
                           'related K8S Deployment')
    self.__installFromYaml(service, config, 'cluster-ip',
                           'related K8S ClusterIP Service')

    if hasattr(k8s, 'nodePort') and k8s.nodePort is not None:
      self.__installFromYaml(service, config, 'node-port',
                             'related K8S NodePort Service')

    return

  def __installOneService(self, service, config):
    if isinstance(service, EFKLoggingService):
      if service.name == 'log-elasticsearch':
        self.__installEFKLoggingElasticsearch(service, config)
      elif service.name == 'fluent-bit':
        self.__installEFKLoggingFluentbit(service, config)
      elif service.name == 'log-kibana':
        self.__installEFKLoggingKibana(service, config)
    elif isinstance(service, RabbitMQService):
      self.__installSpecialService(service, config)
    elif isinstance(service, RedisService):
      self.__installSpecialService(service, config)
    else:
      k8s = service.k8s

      if k8s.externalName is not None:
        self.__installFromYaml(service, config, 'external',
                               'related ExternalName K8S Service')

      if k8s.volumes is not None and len(k8s.volumes) > 0:
        self.__installFromYaml(service, config, 'volume',
                               'related K8S Volumes')

      self.__installFromYaml(service, config, 'deployment',
                             'related K8S Deployment')

      if k8s.clusterIPPorts is not None and len(k8s.clusterIPPorts) > 0:
        self.__installFromYaml(service, config, 'cluster-ip',
                               'related K8S ClusterIP Service')

      if k8s.nodePortPorts is not None and len(k8s.nodePortPorts) > 0:
        self.__installFromYaml(service, config, 'node-port',
                               'related K8S NodePort Service')

      if 'ingressInfo' in k8s.__dict__ or k8s.ingressInfo is not None:
        self.__installFromYaml(service, config, 'ingress',
                               'related K8S Ingress Service')

    return

  def __removeFromYaml(self, service, config, kind, logKind):
    filePath = '{0}-config/{1}/{2}.yaml'.format(
        service.namespace, service.name, kind)
    filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
    isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
    if isSuccessful:
      log.highlight('{0}:{1} {2} is removed sucessfully'.format(
          service.namespace, service.name, logKind))
    else:
      log.error('{0}:{1} {2} is removed failed'.format(
          service.namespace, service.name, logKind))

  def __removeEFKLoggingElasticsearch(self, service, config):
    serviceDir = 'efk-elasticsearch'
    allPartsInOrder = [
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
        ('deployment.yaml', 'related K8S Deployment'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} {2} is removed sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} {2} is removed failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __removeEFKLoggingFluentbit(self, service, config):
    serviceDir = 'efk-fluent-bit'
    allPartsInOrder = [
        ('fluent-bit-ds.yaml', 'related K8S DaemonSet Service'),
        ('fluent-bit-configmap.yaml', 'related K8S configmap'),
        ('fluent-bit-role-binding.yaml', 'related K8S role binding'),
        ('fluent-bit-role.yaml', 'related K8S role'),
        ('fluent-bit-service-account.yaml', 'related K8S service account'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} {2} is removed sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} {2} is removed failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __removeEFKLoggingKibana(self, service, config):
    serviceDir = 'efk-kibana'
    allPartsInOrder = [
        ('node-port.yaml', 'related K8S NodePort Service'),
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
        ('deployment.yaml', 'related K8S Deployment'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} {2} is removed sucessfully'.format(
            service.namespace, service.name, onePart[1]))
      else:
        log.highlight('{0}:{1} {2} is removed failed'.format(
            service.namespace, service.name, onePart[1]))

    return

  def __removeSpecialService(self, service, config):
    k8s = service.k8s

    if hasattr(k8s, 'nodePort') and k8s.nodePort is not None:
      self.__removeFromYaml(service, config, 'node-port',
                            'related K8S NodePort Service')

    self.__removeFromYaml(service, config, 'cluster-ip',
                          'related K8S ClusterIP Service')

    self.__removeFromYaml(service, config, 'deployment',
                          'related K8S Deployment')
    return

  def __removeOneService(self, service, config):
    if isinstance(service, EFKLoggingService):
      if service.name == 'log-elasticsearch':
        self.__removeEFKLoggingElasticsearch(service, config)
      elif service.name == 'fluent-bit':
        self.__removeEFKLoggingFluentbit(service, config)
      elif service.name == 'log-kibana':
        self.__removeEFKLoggingKibana(service, config)
    elif isinstance(service, RabbitMQService):
      self.__removeSpecialService(service, config)
    elif isinstance(service, RedisService):
      self.__removeSpecialService(service, config)
    else:
      k8s = service.k8s

      if k8s.ingressInfo is not None:
        self.__removeFromYaml(service, config, 'ingress',
                              'related K8S Ingress Service')

      if k8s.nodePortPorts is not None and len(k8s.nodePortPorts) > 0:
        self.__removeFromYaml(service, config, 'node-port',
                              'related K8S NodePort Service')

      if k8s.clusterIPPorts is not None and len(k8s.clusterIPPorts) > 0:
        self.__removeFromYaml(service, config, 'cluster-ip',
                              'related K8S ClusterIP Service')

      self.__removeFromYaml(service, config, 'deployment',
                            'related K8S Deployment')

      if k8s.volumes is not None and len(k8s.volumes) > 0:
        self.__removeFromYaml(service, config, 'volume',
                              'related K8S Volumes')

      if k8s.externalName is not None:
        self.__removeFromYaml(service, config, 'external',
                              'related ExternalName K8S Service')

    return

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'load image and push to registry')
    if len(selectedServices) == 0:
      return

    self.already_downloaded_images = set()

  # pull image   for HuaWei registry
    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__saveOneServiceImage(
            oneService, config.dockerContext, config.context.imageOutputRootDir)

    self.already_downloaded_images.clear()
    self.already_downloaded_images = None

    # push image to registry
    self.__loginPrivateResgistry(config.dockerContext)
    self.file_already_loaded = set()
    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__loadPushOneServiceImage(
            oneService, config.dockerContext, config.context.imageOutputRootDir)

    self.file_already_loaded.clear()
    self.file_already_loaded = None

    # remove servives first in reversed order
    for oneService in reversed(config.services):
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__removeOneService(oneService, config)

    time.sleep(30)

  # install services
    for oneService in config.services:
      utils.printSectionLine('', 80, '*')
      if (oneService.namespace, oneService.name) in selectedServices:
        self.__installOneService(oneService, config)
      else:
        log.highlight('service {0}:{1} is skipped'.format(
            oneService.namespace, oneService.name))

    return

  def actionName(self):
    return 'FastUpdate service --- load image and push to registry and update services'
