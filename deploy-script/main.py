# #!/usr/bin/env python
# # encoding: utf-8

# import usage
# from config import loadConfig
# from gui.deployConfigContext import DeployConfigContext
# from gui.app import DeployApp


# if __name__ == '__main__':
#   args = usage.parse()
#   config = loadConfig(args.config)
#   context = DeployConfigContext()
#   context.setConfig(config)

#   app = DeployApp()
#   app.run()
#

import commands

if __name__ == '__main__':
  commands.cli()
