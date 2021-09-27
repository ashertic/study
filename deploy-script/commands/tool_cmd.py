import click
from .utils import execute_command

from .tool.sid import GenerateIDAction


@click.group(help="Other utility tool sub commands")
@click.pass_context
def tool(ctx):
  pass


@tool.command(help="Generate machine id")
@click.pass_context
def sid(ctx):
  execute_command(ctx, GenerateIDAction)
