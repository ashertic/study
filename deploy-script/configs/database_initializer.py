from .config_base import ConfigBase

'''
定义数据库的初始化相关配置信息，私有化部署时，我们的PG数据库，有可能需要初始化操作，我们的初始化脚本一般是
通过SequelizeJS的方式编写，最终编译成一个Docker镜像，在部署时，直接执行Docker镜像，达到初始化数据库的效果
'''


class DatabaseInitializer(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'imageCategory',
        'srcImage',
        'envs'
    ]

  @classmethod
  def optional(cls):
    return [
        'useHostNetwork'
    ]
