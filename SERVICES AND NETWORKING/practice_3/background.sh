#!/bin/bash

# Wait for cluster to be ready
until kubectl get nodes &>/dev/null; do sleep 5; done
sleep 10

# Create namespace
kubectl get namespace ecommerce &>/dev/null || kubectl create namespace ecommerce &>/dev/null

# Deploy the catalog application
kubectl apply -f - &>/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog
  namespace: ecommerce
spec:
  replicas: 2
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
EOF

# Deploy the frontend application
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
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF

# Create internal ClusterIP Service for catalog — label selector is intentionally wrong (bug: app: catalogue instead of app: catalog)
kubectl apply -f - &>/dev/null <<EOF
apiVersion: v1
kind: Service
metadata:
  name: catalog-svc
  namespace: ecommerce
spec:
  type: ClusterIP
  selector:
    app: catalogue
  ports:
  - port: 80
    targetPort: 80
EOF

# Create NodePort Service for frontend — port is intentionally wrong (targetPort: 8080 instead of 80)
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
    targetPort: 8080
    nodePort: 30080
EOF

# Wait for deployments to be ready
kubectl rollout status deployment/catalog -n ecommerce &>/dev/null
kubectl rollout status deployment/frontend -n ecommerce &>/dev/null

exit 0
