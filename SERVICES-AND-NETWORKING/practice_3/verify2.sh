#!/bin/bash

# Verify that the learner has investigated both services
# Step 2 is an investigation step — pass as long as both services still exist (no accidental deletion)

SVC1=$(kubectl get service api-backend-svc -n ecommerce --no-headers 2>/dev/null | wc -l)
SVC2=$(kubectl get service frontend-svc -n ecommerce --no-headers 2>/dev/null | wc -l)

if [ "$SVC1" -ge 1 ] && [ "$SVC2" -ge 1 ]; then
  echo "done"
  exit 0
fi

exit 1
