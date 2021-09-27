from .config_base import ConfigBase

'''
定义Nginx中的服务信息
'''


class NginxServerConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'comment',
        'sslListenPort',
        'serverName',
        'proxyPass'
    ]
