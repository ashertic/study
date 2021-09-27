import log
import command
import utils
import os
import subprocess
from commands.utils import select_db_initializer
from commands.cmd_action_base import CommandActionBase


class SaveDBIntializerImagesAction(CommandActionBase):
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

    

  def getDBInitializerImageFilePath(self, initializer, imageOutputRootDir):
    imageFileName = '{0}.tgz'.format(
        initializer.srcImage.replace('/', '-').replace(':', '-'))

    imageFilePath = os.path.join(
        imageOutputRootDir, 'minerva', initializer.imageCategory, imageFileName)

    return imageFilePath

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
          self.__saveOneInitializerImage(
              oneInitializer, self.config.dockerContext, self.config.context.imageOutputRootDir)
      return
