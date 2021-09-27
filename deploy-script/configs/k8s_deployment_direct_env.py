from .config_base import ConfigBase

'''
定义了K8S Deployment类型配置中需要使用的环境变量，这是基础的环境变量，包括名字和值，不引用任何外部的其他内容
'''


class K8SDeploymentDirectEnv(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'value'
    ]
