from .config_base import ConfigBase

'''
K8S部署方式时，我们默认也会部署EFK一套日志系统，本配置即包括了相关信息，由于
EFK的K8S部署方式比较复杂，因此，针对EFK的部署单独实现了一套生成YAML文件的机制
'''


class EFKLoggingService(ConfigBase):
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
