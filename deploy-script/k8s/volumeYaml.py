import utils


class VolumeInfo:
  __template = '''---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {0}
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: {1}Gi
  hostPath:
    type: DirectoryOrCreate
    path: {2}
  persistentVolumeReclaimPolicy: Retain
  volumeMode: Filesystem
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {0}
  namespace: {3}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: {1}Gi
  storageClassName: ""
  volumeMode: Filesystem
  volumeName: {0}
'''

  def __init__(self, name, namespace, capacityStorage, hostPath):
    self.name = name
    self.namespace = namespace
    self.capacityStorage = capacityStorage
    self.hostPath = hostPath

  def yaml(self):
    return self.__template.format(self.name, self.capacityStorage, self.hostPath, self.namespace)


class VolumeYamlInfo:

  def __init__(self, volumes):
    self.volumes = volumes

  def create(self, fileName):
    utils.createDirForFile(fileName)
    targetFile = open(fileName, 'w', encoding='utf-8')

    volumeYaml = ''
    for index, oneVolume in enumerate(self.volumes):
      temp = oneVolume.yaml()
      if index < (len(self.volumes) - 1):
        temp += '\n'
      volumeYaml += temp

    targetFile.write(volumeYaml)
    return
