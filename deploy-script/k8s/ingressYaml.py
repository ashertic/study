import utils


class IngressYamlInfo:
  __template = '''apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {0}
  namespace: {1}
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: {2}
    http:
      paths:
      - path: {3}
        backend:
          serviceName: {4}
          servicePort: {5}
  tls:
  - hosts:
    - {2}
    secretName: {6}'''

  def __init__(self, name, namespace, host, path, serviceName, servicePort, secretName):
    self.name = name
    self.namespace = namespace
    self.host = host
    self.path = path
    self.serviceName = serviceName
    self.servicePort = servicePort
    self.secretName = secretName

  def create(self, fileName):
    utils.createDirForFile(fileName)
    targetFile = open(fileName, 'w', encoding='utf-8')

    targetFile.write(self.__template.format(self.name, self.namespace, self.host,
                                            self.path, self.serviceName, self.servicePort, self.secretName))
    return
