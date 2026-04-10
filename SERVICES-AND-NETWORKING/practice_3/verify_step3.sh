#!/bin/bash

# Verify catalog-svc selector is corrected
CATALOG_SELECTOR=$(kubectl get service catalog-svc -n ecommerce -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$CATALOG_SELECTOR" = "catalog" ] || exit 1

# Verify catalog-svc has endpoints
CATALOG_EP=$(kubectl get endpoints catalog-svc -n ecommerce -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
[ -n "$CATALOG_EP" ] || exit 1

# Verify frontend-svc targetPort is corrected to 80
FRONTEND_TARGET=$(kubectl get service frontend-svc -n ecommerce -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
[ "$FRONTEND_TARGET" = "80" ] || exit 1

exit 0
