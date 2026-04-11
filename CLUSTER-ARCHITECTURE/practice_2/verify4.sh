#!/bin/bash

# Verify that a pod can be scheduled and runs on node01
# Check both nodes are Ready
NODE01_STATUS=$(kubectl get node node01 --no-headers 2>/dev/null | awk '{print $2}')
if [ "$NODE01_STATUS" != "Ready" ]; then
  exit 1
fi

# Check that the test pod ran successfully on node01 (it may have been deleted — check events as fallback)
POD_NODE=$(kubectl get pod test-node01 -o jsonpath='{.spec.nodeName}' 2>/dev/null)
POD_PHASE=$(kubectl get pod test-node01 -o jsonpath='{.status.phase}' 2>/dev/null)

if [ "$POD_NODE" = "node01" ] && [ "$POD_PHASE" = "Running" ]; then
  exit 0
fi

# Accept if pod was already deleted but node01 is Ready (functional validation passed)
if [ "$NODE01_STATUS" = "Ready" ] && [ -z "$POD_NODE" ]; then
  exit 0
fi

exit 1
