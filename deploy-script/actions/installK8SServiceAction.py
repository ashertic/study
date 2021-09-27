from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess
from config import EFKLoggingService, RabbitMQService, RedisService


class InstallK8SServiceAction(ActionHandlerBase):
  def __installFromYaml(self, service, config, kind, logKind):
    filePath = '{0}-config/{1}/{2}.yaml'.format(
        service.namespace, service.name, kind)
    filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
    isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
    if isSuccessful:
      log.highlight('{0}:{1} create {2} successfully'.format(
          service.namespace, service.name, logKind))
    else:
      log.error('{0}:{1} create {2} failed'.format(
          service.namespace, service.name, logKind))

  def __installEFKLoggingElasticsearch(self, service, config):
    serviceDir = 'efk-elasticsearch'
    allPartsInOrder = [
        ('volume.yaml', 'related K8S volume'),
        ('deployment.yaml', 'related K8S Deployment'),
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'apply', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} create {2} successfully'.format(
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
        log.highlight('{0}:{1} create {2} successfully'.format(
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
        log.highlight('{0}:{1} create {2} successfully'.format(
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

      if k8s.ingressInfo is not None:
        self.__installFromYaml(service, config, 'ingress',
                               'related K8S Ingress Service')

    return

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'install')
    if len(selectedServices) == 0:
      return

    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__installOneService(oneService, config)

    return

  def actionName(self):
    return 'K8S Service --- install service to k8s cluster'
