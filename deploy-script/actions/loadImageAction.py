from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class LoadImageAction(ActionHandlerBase):
  def __loadImageFromFile(self, filePath):
    cmd1 = ['gunzip', '-c', filePath]
    cmd2 = ['docker', 'load']
    isSuccessful = command.executeWithPipe(cmd1, cmd2)

    if isSuccessful:
      log.highlight('load image from file successfully')
    else:
      log.error('load image from file failed')
    return


  def __loadOneServiceImage(self, service, dockerContext, imageOutputRootDir):
    imageFilePath = self.getServiceImageFilePath(service, imageOutputRootDir)

    if imageFilePath in self.file_already_loaded:
      print('skip load image from file because it already loaded with other services: {0}'.format(
          imageFilePath))
      return

    self.file_already_loaded.add(imageFilePath)
    print('load {0}:{1} service image from: '.format(
        service.namespace, service.name), end='')
    log.highlight(imageFilePath)
    self.__loadImageFromFile(imageFilePath)
    return

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'load image and push to registry')
    if len(selectedServices) == 0:
      return

    self.file_already_loaded = set()

    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__loadOneServiceImage(
            oneService, config.dockerContext, config.context.imageOutputRootDir)

    self.file_already_loaded.clear()
    self.file_already_loaded = None
    return

  def actionName(self):
    return 'Docker Images --- load image from file'
