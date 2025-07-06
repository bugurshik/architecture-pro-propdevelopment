#!/bin/bash

CERT_DIR="certs"
mkdir -p $CERT_DIR

create_user() {
  local USER_NAME=$1
  local GROUP_NAME=$2
  openssl genrsa -out ${CERT_DIR}/${USER_NAME}.key 2048
  openssl req -new -key ${CERT_DIR}/${USER_NAME}.key \
    -out ${CERT_DIR}/${USER_NAME}.csr \
    -subj "/CN=${USER_NAME}/O=${GROUP_NAME}"
  openssl x509 -req -in ${CERT_DIR}/${USER_NAME}.csr \
    -CA ~/.minikube/ca.crt \
    -CAkey ~/.minikube/ca.key \
    -CAcreateserial \
    -out ${CERT_DIR}/${USER_NAME}.crt \
    -days 365

  KUBECONFIG_PATH="${CERT_DIR}/${USER_NAME}.kubeconfig"

  kubectl config set-cluster minikube --server=https://$(minikube ip):8443 --certificate-authority=~/.minikube/ca.crt --embed-certs=true --kubeconfig=${KUBECONFIG_PATH}
  kubectl config set-credentials ${USER_NAME} \
    --client-certificate=${CERT_DIR}/${USER_NAME}.crt \
    --client-key=${CERT_DIR}/${USER_NAME}.key \
    --embed-certs=true \
    --kubeconfig=${KUBECONFIG_PATH}
  kubectl config set-context default-context \
    --cluster=minikube \
    --user=${USER_NAME} \
    --kubeconfig=${KUBECONFIG_PATH}

  echo "Пользователь $USER_NAME создан. Конфигурация: $KUBECONFIG_PATH"
}

create_user "oleg" "managers"
create_user "sashka" "viewers"