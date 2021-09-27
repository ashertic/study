from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess
import prompt


class RemoveK8SCommonConfigAction(ActionHandlerBase):

  def __removeNamespace(self, namespaces):
    utils.printSectionLine('REMOVE NAMESPACE', 80, '*')
    for namespace in namespaces:
      command.execute(['kubectl', 'delete', 'namespaces', namespace])

    log.highlight('\nAll namespaces in K8S cluster:')
    command.execute(['kubectl', 'get', 'namespace'])

  def __removeImageRegistrySecret(self, namespaces, secretName):
    utils.printSectionLine('REMOVE DOCKER REGISTRY SECRET', 80, '*')
    for namespace in namespaces:
      cmd = ['kubectl', 'delete', 'secret', secretName, '-n', namespace]
      command.execute(cmd)

  def doWork(self, config, cmdArgs):
    k8sContext = config.k8sContext

    isConfimed = prompt.dangerConfirm('you want to delete K8S common stuff')
    if not isConfimed:
      return

    self.__removeImageRegistrySecret(
        k8sContext.namespaces,
        k8sContext.imagePullSecrets)
    # TODO: remove ingress secret cert

    self.__removeNamespace(k8sContext.namespaces)
    return

  def actionName(self):
    return 'K8S Common --- remove k8s namespace, image pull secret, ingress certifcate'
