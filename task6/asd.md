
minikube ssh "sudo mkdir -p .minikube/files/etc/ssl/certs"
minikube ssh "sudo mkdir -p /var/log/kubernetes/audit"

minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=/var/log/audit.log --kubernetes-version=v1.25.16


minikube start 
minikube cp C:\Users\Sergo\source\repos\architecture-pro-propdevelopment\task6\audit-policy.yaml /etc/ssl/certs/audit-policy.yaml

minikube start --extra-config=apiserver.audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml --extra-config=apiserver.audit-log-path=/var/log/audit.log

minikube cp C:\Users\Sergo\source\repos\architecture-pro-propdevelopment\task6\kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

## Копировать apiserver
minikube ssh "sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml" > kube-apiserver.yaml

# Установить apiserver
minikube cp "kube-apiserver.yaml" /etc/kubernetes/manifests/kube-apiserver.yaml

## Копировать audit-policy
minikube ssh "sudo cat /etc/ssl/certs/audit-policy.yaml" > 2audit-policy.yaml

# Копировать audit.log
minikube ssh "sudo cat /var/log/audit.log" > audit.log
