from .config_base import ConfigBase

'''
定义K8S中的Deployment配置，这是K8S中用来运行某个服务的最常见方式
'''


class K8SDeployment(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'nodeTag',
        'envs'
    ]

  @classmethod
  def optional(cls):
    return [
        'annotations',
        'volumes',
        'needPrivilegedPermission',
        'livenessProbe'
    ]
