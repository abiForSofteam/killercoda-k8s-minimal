#!/bin/bash
# Vérification étape 3 : l'apprenant a inspecté les volumeMounts et identifié l'absence de subPath

SUBPATH=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.spec.containers[0].volumeMounts[0].subPath}' 2>/dev/null)

MOUNTPATH=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)

# Le Pod défectueux monte sur /etc/nginx/ sans subPath
if [[ -z "$SUBPATH" ]] && [[ "$MOUNTPATH" == "/etc/nginx/" ]]; then
  echo "✅ Diagnostic correct ! Le volumeMount monte sur /etc/nginx/ sans subPath."
  echo "   C'est bien la cause du crash. Passez à l'étape 4 pour corriger."
  exit 0
elif [[ -n "$SUBPATH" ]]; then
  # L'apprenant a déjà corrigé, on valide quand même
  echo "✅ Vous avez déjà appliqué la correction. Bien joué !"
  exit 0
else
  echo "⏳ Inspectez la configuration du Pod :"
  echo "   kubectl get pod nginx-subpath -n exo2-subpath -o yaml"
  exit 1
fi
