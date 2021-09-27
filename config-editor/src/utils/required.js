import _ from 'lodash'
export const configClassesRequiredDict = {
  Config: ['context', 'services', 'dockerContext'],
  Context: ['customer', 'project', 'env', 'description', 'mode', 'os', 'osVersion',
    'imageOutputRootDir', 'dataPathRoot'
  ],
  Service: ['name', 'namespace', 'imageCategory', 'srcImage'],
  ServiceK8SConfig: ['deployment'],
  ServiceDockerConfig: ['containerName', 'restart', 'useHostNetwork', 'ports', 'envs', 'volumes',
    'command'
  ],
  K8SClusterIPPort: ["port", "targetPort"],
  K8SNodePortPort: ['nodePort', 'port', 'targetPort'],
  K8SDeployment: ['nodeTag', 'envs'],
  K8SDeploymentDirectEnv: ['name', 'value'],
  K8SDeploymentSecretReferenceEnv: ['name', 'secretKey', 'secretName'],
  K8SDeploymentVolume: ['name', 'claimName', 'mountPath'],
  K8SIngress: ['host', 'servicePort'],
  K8SVolume: ['name', 'capacityStorage', 'hostPath'],
  K8SExternalName: ['name', 'externalName', 'port', 'targetPort'],
  DockerContext: ['srcRegistryBase'],
  K8SContext: ['namespaces', 'imagePullSecrets', 'yamlOutputRootDir'],
  NginxContext: ['certDir', 'targetNginxDir', 'servers', 'containerName', 'srcImage',
    'imageCategory'
  ],
  NginxServerConfig: ['comment', 'sslListenPort', 'serverName', 'proxyPass'],
  DatabaseInitializer: ['name', 'imageCategory', 'srcImage', 'envs'],
  EFKLoggingService: ['name', 'namespace', 'imageCategory', 'srcImage'],
  EFKLoggingServiceK8SConfig: ['nodeTag'],
  RabbitMQService: ['name', 'namespace', 'imageCategory', 'srcImage'],
  RabbitMQServiceK8SConfig: ['nodeTag', 'nodePort', 'rabbitMQErlangCookie', 'rabbitMQUser',
    'rabbitMQPassword'
  ],
  RedisService: ['name', 'namespace', 'imageCategory', 'srcImage'],
  RedisServiceK8SConfig: ['nodeTag', 'redisPassword'],
  DBBackupAndRestoreContext: ['imageCategory', 'srcImage', 'databases'],
  DatabaseInfo: ['name', 'server', 'port', 'user', 'password', 'diskDir', 'useHostNetwork']
}



export const required = (name, type) => {
  if (!name) return ''
  if (configClassesRequiredDict[type] && _.includes(configClassesRequiredDict[type], name)) {
    return `*${name}`
  }
  return name
}
