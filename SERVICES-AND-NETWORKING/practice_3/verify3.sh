#!/bin/bash

# Verify that api-backend-svc has the correct selector and frontend-svc has the correct targetPort

# Check selector on api-backend-svc
SELECTOR=$(kubectl get service api-backend-svc -n ecommerce \
  -o jsonpath='{.spec.selector.app}' 2>/dev/null)

if [ "$SELECTOR" != "api-backend" ]; then
  echo "api-backend-svc selector incorrect: expected 'api-backend', got '$SELECTOR'"
  exit 1
fi

# Check that api-backend-svc has endpoints
ENDPOINTS=$(kubectl get endpoints api-backend-svc -n ecommerce \
  -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)

if [ -z "$ENDPOINTS" ]; then
  echo "api-backend-svc has no endpoints despite correct selector"
  exit 1
fi

# Check targetPort on frontend-svc
TARGET_PORT=$(kubectl get service frontend-svc -n ecommerce \
  -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)

if [ "$TARGET_PORT" != "8080" ]; then
  echo "frontend-svc targetPort incorrect: expected '8080', got '$TARGET_PORT'"
  exit 1
fi

echo "done"
exit 0
