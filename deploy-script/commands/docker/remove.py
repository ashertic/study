import log
import command
import utils

from commands.utils import select_services
from commands.cmd_action_base import CommandActionBase

class RemoveDockerServiceAction(CommandActionBase):
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

  def execute(self):
    services = select_services(self.config.services)
    if len(services) == 0:
      print(f'You do not select any service')
      return
    else:
      selected_service_set = set(services)
      for oneService in reversed(self.config.services):
        service_key = f'{oneService.namespace}:{oneService.name}'
        if service_key in selected_service_set:
          utils.printSectionLine('', 80, '*')
          self.__removeOneService(oneService, self.config)
      return
