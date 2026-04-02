#!/bin/bash
# Vérification étape 2 : l'apprenant a consulté les logs (on vérifie que le Pod a crashé avec l'erreur mime.types)

LOGS=$(kubectl logs nginx-subpath -n exo2-subpath --previous 2>/dev/null || \
       kubectl logs nginx-subpath -n exo2-subpath 2>/dev/null)

if echo "$LOGS" | grep -q "mime.types"; then
  echo "✅ Parfait ! Vous avez trouvé l'erreur : nginx ne trouve pas mime.types dans /etc/nginx/."
  exit 0
else
  # Vérification alternative : le Pod a eu des restarts (preuve que les logs ont été consultables)
  RESTARTS=$(kubectl get pod nginx-subpath -n exo2-subpath \
    -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)
  if [[ "$RESTARTS" -gt 0 ]]; then
    echo "✅ Le Pod a crashé plusieurs fois. Vous pouvez passer à l'étape suivante."
    exit 0
  fi
  echo "⏳ Consultez les logs du Pod avec kubectl logs nginx-subpath -n exo2-subpath --previous"
  exit 1
fi
