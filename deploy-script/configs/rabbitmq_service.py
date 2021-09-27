from .config_base import ConfigBase

'''
定义rabbitmq服务的配置信息
'''


class RabbitMQService(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'namespace',
        'imageCategory',
        'srcImage'
    ]

  @classmethod
  def optional(cls):
    return [
        'k8s',
        'deployImage'
    ]
