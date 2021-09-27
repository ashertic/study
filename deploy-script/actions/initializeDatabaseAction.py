from actions.actionHandler import ActionHandlerBase
import log
import command
import utils


class InitializeDatabaseAction(ActionHandlerBase):
  def __loadImageFromFile(self, initializer, imageOutputRootDir):
    imageFilePath = self.getDBInitializerImageFilePath(
        initializer, imageOutputRootDir)
    cmd1 = ['gunzip', '-c', imageFilePath]
    cmd2 = ['docker', 'load']
    isSuccessful = command.executeWithPipe(cmd1, cmd2)

    if isSuccessful:
      log.highlight('load image from file successfully')
    else:
      log.error('load image from file failed')
    return

  def __executeOneInitializer(self, initializer, dockerContext):
    fullSrcImage = dockerContext.srcRegistryBase + initializer.srcImage
    if initializer.useHostNetwork is not None and initializer.useHostNetwork:
      cmd = ['docker', 'run', '--rm', '--net=host']
    else:
      cmd = ['docker', 'run', '--rm']

    for oneEnv in initializer.envs:
      cmd.append('-e')
      cmd.append(oneEnv)
    cmd.append(fullSrcImage)

    command.executeWithOSSystem(cmd)
    return

  def __removeImage(self, initializer, dockerContext):
    fullSrcImage = dockerContext.srcRegistryBase + initializer.srcImage
    cmd = ['docker', 'image', 'rm', fullSrcImage]
    command.execute(cmd)
    return

  def doWork(self, config, cmdArgs):
    if config.dbInitializers is None or len(config.dbInitializers) == 0:
      log.error(
          'no db intializers can be found or it is empty in configuration, exit this action')
      return

    selectedInitializers = self.selectDBInitializer(
        config.dbInitializers, cmdArgs.isSilent, 'initialize')

    if len(selectedInitializers) == 0:
      return

    for oneInitializer in config.dbInitializers:
      utils.printSectionLine('', 80, '*')
      if oneInitializer.name in selectedInitializers:
        self.__loadImageFromFile(
            oneInitializer, config.context.imageOutputRootDir)
        self.__executeOneInitializer(oneInitializer, config.dockerContext)
        self.__removeImage(oneInitializer, config.dockerContext)

    return

  def actionName(self):
    return 'DB Operation --- initialize database with db docker image'
