import log
import command
import utils
from commands.cmd_action_base import CommandActionBase

class CreateK8SCommonConfigAction(CommandActionBase):
  def execute(self):
    k8sContext = self.config.k8sContext
    self.__createNamespace(k8sContext.namespaces)
    self.__createImageRegistrySecret(
        k8sContext.namespaces,
        k8sContext.imagePullSecrets,
        self.config.dockerContext.targetRegistryBase.replace('/', ''),
        self.config.dockerContext.targetRegistryUser,
        self.config.dockerContext.targetRegistryPassword)

  def __createNamespace(self, namespaces):
    utils.printSectionLine('CREATE NAMESPACE', 80, '*')
    for namespace in namespaces:
      command.execute(['kubectl', 'create', 'namespace', namespace])

    log.highlight('\nAll namespaces in K8S cluster:')
    command.execute(['kubectl', 'get', 'namespace'])

  def __createImageRegistrySecret(self, namespaces, secretName, target, user, password):
    utils.printSectionLine('CREATE DOCKER REGISTRY SECRET', 80, '*')
    for namespace in namespaces:
      cmd = ['kubectl', 'create', 'secret', 'docker-registry', secretName, '--docker-server=' + target,
             '--docker-username=' + user, '--docker-password=' + password, '--namespace=' + namespace]
      command.execute(cmd)
