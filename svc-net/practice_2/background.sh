#!/bin/bash

# Wait for cluster to be ready
until kubectl get nodes &>/dev/null; do sleep 5; done
sleep 10

# Create namespaces
kubectl get namespace backend &>/dev/null || kubectl create namespace backend &>/dev/null
kubectl get namespace frontend &>/dev/null || kubectl create namespace frontend &>/dev/null

# Deploy backend service (HTTP echo server)
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api-server
        image: hashicorp/http-echo:0.2.3
        args:
          - "-text=OK from api-server"
        ports:
        - containerPort: 5678
EOF

# Deploy backend ClusterIP service
kubectl apply -f - &>/dev/null <<EOF
apiVersion: v1
kind: Service
metadata:
  name: api-server
  namespace: backend
spec:
  selector:
    app: api-server
  ports:
  - port: 80
    targetPort: 5678
EOF

# Deploy frontend pod (curl client)
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: frontend
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
        image: curlimages/curl:8.5.0
        command: ["sh", "-c", "while true; do sleep 3600; done"]
EOF

# Wait for deployments to be ready
kubectl rollout status deployment/api-server -n backend --timeout=90s &>/dev/null
kubectl rollout status deployment/frontend -n frontend --timeout=90s &>/dev/null

# Inject failure: apply a NetworkPolicy that blocks all ingress to backend namespace
# This is a plausible misconfiguration — it looks like a security hardening policy
kubectl apply -f - &>/dev/null <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-hardening
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

exit 0