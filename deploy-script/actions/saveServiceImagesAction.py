from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class SaveServiceImagesAction(ActionHandlerBase):
  def __saveImageToFile(self, imageTag, filePath):
    # refer to: https://docs.python.org/2/library/subprocess.html#replacing-shell-pipeline
    # refer to: https://stackoverflow.com/questions/2331339/piping-output-of-subprocess-popen-to-files

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

  def __saveOneServiceImage(self, service, dockerContext, imageOutputRootDir):
    fullSrcImage = dockerContext.srcRegistryBase + service.srcImage

    if fullSrcImage in self.already_downloaded_images:
      print('skip pulling image because it already pulled with other services: {0}'.format(
          fullSrcImage))
      return

    self.already_downloaded_images.add(fullSrcImage)
    print('pull {0}:{1} source image from: '.format(
        service.namespace, service.name), end='')
    log.highlight(fullSrcImage)
    isSuccessfull = command.execute(['docker', 'pull', fullSrcImage])
    if isSuccessfull:
      log.highlight('pull image successfully')
    else:
      log.error('pull image failed')
      # TODO: should exit script

    imageFilePath = self.getServiceImageFilePath(service, imageOutputRootDir)
    self.__saveImageToFile(fullSrcImage, imageFilePath)

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'save image')

    if len(selectedServices) == 0:
      return

    self.already_downloaded_images = set()

    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__saveOneServiceImage(
            oneService, config.dockerContext, config.context.imageOutputRootDir)

    self.already_downloaded_images.clear()
    self.already_downloaded_images = None
    return

  def actionName(self):
    return 'Docker Images --- save docker images from source docker registry'
