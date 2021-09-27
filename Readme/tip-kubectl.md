
## 查看GPU的数量
```
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu"
```


kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
https://stackoverflow.com/questions/44190607/how-do-you-find-the-cluster-service-cidr-of-a-kubernetes-cluster


# Kubernetes常用命令
```
kubectl get nodes
kubectl get pods --all-namespaces

kubectl api-resources

kubectl get secrets meinenghua --output=yaml


kubectl get secrets --namespace=identity
kubectl get secrets credential --namespace=identity
kubectl get secrets credential --namespace=identity -o yaml

kubectl get persistentvolumes
kubectl get persistentvolumeclaims --namespace=identity

kubectl get deployments --namespace=identity
kubectl describe deployments postgres --namespace=identity
kubectl get pods --namespace=identity

kubectl describe pods --namespace=identity postgres-7d58655c5-cmrv5

kubectl delete secrets --namespace=identity credential
kubectl delete deployments --namespace=identity postgres

```