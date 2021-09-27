from colorama import Fore, Back, Style


def highlight(text, end='\n'):
  print(Fore.GREEN + text + Style.RESET_ALL, end=end)


def title(text, end='\n'):
  print(Fore.BLUE + text + Style.RESET_ALL, end=end)


def error(text, end='\n'):
  print(Fore.RED + text + Style.RESET_ALL, end=end)


def highlightInput(text):
  highlight(text, end='')
  return input('')


def dangerInput(text):
  error(text, end='')
  return input('')


def alternativeRow(text, end='\n'):
  print(Fore.CYAN + text + Style.RESET_ALL, end=end)
