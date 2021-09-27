kubectl get pods --all-namespaces -l name=nvidia-device-plugin-ds
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu"

ecs-gpu-0508273.novalocal 4

ecs-gpu-0508275.novalocal 4 gpu001

# 在 deployment.yaml 中添加如下内容到 imagePullPolicy: Alwaqys 下一行

```yaml
resources:
  limits:
    nvidia.com/gpu: 1
```
