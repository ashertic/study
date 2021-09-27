import utils


class NodePortYamlPortInfo:
  def __init__(self, protocol, nodePort, port, targetPort):
    self.protocol = protocol
    self.nodePort = nodePort
    self.port = port
    self.targetPort = targetPort


class NodePortYamlInfo:
  __template = '''apiVersion: v1
kind: Service
metadata:
  name: {0}
  namespace: {1}
spec:
  selector:
    app: {2}
  ports:{3}
  type: NodePort
'''

  # protocol: The IP protocol for this port. Supports "TCP", "UDP", and "SCTP". Default is TCP.
  # nodePort: The port on each node on which this service is exposed when type=NodePort
  # port: The port that will be exposed by this service
  # targetPort: Number or name of the port to access on the pods targeted by the service. Number must be in the range 1 to 65535.
  __template_port = '''
    - protocol: {0}
      nodePort: {1}
      port: {2}
      targetPort: {3}'''

  def __init__(self, name, namespace, appSelector, ports):
    self.name = name
    self.namespace = namespace
    self.appSelector = appSelector
    self.ports = ports

  def create(self, fileName):
    utils.createDirForFile(fileName)
    targetFile = open(fileName, 'w', encoding='utf-8')

    portsValue = ''
    for p in self.ports:
      portsValue += self.__template_port.format(
          p.protocol, p.nodePort, p.port, p.targetPort)

    targetFile.write(self.__template.format(
        self.name, self.namespace, self.appSelector, portsValue))
    return
