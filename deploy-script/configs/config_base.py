import json
import os.path

'''
这是配置文件的基类，JSON配置文件的每一个部分都是通过继承自这个基类的配置来读取的，
子配置类会通过重定义required和optional两个方法来指定必选字段和可选字段
'''


class ConfigBase:
  def __init__(self, *pArgs):
    for index, p in enumerate(self.required()):
      setattr(self, p, pArgs[index])

    indexOffset = len(self.required())
    for index, p in enumerate(self.optional()):
      setattr(self, p, pArgs[indexOffset + index])

  def validate(self):
    pass

  @classmethod
  def required(cls):
    return []

  @classmethod
  def optional(cls):
    return []
