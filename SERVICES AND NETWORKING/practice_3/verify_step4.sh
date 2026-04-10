#!/bin/bash

# Verify catalog-svc endpoints are populated
CATALOG_EP=$(kubectl get endpoints catalog-svc -n ecommerce -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
[ -n "$CATALOG_EP" ] || exit 1

# Verify frontend-svc endpoints are populated
FRONTEND_EP=$(kubectl get endpoints frontend-svc -n ecommerce -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
[ -n "$FRONTEND_EP" ] || exit 1

# Verify catalog-svc selector matches
CATALOG_SELECTOR=$(kubectl get service catalog-svc -n ecommerce -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$CATALOG_SELECTOR" = "catalog" ] || exit 1

# Verify frontend-svc targetPort is 80
FRONTEND_TARGET=$(kubectl get service frontend-svc -n ecommerce -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
[ "$FRONTEND_TARGET" = "80" ] || exit 1

# Functional check: curl frontend NodePort from within the cluster
NODE_IP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null)
curl -s --max-time 5 "http://${NODE_IP}:30080" | grep -qi "html" || exit 1

exit 0
