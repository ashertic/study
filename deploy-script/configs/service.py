from .config_base import ConfigBase

'''
需要部署的服务的配置定义
'''


class Service(ConfigBase):
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
        'docker',
        'deployImage'
    ]

  def validate(self):
    if getattr(self, 'k8s') is None and getattr(self, 'docker') is None:
      raise ValueError('{0} must have k8s or docker config, but both are None'.format(
          self.__class__.__name__))
