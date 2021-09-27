import log
import command
import utils
import os
from datetime import datetime
from commands.utils import select_db_backup_restore
from commands.cmd_action_base import CommandActionBase


class BackupDBAction(CommandActionBase):
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

  def execute(self):
    selected = select_db_backup_restore(
        self.config.dbBackupAndRestoreContext.databases)
    if len(selected) == 0:
      print(f'You do not select any database')
      return
    else:
      operatorImage = self.config.dockerContext.srcRegistryBase + \
          self.config.dbBackupAndRestoreContext.srcImage
      selected = set(selected)

      for one in self.config.dbBackupAndRestoreContext.databases:
        if one.name in selected:
          utils.printSectionLine('', 80, '*')
          self.__backupOneService(one, self.config, operatorImage)
      return
