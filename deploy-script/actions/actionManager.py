import log

from utils import printSectionLine
from prompt import confirm
from actions.exitAction import ExitAction
from actions.generateK8SYamlAction import GenerateK8SYamlAction
from actions.saveServiceImagesAction import SaveServiceImagesAction
from actions.saveDBInitializerImagesAction import SaveDBIntializerImagesAction
from actions.loadImageAndPushAction import LoadImageAndPushAction
from actions.loadImageAction import LoadImageAction
from actions.createK8SCommonConfigAction import CreateK8SCommonConfigAction
from actions.installK8SServiceAction import InstallK8SServiceAction
from actions.updateK8SServiceAction import UpdateK8SServiceAction
from actions.removeK8SServiceAction import RemoveK8SServiceAction
from actions.removeK8SCommonConfigAction import RemoveK8SCommonConfigAction
from actions.initializeDatabaseAction import InitializeDatabaseAction
from actions.installNginxProxyAction import InstallNginxProxyAction
from actions.saveNginxProxyImageAction import SaveNginxProxyImageAction
from actions.removeNginxProxyAction import RemoveNginxProxyAction
from actions.installDockerServiceAction import InstallDockerServiceAction
from actions.removeDockerServiceAction import RemoveDockerServiceAction
from actions.backupDBAction import BackupDBAction
from actions.restoreDBAction import RestoreDBAction
from actions.generateIDAction import GenerateIDAction
from actions.checkPodLogAction import CheckPodLogAction
from actions.operatePodAction import OperatePodAction
from actions.fastUpdateAction import FastUpdateAction       




class ActionManager:
  def __init__(self, mode):
    mode = mode.lower()
    if mode == 'k8s':
      self.__actions = [
          SaveServiceImagesAction(),
          LoadImageAndPushAction(),

          SaveDBIntializerImagesAction(),
          InitializeDatabaseAction(),
          BackupDBAction(),
          RestoreDBAction(),

          CreateK8SCommonConfigAction(),
          RemoveK8SCommonConfigAction(),

          GenerateK8SYamlAction(),
          InstallK8SServiceAction(),
          UpdateK8SServiceAction(),
          RemoveK8SServiceAction(),

          SaveNginxProxyImageAction(),
          InstallNginxProxyAction(),
          RemoveNginxProxyAction(),

          CheckPodLogAction(),
          OperatePodAction(),
          FastUpdateAction(),   

          GenerateIDAction(),

          ExitAction()
      ]
    elif mode == 'docker':
      self.__actions = [
          SaveServiceImagesAction(),
          LoadImageAction(),

          InstallDockerServiceAction(),
          RemoveDockerServiceAction(),

          SaveDBIntializerImagesAction(),
          InitializeDatabaseAction(),
          BackupDBAction(),
          RestoreDBAction(),

          GenerateIDAction(),


          ExitAction()
      ]
    else:
      raise ValueError(
          'deployment mode in configuration file is invalid, only support k8s or docker')

    self.__actionHandlerMap = dict()
    for oneAction in self.__actions:
      self.__actionHandlerMap[oneAction.actionName()] = oneAction

  def __execute(self, action, config, cmdArgs):
    handler = self.__actionHandlerMap[action]
    handler.execute(config, cmdArgs)

    if action == self.__actions[len(self.__actions) - 1].actionName():
      return False
    else:
      return True

  def __ask(self):
    choice = None
    while True:
      printSectionLine('SELECT ACTIONS', 80)
      log.highlight('Here are all actions, you can select one to execute:')
      for index, oneAction in enumerate(self.__actions):
        if index % 2 == 0:
          print('  [{0:0>2}] {1}'.format(index + 1, oneAction.actionName()))
        else:
          log.alternativeRow('  [{0:0>2}] {1}'.format(
              index + 1, oneAction.actionName()))

      while True:
        try:
          choice = log.highlightInput('Please input action number: ')
          choice = int(choice) - 1
          if choice >= 0 and choice < len(self.__actions):
            break
        except:
          continue

      promptText = 'You have selected action: {0}.\nPlease confirm'.format(
          self.__actions[choice].actionName())
      isConfirmed = confirm(promptText)
      if isConfirmed:
        break

    return self.__actions[choice].actionName()

  def loop(self, config, cmdArgs):
    while True:
      action = self.__ask()
      isContinue = self.__execute(action, config, cmdArgs)
      if not isContinue:
        break

    print('Scripe is finish')
