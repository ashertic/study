from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class SaveNginxProxyImageAction(ActionHandlerBase):
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

  def doWork(self, config, cmdArgs):
    utils.printSectionLine('', 80, '*')
    if config.nginxContext is None:
      log.error("can't find any nginx config in config json file, so do nothing")
      return

    fullSrcImage = config.dockerContext.srcRegistryBase + config.nginxContext.srcImage
    print('pull nginx proxy source image from: ', end='')
    log.highlight(fullSrcImage)
    isSuccessfull = command.execute(['docker', 'pull', fullSrcImage])
    if isSuccessfull:
      log.highlight('pull image successfully')
    else:
      log.error('pull image failed')
      # TODO: should exit script

    imageFilePath = self.getNginxProxyImageFilePath(
        config.nginxContext, config.context.imageOutputRootDir)
    self.__saveImageToFile(fullSrcImage, imageFilePath)
    return

  def actionName(self):
    return 'NGINX --- save nginx proxy docker image'
