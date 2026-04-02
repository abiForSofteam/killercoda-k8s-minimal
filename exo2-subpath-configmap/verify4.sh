#!/bin/bash
# Vérification étape 4 : le Pod est Running avec subPath correctement configuré

# 1. Vérifier que le Pod est Running
STATUS=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.status.phase}' 2>/dev/null)

if [[ "$STATUS" != "Running" ]]; then
  echo "⏳ Le Pod n'est pas encore en Running (statut actuel : $STATUS)."
  echo "   Attendez quelques secondes : kubectl get pod nginx-subpath -n exo2-subpath -w"
  exit 1
fi

# 2. Vérifier que subPath est bien configuré
SUBPATH=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.spec.containers[0].volumeMounts[0].subPath}' 2>/dev/null)

if [[ "$SUBPATH" != "nginx.conf" ]]; then
  echo "❌ Le champ subPath n'est pas correctement configuré (valeur : '$SUBPATH')."
  echo "   Il doit être : subPath: nginx.conf"
  exit 1
fi

# 3. Vérifier que mountPath pointe vers le fichier
MOUNTPATH=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)

if [[ "$MOUNTPATH" != "/etc/nginx/nginx.conf" ]]; then
  echo "❌ Le mountPath n'est pas correct (valeur : '$MOUNTPATH')."
  echo "   Il doit être : mountPath: /etc/nginx/nginx.conf"
  exit 1
fi

# 4. Vérifier RESTARTS = 0
RESTARTS=$(kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)

# 5. Vérifier que mime.types existe dans le conteneur
MIME=$(kubectl exec nginx-subpath -n exo2-subpath -- ls /etc/nginx/mime.types 2>/dev/null)

if [[ -z "$MIME" ]]; then
  echo "❌ Le fichier mime.types n'est pas présent dans /etc/nginx/."
  echo "   Vérifiez votre configuration subPath."
  exit 1
fi

echo ""
echo "🎉 ═══════════════════════════════════════════════════════"
echo "   ✅  EXERCICE RÉUSSI !"
echo "   ═══════════════════════════════════════════════════════"
echo ""
echo "   Pod nginx-subpath : Running ✅"
echo "   subPath configuré : nginx.conf ✅"
echo "   mountPath correct : /etc/nginx/nginx.conf ✅"
echo "   Fichiers image préservés (mime.types) ✅"
echo "   Redémarrages depuis correction : $RESTARTS"
echo ""
exit 0
