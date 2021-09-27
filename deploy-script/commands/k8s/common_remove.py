import log
import command
import utils
import prompt
from commands.cmd_action_base import CommandActionBase

class RemoveK8SCommonConfigAction(CommandActionBase):
  def execute(self):
    k8sContext = self.config.k8sContext

    isConfimed = prompt.dangerConfirm('you want to delete K8S common stuff')
    if not isConfimed:
      return

    self.__removeImageRegistrySecret(
        k8sContext.namespaces,
        k8sContext.imagePullSecrets)

    self.__removeNamespace(k8sContext.namespaces)

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
