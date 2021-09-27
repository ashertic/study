import click
from .utils import execute_command
from .nginx.save import SaveNginxProxyImageAction
from .nginx.remove import RemoveNginxProxyAction
from .nginx.install import InstallNginxProxyAction


@click.group(help="Nginx related sub commands")
@click.pass_context
def nginx(ctx):
  pass


@nginx.command(help="Save nginx proxy docker image to file")
@click.pass_context
def save(ctx):
  execute_command(ctx, SaveNginxProxyImageAction)


@nginx.command(help="Install nginx proxy")
@click.pass_context
def install(ctx):
  execute_command(ctx, InstallNginxProxyAction)


@nginx.command(help="Remove nginx proxy")
@click.pass_context
def remove(ctx):
  execute_command(ctx, RemoveNginxProxyAction)
