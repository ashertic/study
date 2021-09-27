
import log
import command
import utils
import os

from commands.utils import select_services
from commands.cmd_action_base import CommandActionBase


class InstallDockerServiceAction(CommandActionBase):
  def __installOneService(self, service, config):
    fullSrcImage = config.dockerContext.srcRegistryBase + service.srcImage
    serviceDocker = service.docker

    cmd = ['docker', 'run', '-d']
    cmd.append('--name={}'.format(serviceDocker.containerName))
    if serviceDocker.restart == 'always':
      cmd.append('--restart=always')

    if serviceDocker.dockerRunOptions is not None and len(serviceDocker.dockerRunOptions) > 0:
      cmd.extend(serviceDocker.dockerRunOptions)

    if serviceDocker.useHostNetwork:
      cmd.append('--net=host')
    else:
      for onePort in serviceDocker.ports:
        cmd.append('-p')
        cmd.append(onePort)

    if serviceDocker.privileged is not None and serviceDocker.privileged:
      cmd.append('--privileged=true')

    for oneEnv in serviceDocker.envs:
      cmd.append('-e')
      cmd.append(oneEnv)

    dataPathRoot = os.path.abspath(config.context.dataPathRoot)
    for oneVolume in serviceDocker.volumes:
      cmd.append('-v')
      cmd.append(dataPathRoot + oneVolume)

    cmd.append(fullSrcImage)
    if len(serviceDocker.command) > 0:
      cmd.append(serviceDocker.command)

    isSuccessful = command.executeWithOSSystem(cmd)
    if isSuccessful:
      log.highlight('install {0}:{1} service successfully'.format(
          service.namespace, service.name))
    else:
      log.error('install {0}:{1} service failed'.format(
          service.namespace, service.name))

    return

  def execute(self):
    services = select_services(self.config.services)
    if len(services) == 0:
      print(f'You do not select any service')
      return
    else:
      selected_service_set = set(services)
      for oneService in self.config.services:
        service_key = f'{oneService.namespace}:{oneService.name}'
        if service_key in selected_service_set:
          utils.printSectionLine('', 80, '*')
          self.__installOneService(oneService, self.config)
      return
