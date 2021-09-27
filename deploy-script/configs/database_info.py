from .config_base import ConfigBase

'''
不同的配置中需要制定数据库的信息，本配置就是用来定义在我们的部署中一个数据库的各种基本信息
'''


class DatabaseInfo(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'server',
        'port',
        'user',
        'password',
        'diskDir',
        'useHostNetwork'
    ]
