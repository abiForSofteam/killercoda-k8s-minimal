#!/bin/bash
# Vérification étape 1 : le Pod existe et est en CrashLoopBackOff ou a eu des restarts

STATUS=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' 2>/dev/null)

RESTARTS=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)

if [[ "$STATUS" == "CrashLoopBackOff" ]] || [[ "$RESTARTS" -gt 0 ]]; then
  echo "✅ Bien observé ! Le Pod est en CrashLoopBackOff avec $RESTARTS redémarrage(s)."
  exit 0
else
  echo "⏳ Le Pod n'est pas encore en CrashLoopBackOff. Attendez quelques secondes et relancez."
  exit 1
fi
