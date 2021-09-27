from actions.actionHandler import ActionHandlerBase
import log
import command
import utils


class RemoveNginxProxyAction(ActionHandlerBase):
  def doWork(self, config, cmdArgs):
    utils.printSectionLine('', 80, '*')
    if config.nginxContext is None:
      log.error("can't find any nginx config in config json file, so do nothing")
      return

    cmd = ['docker', 'rm', '-f', config.nginxContext.containerName]
    command.execute(cmd)

    fullSrcImage = config.dockerContext.srcRegistryBase + config.nginxContext.srcImage
    cmd = ['docker', 'image', 'rm', '-f', fullSrcImage]
    command.execute(cmd)

    log.highlight('remove nginx proxy docker container successfully')
    return

  def actionName(self):
    return 'NGINX --- remove nginx proxy'
