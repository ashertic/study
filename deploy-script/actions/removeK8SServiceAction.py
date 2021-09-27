from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess
from config import EFKLoggingService, RabbitMQService, RedisService
# export KUBECONFIG=/etc/kubernetes/admin.conf


class RemoveK8SServiceAction(ActionHandlerBase):
  def __removeFromYaml(self, service, config, kind, logKind):
    filePath = '{0}-config/{1}/{2}.yaml'.format(
        service.namespace, service.name, kind)
    filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
    isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
    if isSuccessful:
      log.highlight('{0}:{1} {2} is removed successfully'.format(
          service.namespace, service.name, logKind))
    else:
      log.error('{0}:{1} {2} is removed failed'.format(
          service.namespace, service.name, logKind))

  def __removeEFKLoggingElasticsearch(self, service, config):
    serviceDir = 'efk-elasticsearch'
    allPartsInOrder = [
        ('cluster-ip.yaml', 'related K8S ClusterIP Service'),
        ('deployment.yaml', 'related K8S Deployment'),
        ('volume.yaml', 'related K8S volume'),
    ]

    for onePart in allPartsInOrder:
      filePath = '{0}-config/{1}/{2}'.format(
          service.namespace, serviceDir, onePart[0])
      filePath = os.path.join(config.k8sContext.yamlOutputRootDir, filePath)
      isSuccessful = command.execute(['kubectl', 'delete', '-f', filePath])
      if isSuccessful:
        log.highlight('{0}:{1} {2} is removed successfully'.format(
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
        log.highlight('{0}:{1} {2} is removed successfully'.format(
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
        log.highlight('{0}:{1} {2} is removed successfully'.format(
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
        config.services, cmdArgs.isSilent, 'remove')
    if len(selectedServices) == 0:
      return

    # remove service in reversed order
    for oneService in reversed(config.services):
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__removeOneService(oneService, config)

    return

  def actionName(self):
    return 'K8S Service --- remove service from k8s cluster'
