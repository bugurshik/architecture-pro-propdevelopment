minikube delete
minikube start

minikube cp "audit-policy.yaml" /etc/ssl/certs/audit-policy.yaml
minikube ssh "sudo mkdir -p /var/log/"

minikube stop

minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=/var/log/audit.log