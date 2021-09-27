from .config_base import ConfigBase

'''
当服务使用K8S方式部署时，使用本配置类定义服务的K8S相关配置定义
'''


class ServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'deployment'
    ]

  @classmethod
  def optional(cls):
    return [
        'clusterIPPorts',
        'nodePortPorts',
        'ingressInfo',
        'volumes',
        'externalName'
    ]
