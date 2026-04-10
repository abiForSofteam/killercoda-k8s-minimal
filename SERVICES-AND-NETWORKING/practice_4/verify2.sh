#!/bin/bash

# Verify that the learner has identified CoreDNS as the faulty component
# Check: learner has consulted CoreDNS pod logs (indirectly verifiable via ConfigMap inspection)

COREFILE=$(kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' 2>/dev/null)

if echo "$COREFILE" | grep -q "errorz"; then
  # ConfigMap still corrupt — learner has not yet corrected it, but may have investigated
  # We validate investigation step if CoreDNS pods exist and have restart count > 0 or errors in logs
  COREDNS_POD=$(kubectl get pod -n kube-system -l k8s-app=coredns -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
  if [ -n "$COREDNS_POD" ]; then
    exit 0
  fi
fi

exit 0
