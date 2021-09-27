import subprocess
import log
import os
from threading import Thread
import time
from datetime import datetime
# Please refer to: https://janakiev.com/blog/python-shell-commands/


class LoadingFlag:
  def __init__(self, message, interval):
    self.isRunning = True
    self.message = message
    self.interval = interval

  def stop(self):
    self.isRunning = False

  def start(self):
    while True:
      time.sleep(self.interval)
      print("[{}] {}".format(datetime.now().strftime('%Y%m%d%H%M%S'), self.message))
      if not self.isRunning:
        break


def execute(cmd):
  log.highlight(' '.join(cmd))
  process = subprocess.Popen(
      cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)

  loading = LoadingFlag('command is still executing', 10)
  t = Thread(target=loading.start)
  t.start()

  isSuccessfull = True
  while True:
    output = process.stdout.readline()
    output = output.strip()
    if output != '':
      print(output)

    for error in process.stderr.readlines():
      error = error.strip()
      if error != '':
        log.error(error)

    # Do something else
    return_code = process.poll()
    if return_code is not None:
      isSuccessfull = True if return_code == 0 else False
      # print('RETURN CODE', return_code)
      # Process has finished, read rest of the output
      for output in process.stdout.readlines():
        output = output.strip()
        if output != '':
          print(output)

      for error in process.stderr.readlines():
        error = error.strip()
        if error != '':
          log.error(error)

      break

  loading.stop()
  t.join()

  return isSuccessfull


def executeWithPipe(cmd1, cmd2):
  p1 = subprocess.Popen(cmd1, stdout=subprocess.PIPE)
  p2 = subprocess.Popen(cmd2,
                        stdin=p1.stdout,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        universal_newlines=True)
  p1.stdout.close()

  loading = LoadingFlag('command is still executing', 10)
  t = Thread(target=loading.start)
  t.start()

  isSuccessfull = True
  while True:
    output = p2.stdout.readline()
    output = output.strip()
    if output != '':
      print(output)

    for error in p2.stderr.readlines():
      error = error.strip()
      if error != '':
        log.error(error)

    return_code = p2.poll()
    if return_code is not None:
      isSuccessfull = True if return_code == 0 else False
      for output in p2.stdout.readlines():
        output = output.strip()
        if output != '':
          print(output)

      for error in p2.stderr.readlines():
        error = error.strip()
        if error != '':
          log.error(error)

      break

  loading.stop()
  t.join()

  return isSuccessfull


def executeWithOSSystem(cmd):
  exeCmd = ' '.join(cmd)
  log.highlight(exeCmd)
  reCode = os.system(exeCmd)
  if reCode == 0:
    return True
  else:
    return False
