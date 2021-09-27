import log
import command
import utils
from commands.utils import select_db_initializer
from commands.cmd_action_base import CommandActionBase


class InitializeDatabaseAction(CommandActionBase):
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

  def execute(self):
    if self.config.dbInitializers is None or len(self.config.dbInitializers) == 0:
      log.error('no db intializers can be found or it is empty in configuration')
      return

    selected = select_db_initializer(self.config.dbInitializers)
    if len(selected) == 0:
      print(f'You do not select any initializer')
      return
    else:
      selected = set(selected)
      for oneInitializer in self.config.dbInitializers:
        key = f'{oneInitializer.imageCategory}:{oneInitializer.name}'
        if key in selected:
          utils.printSectionLine('', 80, '*')
          self.__loadImageFromFile(
              oneInitializer, self.config.context.imageOutputRootDir)
          self.__executeOneInitializer(
              oneInitializer, self.config.dockerContext)
          self.__removeImage(oneInitializer, self.config.dockerContext)
      return
