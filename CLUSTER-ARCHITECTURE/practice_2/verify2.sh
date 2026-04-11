#!/bin/bash

# Verify that at least one valid (non-expired) bootstrap token exists
TOKEN_COUNT=$(kubeadm token list 2>/dev/null | grep -v "^TOKEN" | grep -v "^$" | wc -l)
if [ "$TOKEN_COUNT" -gt 0 ]; then
  exit 0
fi
exit 1
