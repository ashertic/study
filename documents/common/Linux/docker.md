### docker修改默认的Docker Root Dir

停止docker服务

vi /etc/docker/daemon.json

增加选项 "graph":"/home/docker",