from .config_base import ConfigBase

'''
使用K8S方式部署时，redis服务需要的配置信息
'''


class RedisServiceK8SConfig(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'nodeTag',
        'redisPassword'
    ]

# need to check redis password
# rabbitMQUser and rabbitMQPassword both must be empty or not empty
