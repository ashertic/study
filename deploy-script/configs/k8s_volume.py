from .config_base import ConfigBase

'''
定义K8S的volume信息，在我们的部署中最常用的是直接将服务所在机器节点（K8S中用Node来表示）的物理磁盘，
通过hostpath的方式挂载到K8S集群作为集群内部的服务可用的存储来使用，本配置是负责创建一个volume，让K8S
集群可以在磁盘上找到它，对于这个volume的具体使用，需要在Deployment配置中添加使用volume的声明
'''


class K8SVolume(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'capacityStorage',
        'hostPath'
    ]
