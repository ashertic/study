from actions.actionHandler import ActionHandlerBase
import log
import command
import os
import utils
import subprocess


class OperatePodAction(ActionHandlerBase):

  def __operateOneService(self, oneService, config):

    service = f'deployment/{oneService.name}'
    cmd = f'kubectl exec -it  {service} -n {oneService.namespace}  /bin/sh'
    command.executeWithOSSystem([cmd])

  def doWork(self, config, cmdArgs):
    selectedServices = self.selectServices(
        config.services, cmdArgs.isSilent, 'operate pod')
    if len(selectedServices) == 0:
      return

    for oneService in config.services:
      if (oneService.namespace, oneService.name) in selectedServices:
        utils.printSectionLine('', 80, '*')
        self.__operateOneService(oneService, config)

    return

  def actionName(self):
    return 'Operate --- Operate pods'
