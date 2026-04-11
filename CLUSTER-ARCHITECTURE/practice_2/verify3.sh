#!/bin/bash

# Verify that node01 has joined the cluster and is Ready
STATUS=$(kubectl get node node01 --no-headers 2>/dev/null | awk '{print $2}')
if [ "$STATUS" = "Ready" ]; then
  exit 0
fi
exit 1
