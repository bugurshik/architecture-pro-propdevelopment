#!/bin/bash

echo "Проверка небезопасных манифестов..."

for file in insecure-manifests/*.yaml; do
  echo "Applying $file"
  kubectl apply -f "$file" && {
    echo "ERROR: $file was supposed to be blocked!"
    exit 1
  } || echo "Blocked as expected."
done

echo "Все небезопасные манифесты были блокированны."