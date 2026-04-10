#!/bin/bash

# Verify that the CoreDNS ConfigMap has been corrected (no more 'errorz' directive)

COREFILE=$(kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' 2>/dev/null)

if echo "$COREFILE" | grep -q "errorz"; then
  echo "Le ConfigMap CoreDNS contient encore la directive invalide 'errorz'. Corrigez-la en 'errors'."
  exit 1
fi

if ! echo "$COREFILE" | grep -q "errors"; then
  echo "Le plugin 'errors' est absent du Corefile. Verifiez la configuration CoreDNS."
  exit 1
fi

# Verify CoreDNS pods are running after correction
READY=$(kubectl get deployment coredns -n kube-system -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -z "$READY" ] || [ "$READY" -lt 1 ]; then
  echo "Les Pods CoreDNS ne sont pas encore prets. Attendez la fin du rollout."
  exit 1
fi

exit 0
