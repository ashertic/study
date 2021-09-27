from .config_base import ConfigBase

'''
当服务使用Docker方式部署时，使用本配置类来定义服务Docker相关的配置信息
'''


class ServiceDockerConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'containerName',
        'restart',
        'useHostNetwork',
        'ports',
        'envs',
        'volumes',
        'command'
    ]

  @classmethod
  def optional(cls):
    return [
        'privileged',
        'dockerRunOptions'
    ]
