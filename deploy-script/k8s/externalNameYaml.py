import utils


class ExternalNameYamlInfo:
  __template = '''apiVersion: v1
kind: Service
metadata:
  name: {0}
  namespace: {1}
spec:
  externalName: {2}
  ports:
  - protocol: {3}
    port: {4}
    targetPort: {5}
  type: ExternalName'''

  def __init__(self, name, namespace, externalName, protocol, port, targetPort):
    self.name = name
    self.namespace = namespace
    self.externalName = externalName
    self.protocol = protocol
    self.port = port
    self.targetPort = targetPort

  def create(self, fileName):
    utils.createDirForFile(fileName)
    targetFile = open(fileName, 'w', encoding='utf-8')

    targetFile.write(self.__template.format(self.name,
                                            self.namespace,
                                            self.externalName,
                                            self.protocol,
                                            self.port,
                                            self.targetPort))
    return
