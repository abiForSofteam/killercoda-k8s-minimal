#!/bin/bash

# Wait for cluster to be ready
until kubectl get nodes &>/dev/null; do sleep 5; done
sleep 10

# Create namespace for the exercise
kubectl get namespace commerce &>/dev/null || kubectl create namespace commerce &>/dev/null

# Deploy the catalog service (backend)
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog
  namespace: commerce
spec:
  replicas: 1
  selector:
    matchLabels:
      app: catalog
  template:
    metadata:
      labels:
        app: catalog
    spec:
      containers:
      - name: catalog
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: catalog
  namespace: commerce
spec:
  selector:
    app: catalog
  ports:
  - port: 80
    targetPort: 80
EOF

# Deploy the frontend service (client that performs DNS resolution)
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: commerce
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: busybox:1.36
        command: ["sh", "-c", "while true; do sleep 30; done"]
EOF

# Wait for deployments to be available
kubectl rollout status deployment/catalog -n commerce --timeout=60s &>/dev/null
kubectl rollout status deployment/frontend -n commerce --timeout=60s &>/dev/null

# Inject failure: corrupt the CoreDNS ConfigMap with an invalid plugin directive
kubectl get configmap coredns -n kube-system -o json | \
  sed 's/errors/errorz/' | \
  kubectl apply -f - &>/dev/null

# Restart CoreDNS to apply corrupted config
kubectl rollout restart deployment/coredns -n kube-system &>/dev/null

# Wait briefly for CoreDNS to attempt restart with broken config
sleep 15

exit 0
