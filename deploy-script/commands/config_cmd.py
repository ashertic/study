import click
from .utils import check_config_option

from configs import loadConfig, printKeyInformation


@click.group(help="JSON Config related sub commands")
@click.pass_context
def config(ctx):
  pass


@config.command(help="Print JSON Config file content")
@click.pass_context
def print(ctx):
  config_file = check_config_option(ctx)
  config_content = loadConfig(config_file)
  printKeyInformation(config_content)


@config.command(help="Check JSON Config file content and report errors")
@click.pass_context
def audit(ctx):
  config_file = check_config_option(ctx)
  click.echo('config audit is not implemented yes, please wait')
