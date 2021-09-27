from .config_base import ConfigBase

'''
定义K8S中Ingress类型的Service的配置，当K8S中的某个服务需要通过外部的Load Balancer以DNS域名的形式提供给
集群外部使用时，需要定义Ingress Service并将该Service关联到对应的服务
'''


class K8SIngress(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'host',
        'servicePort'
    ]
