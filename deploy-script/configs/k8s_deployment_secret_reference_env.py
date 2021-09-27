from .config_base import ConfigBase

'''
定义K8S中Deployment配置会使用的引用加密配置的环境变量，一般使用这个来存储共用的密码信息数据
'''


class K8SDeploymentSecretReferenceEnv(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'secretKey',
        'secretName'
    ]
