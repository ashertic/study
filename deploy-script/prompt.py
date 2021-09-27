import signal
import log
from datetime import datetime

# Please refer to: https://www.semicolonworld.com/question/44145/python-3-timed-input


def alarm_handler(signum, frame):
  raise Exception('timeouot')


def input_with_timeout(prompt, timeout, default):
  # set signal handler
  signal.signal(signal.SIGALRM, alarm_handler)
  # produce SIGALRM in `timeout` seconds
  signal.alarm(timeout)

  try:
    return log.highlightInput(prompt)
  except Exception:
    return default
  finally:
    signal.alarm(0)  # cancel alarm


def confirm(prompt):
  choice = None
  while choice != 'yes' and choice != 'no':
    choice = log.highlightInput(prompt + ' [ Yes | No ]: ')
    choice = choice.lower()

  if choice == 'yes':
    return True
  else:
    return False


def dangerConfirm(prompt):
  now = datetime.now()
  confirmKey = 'DELETE_AT_' + now.strftime('%Y%m%d%H%M%S')
  log.error(prompt)
  choice = log.dangerInput(
      'this action is dangerous, please input "{0}" to confirm, or any other to cancel: '.format(confirmKey))
  if choice == confirmKey:
    return True
  else:
    return False


if __name__ == "__main__":
  timeout = 5
  prompt = "You have %d seconds to choose the correct answer...\n" % timeout
  answer = input_with_timeout(prompt, timeout, 'default answer 1')
  print('answer=', answer)

  prompt = "You have %d seconds to choose the correct answer...\n" % timeout
  answer = input_with_timeout(prompt, timeout, 'default answer 2')
  print('answer=', answer)
