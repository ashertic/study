import click
from .utils import execute_command

from .database.save import SaveDBIntializerImagesAction
from .database.init import InitializeDatabaseAction
from .database.backup import BackupDBAction
from .database.restore import RestoreDBAction


@click.group(help="Database related sub commands")
@click.pass_context
def db(ctx):
  pass


@db.command(help="Save database initializer docker images to file")
@click.pass_context
def save(ctx):
  execute_command(ctx, SaveDBIntializerImagesAction)


@db.command(help="Initialize database with db docker images")
@click.pass_context
def init(ctx):
  execute_command(ctx, InitializeDatabaseAction)


@db.command(help="Backup database content to file")
@click.pass_context
def backup(ctx):
  execute_command(ctx, BackupDBAction)


@db.command(help="Restore database content from file")
@click.pass_context
def restore(ctx):
  execute_command(ctx, RestoreDBAction)
