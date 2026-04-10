#!/bin/bash

# Wait for cluster to be ready
until kubectl get nodes &>/dev/null; do sleep 5; done
sleep 10

# Create namespace
kubectl get namespace ecommerce &>/dev/null || kubectl create namespace ecommerce &>/dev/null

# Deploy backend API application
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-backend
  namespace: ecommerce
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-backend
  template:
    metadata:
      labels:
        app: api-backend
    spec:
      containers:
      - name: api
        image: hashicorp/http-echo:0.2.3
        args:
        - "-text=api-backend-response"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
EOF

# Deploy frontend application
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: ecommerce
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
        image: hashicorp/http-echo:0.2.3
        args:
        - "-text=frontend-response"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
EOF

# Create a ClusterIP Service for the backend with WRONG selector (fault injection)
# The selector targets 'api' instead of 'api-backend' — pods will never match
kubectl apply -f - &>/dev/null <<EOF
apiVersion: v1
kind: Service
metadata:
  name: api-backend-svc
  namespace: ecommerce
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 8080
EOF

# Create a NodePort Service for the frontend with WRONG port mapping (fault injection)
# The targetPort does not match the container port — traffic will be rejected
kubectl apply -f - &>/dev/null <<EOF
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: ecommerce
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 9090
    nodePort: 30080
EOF

# Wait for deployments to be available
kubectl rollout status deployment/api-backend -n ecommerce --timeout=120s &>/dev/null
kubectl rollout status deployment/frontend -n ecommerce --timeout=120s &>/dev/null

exit 0
