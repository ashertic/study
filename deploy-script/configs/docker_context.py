from .config_base import ConfigBase

'''
这是Docker相关的上下文配置，一般都是需要这个配置的，
当使用K8S部署方式时，一般会在K8S master节点上创建一个
私有的Docker镜像源，那么这里也会指定该镜像源的一些访问信息。
当时使用Docker部署方式时，不需要创建私有Docker镜像源
'''


class DockerContext(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'srcRegistryBase'
    ]

  @classmethod
  def optional(cls):
    return [
        'targetRegistryBase',
        'targetRegistryUser',
        'targetRegistryPassword'
    ]
