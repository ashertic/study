from .config_base import ConfigBase

'''
定义K8S中ClusterIP类型的Service的配置的端口信息，ClusterIP主要是在集群内部给某个Deployment对应的服务创建一个
虚拟的IP，通过这个IP，集群内部的其他服务就可以调用到该服务，而不用关心该服务有几个具体的服务实例，并且ClusterIP
也是其他的一些K8S Service配置的基础
'''


class K8SClusterIPPort(ConfigBase):
  @classmethod
  def required(cls):
    return [
        "port",  # 这个端口是clusterip关联的服务暴露在clusterip上的服务端口，集群内部使用本端口来访问该服务
        "targetPort"  # 这是clusterip关联的服务在该服务所在的Pod中的端口，也就是服务在代码中定义的端口
    ]
