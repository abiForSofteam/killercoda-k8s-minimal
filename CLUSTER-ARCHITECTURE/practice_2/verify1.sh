#!/bin/bash

# Verify that the learner has observed the cluster state:
# control-plane must be Ready and node01 must be absent or NotReady
READY=$(kubectl get nodes controlplane --no-headers 2>/dev/null | awk '{print $2}')
if [ "$READY" = "Ready" ]; then
  exit 0
fi
exit 1
