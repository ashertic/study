from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class CreateK8SCommonConfigAction(ActionHandlerBase):

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

  def doWork(self, config, cmdArgs):
    k8sContext = config.k8sContext

    self.__createNamespace(k8sContext.namespaces)
    self.__createImageRegistrySecret(
        k8sContext.namespaces,
        k8sContext.imagePullSecrets,
        config.dockerContext.targetRegistryBase.replace('/', ''),
        config.dockerContext.targetRegistryUser,
        config.dockerContext.targetRegistryPassword)

    # TODO: create ingress secret cert
    return

  def actionName(self):
    return 'K8S Common --- create k8s namespace, image pull secret, ingress certifcate'
