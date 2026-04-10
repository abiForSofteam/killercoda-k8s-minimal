#!/bin/bash

# Verify functional connectivity through both services

# Test 1: ClusterIP internal access via DNS
BACKEND_RESPONSE=$(kubectl run verify-client --image=busybox:1.36 \
  --restart=Never --rm -q \
  -n ecommerce \
  -- wget -qO- --timeout=5 http://api-backend-svc.ecommerce.svc.cluster.local 2>/dev/null)

if echo "$BACKEND_RESPONSE" | grep -q "api-backend-response"; then
  BACKEND_OK=true
else
  BACKEND_OK=false
fi

# Test 2: NodePort external access
NODE_IP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null)
FRONTEND_RESPONSE=$(curl -s --connect-timeout 5 http://${NODE_IP}:30080 2>/dev/null)

if echo "$FRONTEND_RESPONSE" | grep -q "frontend-response"; then
  FRONTEND_OK=true
else
  FRONTEND_OK=false
fi

if $BACKEND_OK && $FRONTEND_OK; then
  echo "done"
  exit 0
fi

if ! $BACKEND_OK; then
  echo "Backend ClusterIP service unreachable via DNS"
fi

if ! $FRONTEND_OK; then
  echo "Frontend NodePort service unreachable on port 30080"
fi

exit 1
