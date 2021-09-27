from .config_base import ConfigBase

'''
rabbitmq使用K8S方式部署时，需要的一些配置参数
'''


class RabbitMQServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'nodeTag',
        'nodePort',
        'rabbitMQErlangCookie',
        'rabbitMQUser',
        'rabbitMQPassword'
    ]
