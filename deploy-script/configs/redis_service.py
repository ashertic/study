from .config_base import ConfigBase

'''
redis服务的基本配置信息
'''


class RedisService(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'namespace',
        'imageCategory',
        'srcImage'
    ]

  @classmethod
  def optional(cls):
    return [
        'k8s',
        'deployImage'
    ]
