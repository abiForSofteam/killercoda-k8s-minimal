#!/bin/bash
# Initialisation minimale

echo "Waiting for Kubernetes to be ready..."

# attendre que le cluster soit prêt
until kubectl get nodes &> /dev/null; do
  sleep 2
done

echo "Kubernetes is ready"
