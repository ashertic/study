import log
import command
import utils
from commands.cmd_action_base import CommandActionBase

class GenerateIDAction(CommandActionBase):
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

  def execute(self):
    utils.printSectionLine('', 80, '*')
    imageFilePath = self.config.context.imageOutputRootDir + \
        '/minerva/expert/expert-temp_id-latest.tgz'
    self.__loadImageFromFile(imageFilePath)
    self.__generateId()
    self.__removeImage()
    return
