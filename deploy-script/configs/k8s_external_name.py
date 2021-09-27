from .config_base import ConfigBase

'''
定义K8S中的external name，当K8S内部的服务需要使用某个K8S集群外部定义的web服务时，可以通过externalname来定义该
外部服务的地址信息，从而让内部服务可以通过这个externalname来调用改外部服务，而不是直接引用这些外部服务
'''


class K8SExternalName(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'externalName',
        'port',
        'targetPort'
    ]
