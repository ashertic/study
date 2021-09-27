from .config_base import ConfigBase

'''
定义K8S中Deployment配置的annotation定义
'''


class K8SDeploymentAnnotation(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'value'
    ]
