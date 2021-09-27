from .config_base import ConfigBase

'''
定义K8S中Deployment中会使用volume信息，本信息只是对已经添加到K8S的volume的使用申明，并不是
将磁盘上的某个路径挂载到K8S中作为可使用volume
'''


class K8SDeploymentVolume(ConfigBase):
  @classmethod
  def required(cls):
    return [
        'name',
        'claimName',
        'mountPath'
    ]
