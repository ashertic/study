import argparse
import log
import utils

# Please refer to: https://docs.python.org/3.3/library/argparse.html


def parse():
  parser = argparse.ArgumentParser(description='Deploy Minerva Services')
  parser.add_argument('config', help='path of deployment config file')
  parser.add_argument('--silent', help='execute without confirmation',
                      dest='isSilent', default=False, type=bool, required=False)
  args = parser.parse_args()

  utils.printSectionLine('INPUT Parameters', 80, '#')
  print('config={0}'.format(args.config))
  print('isSilent={0}'.format(args.isSilent))
  utils.printSectionLine('', 80, '#')
  return args
