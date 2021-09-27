from .config_base import ConfigBase

'''
定义K8S中NodePort类型的Service的端口信息，当需要将集群内部的某个服务暴露给集群外部使用时，
需要使用NodePort类型的Service来关联改服务，从而是集群外部可以通过NodePort定义的端口加上
K8S集群的外部可见IP来访问我们的服务，外部可见IP一般是Master节点在网络中的IP地址
'''


class K8SNodePortPort(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'nodePort',  # 这个端口是该服务的nodeport端口，该服务在集群外部通过集群IP加上这个端口可以被访问到
        'port',  # 这个端口是clusterip关联的服务暴露在clusterip上的服务端口，集群内部使用本端口来访问该服务
        'targetPort'  # 这是clusterip关联的服务在该服务所在的Pod中的端口，也就是服务在代码中定义的端口
    ]
