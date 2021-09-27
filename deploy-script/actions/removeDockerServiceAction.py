from actions.actionHandler import ActionHandlerBase
import log
import command
import utils


class RemoveDockerServiceAction(ActionHandlerBase):
  def __removeOneService(self, service, config):
    cmd = ['docker', 'stop', service.docker.containerName]
    command.execute(cmd)
    cmd = ['docker', 'rm', '-f', service.docker.containerName]
    isSuccessful = command.execute(cmd)
    if isSuccessful:
      log.highlight('remove {0}:{1} service successfully'.format(
          service.namespace, service.name))
    else:
      log.error('remove {0}:{1} service failed'.format(
          service.namespace, service.name))

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
    return 'Docker Service --- remove docker service'
