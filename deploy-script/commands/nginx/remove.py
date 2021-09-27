import log
import command
import utils
from commands.cmd_action_base import CommandActionBase


class RemoveNginxProxyAction(CommandActionBase):
  def execute(self):
    utils.printSectionLine('', 80, '*')
    if self.config.nginxContext is None:
      log.error("can't find any nginx config in config json file, so do nothing")
      return

    cmd = ['docker', 'rm', '-f', self.config.nginxContext.containerName]
    command.execute(cmd)

    fullSrcImage = self.config.dockerContext.srcRegistryBase + \
        self.config.nginxContext.srcImage
    cmd = ['docker', 'image', 'rm', '-f', fullSrcImage]
    command.execute(cmd)

    log.highlight('remove nginx proxy docker container successfully')
    return
