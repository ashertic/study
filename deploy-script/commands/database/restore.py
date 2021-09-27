import log
import command
import utils
import os
import prompt
from commands.utils import select_db_backup_restore
from commands.cmd_action_base import CommandActionBase


class RestoreDBAction(CommandActionBase):
  def __restoreFromFile(self, database, config, operatorImage, backupFileName):
    targetFileDirPath = os.path.abspath(
        config.context.dataPathRoot + database.diskDir)

    scriptFilePath = targetFileDirPath + '/' + 'cmd.sh'
    utils.createDirForFile(scriptFilePath)

    with open(scriptFilePath, 'w', encoding='utf-8') as output:
      output.write('PGPASSWORD={} psql -h {} -p {} -U {} --command=\'DROP DATABASE IF EXISTS "{}"\'\n'
                   .format(database.password,
                           database.server,
                           database.port,
                           database.user,
                           database.name))
      output.write('sleep 10\n')
      output.write('PGPASSWORD={} psql -h {} -p {} -U {} --command=\'CREATE DATABASE "{}" ENCODING = UTF8\'\n'
                   .format(database.password,
                           database.server,
                           database.port,
                           database.user,
                           database.name))
      output.write('sleep 10\n')
      output.write('PGPASSWORD={} psql -h {} -p {} -U {} --dbname="{}" -f "/dbbackup/{}"\n'
                   .format(database.password,
                           database.server,
                           database.port,
                           database.user,
                           database.name,
                           backupFileName))

    cmd = ['docker', 'run', '--rm']
    if database.useHostNetwork is not None and database.useHostNetwork:
      cmd.append('--net=host')

    cmd.append('-v {0}:/dbbackup'.format(targetFileDirPath))
    cmd.append(operatorImage)
    cmd.append('sh /dbbackup/cmd.sh')

    log.highlight('will restore from : {0}'.format(backupFileName))

    isSuccessful = command.executeWithOSSystem(cmd)
    if isSuccessful:
      log.highlight('restore {0} database successfully'.format(database.name))
    else:
      log.error('restore {0} database failed'.format(database.name))

    os.remove(scriptFilePath)
    return

  def __restoreOneService(self, database, config, operatorImage):
    targetFileDirPath = os.path.abspath(
        config.context.dataPathRoot + database.diskDir)

    backupFiles = [f for f in os.listdir(
        targetFileDirPath) if f.endswith('.sql')]
    backupFiles.sort(reverse=True)

    print('please select the backup file number to restore:')
    for index, oneBackupFile in enumerate(backupFiles):
      print('  [{}] {}'.format(index+1, oneBackupFile))
    print('  [{}] GO BACK'.format(len(backupFiles)+1))

    number = None
    while True:
      try:
        numberStr = log.highlightInput(
            'please input selected backup file number: ')
        number = int(numberStr)
        if number >= 1 and number <= (len(backupFiles) + 1):
          break
        else:
          continue
      except:
        continue

    if number == (len(backupFiles) + 1):
      return

    targetBackFile = backupFiles[number - 1]
    print('you have select backup file: {}'.format(targetBackFile))
    isConfirmed = prompt.confirm('please confirm to use this file')
    if not isConfirmed:
      return

    self.__restoreFromFile(database, config, operatorImage, targetBackFile)
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
          self.__restoreOneService(one, self.config, operatorImage)
      return
