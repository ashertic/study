from .config_base import ConfigBase

'''
定义了K8S相关的上下文，这是可选的JSON配置，只有使用K8S部署方式时，才需要这个配置
'''


class K8SContext(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'namespaces',
        'imagePullSecrets',
        'yamlOutputRootDir'
    ]

  @classmethod
  def optional(cls):
    return [
        'ingressCertSecretName',
        'ingressSecretCertPath',
        'ingressSecretKeyPath'
    ]
