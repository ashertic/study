from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class CheckPodLogAction(ActionHandlerBase):

  def __checkOneServiceLog(self, oneService, config):

    service = f'deployment/{oneService.name}'
    cmd = f'kubectl logs {service} -n {oneService.namespace}'
    command.executeWithOSSystem([cmd])

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'check logs')
    if len(selectedServices) == 0:
      return

    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__checkOneServiceLog(oneService, config)

    return

  def actionName(self):
    return 'Logs --- check pods log'
