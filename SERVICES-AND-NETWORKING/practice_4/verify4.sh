#!/bin/bash

# Verify that DNS resolution works from the frontend pod to the catalog service

FRONTEND_POD=$(kubectl get pod -n commerce -l app=frontend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$FRONTEND_POD" ]; then
  echo "Pod frontend introuvable dans le namespace commerce."
  exit 1
fi

# Test DNS resolution for catalog service
RESULT=$(kubectl exec -n commerce "$FRONTEND_POD" -- nslookup catalog.commerce.svc.cluster.local 2>&1)

if echo "$RESULT" | grep -q "Address" && ! echo "$RESULT" | grep -q "SERVFAIL\|NXDOMAIN\|connection timed out\|can't resolve"; then
  exit 0
else
  echo "La resolution DNS de catalog.commerce.svc.cluster.local echoue encore. Verifiez l'etat de CoreDNS."
  echo "Output: $RESULT"
  exit 1
fi
