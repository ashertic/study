from actions.actionHandler import ActionHandlerBase
import log
import command
import utils
import shutil
import os


class InstallNginxProxyAction(ActionHandlerBase):
  __serverTemplate = '''
    # {0}
    server {{
      listen                      {1}  ssl;
      server_name                 {2};

      ssl_certificate             /etc/nginx/cert/server.crt;
      ssl_certificate_key         /etc/nginx/cert/server.rsa;
      server_tokens               off;
      ssl_session_cache           shared:SSL:1m;
      ssl_session_timeout         5m;
      ssl_prefer_server_ciphers   on;

      location / {{
        proxy_pass                {3};
        proxy_http_version        1.1;
        proxy_set_header          Upgrade           $http_upgrade;
        proxy_set_header          Connection        "Upgrade";
        proxy_set_header          Host              $host;
        proxy_set_header          X-Forwarded-For   $remote_addr;
      }}
    }}


'''

  def __loadNginxProxyImage(self, nginxContext, imageOutputRootDir):
    imageFilePath = self.getNginxProxyImageFilePath(
        nginxContext, imageOutputRootDir)
    cmd1 = ['gunzip', '-c', imageFilePath]
    cmd2 = ['docker', 'load']
    isSuccessful = command.executeWithPipe(cmd1, cmd2)

    if isSuccessful:
      log.highlight('load image from file successfully')
    else:
      log.error('load image from file failed')
    return

  def doWork(self, config, cmdArgs):
    utils.printSectionLine('', 80, '*')
    if config.nginxContext is None:
      log.error("can't find any nginx config in config json file, so do nothing")
      return

    nginxContext = config.nginxContext

    self.__loadNginxProxyImage(nginxContext, config.context.imageOutputRootDir)

    targetNginxDirectory = nginxContext.targetNginxDir
    utils.createDir(targetNginxDirectory)

    certCrtFilePath = nginxContext.certDir + '/server.crt'
    certRsaFilePath = nginxContext.certDir + '/server.rsa'

    certPath = os.path.abspath(targetNginxDirectory + '/cert')
    utils.createDir(certPath)
    shutil.copy(os.path.abspath(certCrtFilePath),
                certPath + '/server.crt')
    shutil.copy(os.path.abspath(certRsaFilePath),
                certPath + '/server.rsa')

    confPath = os.path.abspath(targetNginxDirectory + '/nginx.conf')
    logPath = os.path.abspath(targetNginxDirectory + '/log')
    confdPath = os.path.abspath(targetNginxDirectory + '/conf.d')

    with open('./nginx-template/template.conf', 'r', encoding='utf-8') as f:
      confTemplateStr = f.read()
      serversValue = ''
      for oneServer in nginxContext.servers:
        tempValue = self.__serverTemplate.format(oneServer.comment,
                                                 oneServer.sslListenPort,
                                                 oneServer.serverName,
                                                 oneServer.proxyPass)
        serversValue += tempValue

      confTemplateStr = confTemplateStr.replace(
          'SERVERS_PLACEHOLDER', serversValue)
      with open(confPath, 'w', encoding='utf-8') as output:
        output.write(confTemplateStr)

    cmd = ['docker', 'run', '-d', '--name', nginxContext.containerName,
           '--restart=always', '--network', 'host',
           '-v', confPath + ':/etc/nginx/nginx.conf',
           '-v', logPath + ':/var/log/nginx',
           '-v', confdPath + ':/etc/nginx/conf.d',
           '-v', certPath + ':/etc/nginx/cert',
           config.dockerContext.srcRegistryBase + nginxContext.srcImage]
    command.execute(cmd)
    return

  def actionName(self):
    return 'NGINX --- install nginx proxy'
