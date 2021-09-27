from actions.actionHandler import ActionHandlerBase
import log
import command
import utils
import os
from datetime import datetime


class BackupDBAction(ActionHandlerBase):
  def __backupOneService(self, database, config, operatorImage):
    targetFileDirPath = os.path.abspath(
        config.context.dataPathRoot + database.diskDir)
    targetFileName = database.name.replace(
        '-', '_') + datetime.now().strftime('%Y%m%d_%H%M%S') + '.sql'

    scriptFilePath = targetFileDirPath + '/' + 'cmd.sh'
    utils.createDirForFile(scriptFilePath)

    with open(scriptFilePath, 'w', encoding='utf-8') as output:
      output.write('PGPASSWORD={} pg_dump -h {} -p {} -U {} -f "/dbbackup/{}" "{}"'
                   .format(database.password,
                           database.server,
                           database.port,
                           database.user,
                           targetFileName,
                           database.name))

    cmd = ['docker', 'run', '--rm']
    if database.useHostNetwork is not None and database.useHostNetwork:
      cmd.append('--net=host')

    cmd.append('-v {0}:/dbbackup'.format(targetFileDirPath))
    cmd.append(operatorImage)
    cmd.append('sh /dbbackup/cmd.sh')

    log.highlight(
        'will backup database to file: {0}/{1}'.format(targetFileDirPath, targetFileName))

    isSuccessful = command.executeWithOSSystem(cmd)
    if isSuccessful:
      log.highlight('backup {0} database successfully'.format(database.name))
    else:
      log.error('backup {0} database failed'.format(database.name))

    os.remove(scriptFilePath)
    return

  def doWork(self, config, cmdArgs):
    selected = self.selectDatabase(
        config.dbBackupAndRestoreContext.databases, cmdArgs.isSilent, 'backup')
    if len(selected) == 0:
      return

    operatorImage = config.dockerContext.srcRegistryBase + \
        config.dbBackupAndRestoreContext.srcImage

    for one in config.dbBackupAndRestoreContext.databases:
      if one.name in selected:
        utils.printSectionLine('', 80, '*')
        self.__backupOneService(one, config, operatorImage)

    return

  def actionName(self):
    return 'DB Operation --- backup database'
