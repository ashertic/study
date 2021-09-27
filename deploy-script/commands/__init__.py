import click
from .config_cmd import config
from .image_cmd import image
from .k8s_service_cmd import k8s
from .database_cmd import db
from .docker_service_cmd import docker
from .nginx_cmd import nginx
from .tool_cmd import tool


@click.group(help='Minerva Services Deployment Tool')
@click.option('--config', help='JSON config file path, required')
@click.pass_context
def cli(ctx, config):
  ctx.ensure_object(dict)
  ctx.obj['config'] = config


cli.add_command(config)
cli.add_command(image)
cli.add_command(k8s)
cli.add_command(db)
cli.add_command(docker)
cli.add_command(nginx)
cli.add_command(tool)
