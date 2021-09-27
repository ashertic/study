import click
import os

from configs import loadConfig
from PyInquirer import prompt, Separator, style_from_dict, Token

custom_style = style_from_dict({
    Token.Separator: '#E74C3C',
    Token.QuestionMark: '#FF9D00 bold',
    Token.Selected: '#00FF00',
    Token.Pointer: '#FF9D00 bold',
    Token.Instruction: '',
    Token.Answer: '#5F819D bold',
    Token.Question: '#8E44AD',
})


def check_config_option(ctx):
  config = ctx.obj['config']
  if config is None:
    raise click.UsageError('JSON config file is not provided')
  else:
    click.echo(f'config is: {config}')
    return config


def execute_command(ctx, commandCls):
  config_file = check_config_option(ctx)
  config_obj = loadConfig(config_file, showKeyInfo=False)
  action = commandCls(config_obj)
  action.execute()
  return


def select(message, options, separator_prefix='Category'):
  name_key = 'selected'
  choices = []

  if isinstance(options, dict):
    for group, group_opts in options.items():
      choices.append(Separator(f'{separator_prefix}: {group}'))
      for one in group_opts:
        choices.append({'name': f'{group}:{one}'})
  else:
    for opt in options:
      choices.append({'name': f'{opt}'})

  questions = [
      {
          'type': 'checkbox',
          'message': f'{message} (CTRL + C to cancel):',
          'name': name_key,
          'choices': choices
      }
  ]
  answers = prompt(questions, style=custom_style)
  if name_key in answers:
    selected = answers[name_key]
  else:
    selected = []

  return selected


def select_services(services):
  service_dict = dict()
  for oneService in services:
    if oneService.namespace not in service_dict:
      service_dict[oneService.namespace] = []
    service_dict[oneService.namespace].append(oneService.name)

  return select('Select services', service_dict, 'Category')


def select_db_initializer(initializers):
  initializer_dict = dict()
  for oneInitializer in initializers:
    if oneInitializer.imageCategory not in initializer_dict:
      initializer_dict[oneInitializer.imageCategory] = []
    initializer_dict[oneInitializer.imageCategory].append(oneInitializer.name)

  return select('Select initializers', initializer_dict, 'Category')


def select_db_backup_restore(databases):
  names = [one.name for one in databases]
  return select('Select databases', names)


def getNginxProxyImageFilePath(nginxContext, imageOutputRootDir):
  imageFileName = '{0}.tgz'.format(
      nginxContext.srcImage.replace('/', '-').replace(':', '-'))
  imageFilePath = ''
  if nginxContext.imageCategory == 'thirdparty':
    imageFilePath = os.path.join(
        imageOutputRootDir, nginxContext.imageCategory, imageFileName)
  else:
    imageFilePath = os.path.join(
        imageOutputRootDir, 'minerva', nginxContext.imageCategory, imageFileName)
  return imageFilePath
