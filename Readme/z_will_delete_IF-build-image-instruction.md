执行下面的命令，在本地登录华为容器镜像Registry，我们以后的部署image都从这个地方拉：
docker login -u cn-north-4@GEVBQJCVF7ELO6E08LKL -p b176220c854d2610e28ce77448f7c10ef2a95d2c5029e869fd73a497cf79b4b0 swr.cn-north-4.myhuaweicloud.com

在本地Build information extraction的image，如果是给PWC的，加上硬件加密。
docker build -t <your tag> .

给本地build好的经过加密的image打上特定的tag，如下：
docker tag <your tag> swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:pwc

将修改了tag之后的image push到华为容器镜像Resgistry
docker push swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:pwc

如果要在本地直接将Image保存为文件，可以执行如下命令：
docker save swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:pwc | gunzip > information_extraction.tgz

其他没有被包含到Docker Image的依赖数据，可以直接上传到百度网盘上的如下路径：
k8s-deploy/expert-data/
在这个路径下建一个自己的目录，比如： information-extraction-20191210
然后把文件上传上去

如果百度云盘不方便访问，或者速度很慢，也可以选择U盘拷贝给我，或者上传到192.168.1.9的share目录下，找一个合适的路径存放