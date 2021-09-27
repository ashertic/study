from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class SaveDBIntializerImagesAction(ActionHandlerBase):
  def __saveImageToFile(self, imageTag, filePath):
    print('save image {0} to: '.format(imageTag), end='')
    log.highlight(filePath)
    utils.createDirForFile(filePath)

    with open(filePath, "wb") as imageFile:
      p1 = subprocess.Popen(
          ['docker', 'save', imageTag], stdout=subprocess.PIPE)
      p2 = subprocess.Popen(
          ['gzip'], stdin=p1.stdout, stdout=imageFile)
      p1.stdout.close()
      p2.communicate()[0]
      log.highlight('save image to file successfully')
    return

  def __saveOneInitializerImage(self, initializer, dockerContext, imageOutputRootDir):
    fullSrcImage = dockerContext.srcRegistryBase + initializer.srcImage
    print('pull {0} source image from: '.format(initializer.name), end='')
    log.highlight(fullSrcImage)
    isSuccessfull = command.execute(['docker', 'pull', fullSrcImage])
    if isSuccessfull:
      log.highlight('pull image successfully')
    else:
      log.error('pull image failed')
      # TODO: should exit script

    imageFilePath = self.getDBInitializerImageFilePath(
        initializer, imageOutputRootDir)
    self.__saveImageToFile(fullSrcImage, imageFilePath)
    return

  def doWork(self, config, cmdArgs):
    if config.dbInitializers is None or len(config.dbInitializers) == 0:
      log.error(
          'no db intializers can be found or it is empty in configuration, exit this action')
      return

    selectedInitializers = self.selectDBInitializer(
        config.dbInitializers, cmdArgs.isSilent, 'save docker image')

    if len(selectedInitializers) == 0:
      return

    for oneInitializer in config.dbInitializers:
      utils.printSectionLine('', 80, '*')
      if oneInitializer.name in selectedInitializers:
        self.__saveOneInitializerImage(
            oneInitializer, config.dockerContext, config.context.imageOutputRootDir)
      else:
        log.highlight('initializer {0} is skipped'.format(oneInitializer.name))

    return

  def actionName(self):
    return 'DB Operation --- save database initializer docker images'
