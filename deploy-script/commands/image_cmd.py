import click
from .utils import execute_command

from .image.save import ImageSaveAction
from .image.load import ImageLoadAction
from .image.load_push import ImageLoadAndPushAction


@click.group(help="Docker image related sub commands")
@click.pass_context
def image(ctx):
  pass


@image.command(help="Save docker images from source docker image registry to files")
@click.pass_context
def save(ctx):
  execute_command(ctx, ImageSaveAction)


@image.command(help="Load docker images from file")
@click.pass_context
def load(ctx):
  execute_command(ctx, ImageLoadAction)


@image.command(name="load_push", help="Load docker images and push to private docker image registry")
@click.pass_context
def load_push(ctx):
  execute_command(ctx, ImageLoadAndPushAction)
