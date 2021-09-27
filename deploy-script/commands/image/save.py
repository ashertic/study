import log
import command
import utils
import subprocess
import os

from commands.utils import select_services
from commands.cmd_action_base import CommandActionBase


class ImageSaveAction(CommandActionBase):
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

  def getServiceImageFilePath(self, service, imageOutputRootDir):
    imageFileName = '{0}.tgz'.format(
        service.srcImage.replace('/', '-').replace(':', '-'))

    imageFilePath = ''
    if service.imageCategory == 'thirdparty':
      imageFilePath = os.path.join(
          imageOutputRootDir, service.imageCategory, imageFileName)
    else:
      imageFilePath = os.path.join(
          imageOutputRootDir, 'minerva', service.imageCategory, imageFileName)

    return imageFilePath


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






  def execute(self):
    services = select_services(self.config.services)
    if len(services) == 0:
      print(f'You do not select any service')
      return
    else:
      selected_service_set = set(services)

      self.already_downloaded_images = set()

      for oneService in self.config.services:
        service_key = f'{oneService.namespace}:{oneService.name}'
        if service_key in selected_service_set:
          utils.printSectionLine('', 80, '*')
          self.__saveOneServiceImage(
              oneService, self.config.dockerContext, self.config.context.imageOutputRootDir)

      self.already_downloaded_images.clear()
      self.already_downloaded_images = None
      return


