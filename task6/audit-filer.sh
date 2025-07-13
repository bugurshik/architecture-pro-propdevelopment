AUDIT_LOG="audit.log"
OUTPUT="audit-extract.json"

# 1. Доступ к secrets
jq -c 'select(.objectRef.resource=="secrets" and .verb=="get")' "$AUDIT_LOG" >> "$OUTPUT"

# 2. Привилегированные поды
jq -c 'select(.objectRef.resource=="pods" and .requestObject.spec.containers[].securityContext.privileged==true)' "$AUDIT_LOG" >> "$OUTPUT"

# 3. kubectl exec
jq -c 'select(.verb=="create" and .objectRef.subresource=="exec")' "$AUDIT_LOG" >> "$OUTPUT"

# 4. Cluster-admin RoleBinding
jq -c 'select(.requestObject.roleRef.name=="cluster-admin")' "$AUDIT_LOG" >> "$OUTPUT"

# 5. Удаление audit-policy.yaml
grep -i 'audit-policy' "$AUDIT_LOG" | jq -c '.' >> "$OUTPUT"

# Удалить последнюю запятую, если есть, и закрыть массив

echo "Фильтрация завершена. Результат сохранён в $OUTPUT"