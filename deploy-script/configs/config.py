from .config_base import ConfigBase

'''
这是整个JSON配置的定义，其中包括其他的子部分
'''


class Config(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'context',
        'services',
        'dockerContext'
    ]

  @classmethod
  def optional(cls):
    return [
        'k8sContext',
        'dbInitializers',
        'nginxContext',
        'dbBackupAndRestoreContext'
    ]
