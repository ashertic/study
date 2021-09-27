from .config_base import ConfigBase

'''
用于定义EFK的日志需要的一些额外信息，由王文斌添加
'''


class EFKLoggingServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'nodeTag'
    ]

  @classmethod
  def optional(cls):
    return [
        'volumes'
    ]
