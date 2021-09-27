# 获取Node信息
```
kubectl get nodes
```

# 获取Node描述信息
```
kubectl describe nodes node1
```

# 给Node添加标签
```
kubectl label nodes node1 node-tag=gpu-001
kubectl label nodes node2 node-tag=gpu-002
kubectl label nodes node3 node-tag=gpu-003

kubectl label nodes node4 node-tag=cpu-001
```

# 获取Deployment相关信息
```
kubectl get deployments.apps -n identity
```

# 获取Pods相关信息
```
kubectl get pods -n identity
kubectl get pods -n expert
kubectl get pods -n dialog
```

# 描述详细信息
```
kubectl describe pods -n identity [pod name]
kubectl describe daemonsets.apps -n logging fluent-bit
```

# 获取Service的信息
```
kubectl get service -n identity
```

# 获取namespace相关信息
```
kubectl get namespaces
```

# 查看某个deployment下面对应的Pods下面运行的container的日志：
```
# check log with deployment name
kubectl logs deployment/expert-api -n expert
kubectl logs deployment/information-extraction-cpu0 -n expert
kubectl logs deployment/information-extraction-gpu0 -n expert
kubectl logs deployment/information-extraction-mt -n expert

# check log with Pods name, you can get pods first to get its name
kubectl logs -n infra log-elasticsearch-868bb5db46-glpv4

# 如果需要每个3秒刷新一次，可以使用如下命令
watch -n 3 kubectl logs deployment/information-extraction-cpu0 -n expert
watch -n 3 kubectl logs deployment/information-extraction-gpu0 -n expert
```

# 在某个deployment下面对应的Pods下面运行的container中执行shell：
```
kubectl exec -it -n expert information-extraction-cpu0-5d47d77d77-xhqhh /bin/sh
```

# 在某个Pods的container里面执行命令，查看shell
```
# infra后面是pod container的名字
kubectl exec -it -n infra log-kibana-7b65fc45f6-fkhsc /bin/sh
```

# 如何重新部署一个服务
## 只是更新了Docker Image，或者更新了通过Volume加载的数据，但是不需要更新任何的配置的情况，执行类似如下的两个命令：
```
kubectl delete -f ./expert-config/expert-api/deployment.yaml
kubectl apply -f ./expert-config/expert-api/deployment.yaml

kubectl delete -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml
kubectl apply -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml

kubectl delete -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml
kubectl apply -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml

kubectl delete -f ./expert-config/information-extraction-backend/mt-deployment.yaml
kubectl apply -f ./expert-config/information-extraction-backend/mt-deployment.yaml
```

# 重新部署information extraction相关服务
```
kubectl delete -f ./expert-config/information-extraction-backend/mt-deployment.yaml
kubectl delete -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml
kubectl delete -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml

kubectl apply -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml
sleep 30
kubectl get pods -n expert

kubectl apply -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml
sleep 30
kubectl get pods -n expert

kubectl apply -f ./expert-config/information-extraction-backend/mt-deployment.yaml
sleep 30
watch -n 5 kubectl get pods -n expert
# 观察几分钟确定三个服务都是完好的活着
```


# 从K8S Cluster移除一个Node
```
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl get nodes
kubectl drain <node-name> --ignore-daemonsets
kubectl delete node <node-name>

kubectl drain node5 --delete-local-data --force --ignore-daemonsets
```