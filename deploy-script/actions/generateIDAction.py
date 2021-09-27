from actions.actionHandler import ActionHandlerBase
import log
import command
import utils
import os
from datetime import datetime


class GenerateIDAction(ActionHandlerBase):
  def __loadImageFromFile(self, filePath):
    cmd1 = ['gunzip', '-c', filePath]
    cmd2 = ['docker', 'load']
    isSuccessful = command.executeWithPipe(cmd1, cmd2)

    if isSuccessful:
      log.highlight('load image from file successfully')
    else:
      log.error('load image from file failed')
    return

  def __removeImage(self):
    cmd = ['docker image rm -f',
           'swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/temp_id:latest']
    isSuccessful = command.executeWithOSSystem(cmd)

    if isSuccessful:
      log.highlight('remove image successfully')
    else:
      log.error('remove image failed')
    return

  def __generateId(self):
    cmd = ['docker', 'run', '--rm', '--privileged=true',
           'swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/temp_id:latest']
    isSuccessful = command.executeWithOSSystem(cmd)
    if isSuccessful:
      log.highlight('generate machine id successfully')
    else:
      log.error('generate machine id failed')

  def doWork(self, config, cmdArgs):
    utils.printSectionLine('', 80, '*')

    imageFilePath = config.context.imageOutputRootDir + \
        '/minerva/expert/expert-temp_id-latest.tgz'
    self.__loadImageFromFile(imageFilePath)
    self.__generateId()
    self.__removeImage()

    return

  def actionName(self):
    return 'Common --- generate machine id'
