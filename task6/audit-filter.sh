AUDIT_LOG="audit.log"
OUTPUT="audit-extract.json"

# 1. Доступ к secrets
kubectl logs kube-apiserver-minikube -n kube-system | grep '^{".*}$'| jq 'select(.objectRef.resource=="secrets")' >> "$OUTPUT"

# 2. Привилегированные поды
kubectl logs kube-apiserver-minikube -n kube-system | grep '^{".*}$'| jq 'select(.objectRef.resource=="pods" and .requestObject.spec.containers[].securityContext.privileged==true)' >> "$OUTPUT"

# 3. kubectl exec
kubectl logs kube-apiserver-minikube -n kube-system | grep '^{".*}$'| jq 'select(.verb=="create" and .objectRef.subresource=="exec")' >> "$OUTPUT"

# 4. Cluster-admin RoleBinding
kubectl logs kube-apiserver-minikube -n kube-system | grep '^{".*}$'| jq 'select(.requestObject.roleRef.name=="cluster-admin")' >> "$OUTPUT"

# 5. Удаление audit-policy.yaml
kubectl logs kube-apiserver-minikube -n kube-system | grep '^{".*}$' | jq 'select(.verb == "delete" and .objectRef.resource == "policies" or (.requestObject | has("kind") and .requestObject.kind == "Policy"))' >> "$OUTPUT"

# Удалить последнюю запятую, если есть, и закрыть массив

echo "Фильтрация завершена. Результат сохранён в $OUTPUT"