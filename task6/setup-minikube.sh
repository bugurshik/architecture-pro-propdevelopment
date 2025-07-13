minikube delete
minikube start

#  На хосте должно быть
#  C:\Users\{user}\.minikube\files\etc\ssl\certs\audit-policy.yaml
#  C:\Users\{user}\.minikube\files\var\log\audit.log

minikube cp "audit-policy.yaml" /etc/ssl/certs/audit-policy.yaml
minikube ssh "sudo mkdir -p /var/log/"

minikube stop

minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=/var/log/audit.log