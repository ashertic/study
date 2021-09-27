import log
import utils
import os


class ActionHandlerBase:
  def doWork(self, config, cmdArgs):
    pass

  def execute(self, config, cmdArgs):
    try:
      self.doWork(config, cmdArgs)
    except Exception as e:
      print(e)

  def actionName(self):
    return 'here is action name'

  def selectServices(self, services, isSilent, message):
    if isSilent:
      return [(oneService.namespace, oneService.name) for oneService in services]

    utils.printSectionLine('CHOOSE SERVICES', 80)
    log.highlight(
        'choose services to {0}, you can select multiple services:'.format(message))
    print('  [{0:0>2}] {1}'.format(0, 'CHOOSE ALL'))
    for index, oneService in enumerate(services):
      if index % 2 == 0:
        print('  [{0:0>2}] {1}:{2}'.format(
            index + 1, oneService.namespace, oneService.name))
      else:
        log.alternativeRow('  [{0:0>2}] {1}:{2}'.format(
            index + 1, oneService.namespace, oneService.name))

    print('  [{0:0>2}] {1}'.format(len(services) + 1, 'GO BACK'))

    numbers = None
    while True:
      try:
        numbers = []
        servicesNumStr = log.highlightInput(
            'please input services number (separate with space if more than one): ')
        servicesNumStr = servicesNumStr.strip()
        servicesNumStr = servicesNumStr.replace(',', ' ')
        servicesNumStr = servicesNumStr.replace(';', ' ')
        tokens = servicesNumStr.split()
        if len(tokens) == 0:
          continue
        else:
          for oneToken in tokens:
            if oneToken.isnumeric():
              num = int(oneToken)
              if num == 0 or num == len(services) + 1:
                numbers.clear()
                numbers.append(num)
                break
              elif num >= 1 and num <= len(services):
                numbers.append(num)

          if len(numbers) == 0:
            continue
          else:
            break
      except:
        continue

    if len(numbers) == 1 and numbers[0] == 0:
      return [(oneService.namespace, oneService.name) for oneService in services]
    elif len(numbers) == 1 and numbers[0] == len(services) + 1:
      return []
    else:
      selected = []
      for index, oneService in enumerate(services):
        if index + 1 in numbers:
          selected.append((oneService.namespace, oneService.name))
      return selected

  def selectDBInitializer(self, initializers, isSilent, message):
    if isSilent:
      return [oneInitializer.name for oneInitializer in initializers]

    utils.printSectionLine('CHOOSE DB INITIALIZERS', 80)
    log.highlight(
        'choose db initializers to {0}, you can select multiple initializers:'.format(message))
    print('  [{0:0>2}] {1}'.format(0, 'CHOOSE ALL'))
    for index, oneInitializer in enumerate(initializers):
      if index % 2 == 0:
        print('  [{0:0>2}] {1}'.format(index + 1, oneInitializer.name))
      else:
        log.alternativeRow('  [{0:0>2}] {1}'.format(
            index + 1, oneInitializer.name))

    print('  [{0:0>2}] {1}'.format(len(initializers) + 1, 'GO BACK'))

    numbers = None
    while True:
      try:
        numbers = []
        numbersStr = log.highlightInput(
            'please input initializer number (separate with space if more than one): ')
        numbersStr = numbersStr.strip()
        numbersStr = numbersStr.replace(',', ' ')
        numbersStr = numbersStr.replace(';', ' ')
        tokens = numbersStr.split()
        if len(tokens) == 0:
          continue
        else:
          for oneToken in tokens:
            if oneToken.isnumeric():
              num = int(oneToken)
              if num == 0 or num == len(initializers) + 1:
                numbers.clear()
                numbers.append(num)
                break
              elif num >= 1 and num <= len(initializers):
                numbers.append(num)

          if len(numbers) == 0:
            continue
          else:
            break
      except:
        continue

    if len(numbers) == 1 and numbers[0] == 0:
      return [oneInitializer.name for oneInitializer in initializers]
    elif len(numbers) == 1 and numbers[0] == len(initializers) + 1:
      return []
    else:
      selected = []
      for index, oneInitializer in enumerate(initializers):
        if index + 1 in numbers:
          selected.append(oneInitializer.name)
      return selected

  def selectDatabase(self, databases, isSilent, message):
    if isSilent:
      return [oneDatabase.name for oneDatabase in databases]

    utils.printSectionLine('CHOOSE DATABASE', 80)
    log.highlight(
        'choose a database to {0}, you can select multiple databases:'.format(message))
    print('  [{0:0>2}] {1}'.format(0, 'CHOOSE ALL'))
    for index, oneDatabase in enumerate(databases):
      if index % 2 == 0:
        print('  [{0:0>2}] {1}'.format(index + 1, oneDatabase.name))
      else:
        log.alternativeRow('  [{0:0>2}] {1}'.format(
            index + 1, oneDatabase.name))

    print('  [{0:0>2}] {1}'.format(len(databases) + 1, 'GO BACK'))

    numbers = None
    while True:
      try:
        numbers = []
        numbersStr = log.highlightInput(
            'please input database number (separate with space if more than one): ')
        numbersStr = numbersStr.strip()
        numbersStr = numbersStr.replace(',', ' ')
        numbersStr = numbersStr.replace(';', ' ')
        tokens = numbersStr.split()
        if len(tokens) == 0:
          continue
        else:
          for oneToken in tokens:
            if oneToken.isnumeric():
              num = int(oneToken)
              if num == 0 or num == len(databases) + 1:
                numbers.clear()
                numbers.append(num)
                break
              elif num >= 1 and num <= len(databases):
                numbers.append(num)

          if len(numbers) == 0:
            continue
          else:
            break
      except:
        continue

    if len(numbers) == 1 and numbers[0] == 0:
      return [oneDatabase.name for oneDatabase in databases]
    elif len(numbers) == 1 and numbers[0] == len(databases) + 1:
      return []
    else:
      selected = []
      for index, oneDatabase in enumerate(databases):
        if index + 1 in numbers:
          selected.append(oneDatabase.name)
      return selected

  def getServiceImageFilePath(self, service, imageOutputRootDir):
    imageFileName = '{0}.tgz'.format(
        service.srcImage.replace('/', '-').replace(':', '-'))

    imageFilePath = ''
    if service.imageCategory == 'thirdparty':
      imageFilePath = os.path.join(
          imageOutputRootDir, service.imageCategory, imageFileName)
    else:
      imageFilePath = os.path.join(
          imageOutputRootDir, 'minerva', service.imageCategory, imageFileName)

    return imageFilePath

  def getDBInitializerImageFilePath(self, initializer, imageOutputRootDir):
    imageFileName = '{0}.tgz'.format(
        initializer.srcImage.replace('/', '-').replace(':', '-'))

    imageFilePath = os.path.join(
        imageOutputRootDir, 'minerva', initializer.imageCategory, imageFileName)

    return imageFilePath

  def getNginxProxyImageFilePath(self, nginxContext, imageOutputRootDir):
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
