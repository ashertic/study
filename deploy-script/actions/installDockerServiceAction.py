from actions.actionHandler import ActionHandlerBase
import log
import command
import utils
import os


class InstallDockerServiceAction(ActionHandlerBase):
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
    return 'Docker Service --- install docker service'
