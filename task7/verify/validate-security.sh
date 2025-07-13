#!/bin/bash

echo "Проверка защищенных манифестов..."

for file in secure-manifests/*.yaml; do
  echo "Applying $file"
  kubectl apply -f "$file" || {
    echo "ERROR: $file should have been allowed but was rejected!"
    exit 1
  }
done

echo "Все защищенные манифесты упешно применились."