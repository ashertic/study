1.Docker deamon监听tcp端口设置
我们通常使用docker ps，docker images都只是使用docker client与docker daemon进行通信，docker client发送请求给docker daemon，docker daemon返回结果给client。 默认情况下docker daemon支持unix通信（/var/run/docker.sock）,这个可以通过以下命令check。  
>netstat -nlp | grep docker  

 如果需要修改client与docker daemon进行性能。则需要修改docker daemon支持tcp通信，修改下列配置文件
 >/lib/systemd/system/docker.service   
 在ExecStart=字段后面添加-H tcp://0.0.0.0:2375，重启服务  
 systemctl restart docker 

 在client节点田间一下环境变量
 >DOCKER_HOST=tcp://<daemon ip>:2375

 2.用户的个人认证信息将会保存在$.HOME/.docker/config.json

 3.修改docker默认存储路径
 >vim /usr/lib/systemd/system/docker.service  
在ExecStart=字段后面添加--graph=/data/test(指定要存放的image的目录)  
systemctl daemon-reload && systemctl restart docker  

注意:在修改了docker的默认存储image的路径之后，原来已经存储的image将不能再使用，需要重新docker load。

4.在docker build的时候如果Dockerfile中定义了EXPOSE可以直接在命令行使用-P参数，随机的将宿主机的一个端口映射到容器EXPOSE指定的端口。
也可以直接使用--net=host共享宿主机网络，还可以使用-p参数，指定映射端口，参数前边的端口表示宿主机映射的端口，后面的端口表示要映射的容器的端口。
如果dockerfile中的没有使用EXPOSE端口，就要看具体的服务所监听的端口了，运行container的时候可以直接使用-p对其进行映射。
如果指定端口的时候出现iptables的问题报错，则重启docker服务

5.
