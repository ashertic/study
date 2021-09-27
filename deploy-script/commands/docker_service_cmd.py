import click
from .utils import execute_command

from .docker.install import InstallDockerServiceAction
from .docker.remove import RemoveDockerServiceAction


@click.group(help="Docker services related sub commands")
@click.pass_context
def docker(ctx):
  pass


@docker.command(help="Install docker services")
@click.pass_context
def install(ctx):
  execute_command(ctx, InstallDockerServiceAction)


@docker.command(help="Remove docker services")
@click.pass_context
def remove(ctx):
  execute_command(ctx, RemoveDockerServiceAction)
