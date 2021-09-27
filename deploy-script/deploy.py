import usage
from colorama import init

from command import execute
from config import loadConfig
from actions.actionManager import ActionManager


init()  # colorma initialize
args = usage.parse()
config = loadConfig(args.config)
actionManager = ActionManager(config.context.mode)
actionManager.loop(config, args)
