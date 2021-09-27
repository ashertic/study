from .config_base import ConfigBase

'''
在日常的运维过程中，可能会需要对数据进行备份和恢复的操作，这些命令，
我们也是通过提供对应的docker image和脚本来执行的
因此本配置主要是包含针对不同的数据库的备份和恢复操作的信息
'''


class DBBackupAndRestoreContext(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'imageCategory',
        'srcImage',
        'databases'
    ]
