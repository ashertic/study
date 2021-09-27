from .config_base import ConfigBase

'''
Nginx相关的上下文配置，有些情况，私有化部署时，客户可能会提供客户内部网络的域名以及相关证书，希望
我们帮助创建对应的服务，将我们的服务以内部的域名形式提供给客户的内部网络，这个时候，就需要在docker或者k8s环境
外部在搭建一个Nginx反向代理服务
'''


class NginxContext(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'certDir',
        'targetNginxDir',
        'servers',
        'containerName',
        'srcImage',
        'imageCategory'
    ]
