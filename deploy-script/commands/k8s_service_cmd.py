import click
from .utils import execute_command


from .k8s.yaml_generate import K8SYamlGenerateAction
from .k8s.common_create import CreateK8SCommonConfigAction
from .k8s.common_remove import RemoveK8SCommonConfigAction
from .k8s.service_install import InstallK8SServiceAction
from .k8s.service_remove import RemoveK8SServiceAction
from .k8s.service_update import UpdateK8SServiceAction


@click.group(help="K8S related sub commands")
@click.pass_context
def k8s(ctx):
  pass


@k8s.group(help="K8S common actions related sub commands")
@click.pass_context
def common(ctx):
  pass


@common.command(name="create", help="Create K8S namespaces, image pull secret and other common stuffs")
@click.pass_context
def common_create(ctx):
  execute_command(ctx, CreateK8SCommonConfigAction)


@common.command(name="remove", help="Remove K8S namespaces, image pull secret and other common stuffs")
@click.pass_context
def common_remove(ctx):
  execute_command(ctx, RemoveK8SCommonConfigAction)


@k8s.group(help="K8S YAML config related sub commands")
@click.pass_context
def yaml(ctx):
  pass


@yaml.command(name="generate", help="Generate K8S YAML config based on JSON config")
@click.pass_context
def yaml_generate(ctx):
  execute_command(ctx, K8SYamlGenerateAction)


@k8s.group(help="K8S services related sub commands")
@click.pass_context
def service(ctx):
  pass


@service.command(name="install", help="Install K8S services to k8s cluster")
@click.pass_context
def service_install(ctx):
  execute_command(ctx, InstallK8SServiceAction)


@service.command(name="remove", help="Remove K8S services from k8s cluster")
@click.pass_context
def service_remove(ctx):
  execute_command(ctx, RemoveK8SServiceAction)


@service.command(name="update", help="Update K8S services in k8s cluster")
@click.pass_context
def service_update(ctx):
  execute_command(ctx, UpdateK8SServiceAction)
