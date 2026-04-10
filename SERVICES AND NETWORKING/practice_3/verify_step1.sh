#!/bin/bash

# Verify that both Services exist in the ecommerce namespace
kubectl get service catalog-svc -n ecommerce &>/dev/null || exit 1
kubectl get service frontend-svc -n ecommerce &>/dev/null || exit 1

# Verify that both Deployments are running
CATALOG_READY=$(kubectl get deployment catalog -n ecommerce -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
FRONTEND_READY=$(kubectl get deployment frontend -n ecommerce -o jsonpath='{.status.readyReplicas}' 2>/dev/null)

[ "$CATALOG_READY" -ge 1 ] 2>/dev/null || exit 1
[ "$FRONTEND_READY" -ge 1 ] 2>/dev/null || exit 1

exit 0
