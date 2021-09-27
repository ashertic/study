from .config import Config

from .context import Context
from .docker_context import DockerContext
from .k8s_context import K8SContext

from .service import Service
from .service_k8s_config import ServiceK8SConfig
from .service_docker_config import ServiceDockerConfig

from .k8s_volume import K8SVolume
from .k8s_deployment import K8SDeployment
from .k8s_deployment_annotation import K8SDeploymentAnnotation
from .k8s_deployment_direct_env import K8SDeploymentDirectEnv
from .k8s_deployment_secret_reference_env import K8SDeploymentSecretReferenceEnv
from .k8s_deployment_volume import K8SDeploymentVolume
from .k8s_cluster_ip_port import K8SClusterIPPort
from .k8s_node_port_port import K8SNodePortPort
from .k8s_ingress import K8SIngress
from .k8s_external_name import K8SExternalName

from .nginx_context import NginxContext
from .nginx_server_config import NginxServerConfig

from .efk_logging_service import EFKLoggingService
from .efk_logging_service_k8s_config import EFKLoggingServiceK8SConfig

from .rabbitmq_service import RabbitMQService
from .rabbitmq_service_k8s_config import RabbitMQServiceK8SConfig

from .redis_service import RedisService
from .redis_service_k8s_config import RedisServiceK8SConfig

from .database_initializer import DatabaseInitializer
from .db_backup_restore_context import DBBackupAndRestoreContext
from .database_info import DatabaseInfo


def __decoder(cls, obj):
  requiredProperties = []
  optionalProperties = []

  for p in cls.required():
    if p not in obj:
      raise ValueError(
          '{0} is missing required property {1}'.format(cls.__name__, p))
    requiredProperties.append(obj[p])

  for p in cls.optional():
    if p not in obj:
      optionalProperties.append(None)
    else:
      optionalProperties.append(obj[p])

  instance = cls(*requiredProperties, *optionalProperties)
  instance.validate()
  return instance


def decoder(obj):
  configClassesDict = {
      'Config': Config,
      'Context': Context,
      'Service': Service,
      'ServiceK8SConfig': ServiceK8SConfig,
      'ServiceDockerConfig': ServiceDockerConfig,
      'K8SClusterIPPort': K8SClusterIPPort,
      'K8SNodePortPort': K8SNodePortPort,
      'K8SDeployment': K8SDeployment,
      'K8SDeploymentAnnotation': K8SDeploymentAnnotation,
      'K8SDeploymentDirectEnv': K8SDeploymentDirectEnv,
      'K8SDeploymentSecretReferenceEnv': K8SDeploymentSecretReferenceEnv,
      'K8SDeploymentVolume': K8SDeploymentVolume,
      'K8SIngress': K8SIngress,
      'K8SVolume': K8SVolume,
      'K8SExternalName': K8SExternalName,
      'DockerContext': DockerContext,
      'K8SContext': K8SContext,
      'NginxContext': NginxContext,
      'NginxServerConfig': NginxServerConfig,
      'DatabaseInitializer': DatabaseInitializer,
      'EFKLoggingService': EFKLoggingService,
      'EFKLoggingServiceK8SConfig': EFKLoggingServiceK8SConfig,
      'RabbitMQService': RabbitMQService,
      'RabbitMQServiceK8SConfig': RabbitMQServiceK8SConfig,
      'RedisService': RedisService,
      'RedisServiceK8SConfig': RedisServiceK8SConfig,
      'DBBackupAndRestoreContext': DBBackupAndRestoreContext,
      'DatabaseInfo': DatabaseInfo
  }

  if '__type__' in obj and obj['__type__'] in configClassesDict:
    return __decoder(configClassesDict[obj['__type__']], obj)

  return obj
