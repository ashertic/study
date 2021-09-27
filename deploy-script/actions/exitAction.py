from actions.actionHandler import ActionHandlerBase


class ExitAction(ActionHandlerBase):
  def doWork(self, config, cmdArgs):
    print('Script will exit')

  def actionName(self):
    return 'EXIT'
