from .config_base import ConfigBase

'''
定义整个JSON配置文件的上下文，包括了本部署配置文件的一些基本信息
'''


class Context(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'customer',
        'project',
        'env',
        'description',
        'mode',
        'os',
        'osVersion',
        'imageOutputRootDir',
        'dataPathRoot'
    ]
