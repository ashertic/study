import os
import log


def printSectionLine(section, length, fill='-'):
  if section != '':
    section = ' ' + section + ' '

  fillLengthLeft = (length - len(section)) // 2
  fillLengthRight = length - len(section) - fillLengthLeft
  log.title(fill * fillLengthLeft + section + fill * fillLengthRight)
  return


def createDirForFile(fileName):
  dirName = os.path.dirname(os.path.abspath(fileName))
  os.makedirs(dirName, exist_ok=True)
  return


def createDir(dirName):
  dirName = os.path.abspath(dirName)
  os.makedirs(dirName, exist_ok=True)
  return
