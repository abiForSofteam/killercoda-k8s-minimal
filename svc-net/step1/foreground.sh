#!/bin/bash
# Vérifie que le namespace production et le pod webapp sont bien créés
echo "=== Vérification de l'étape 1 ==="

NAMESPACE=$(kubectl get namespace production --no-headers 2>/dev/null | awk '{print $1}')
if [ "$NAMESPACE" != "production" ]; then
  echo "❌ Le namespace 'production' n'existe pas encore. Créez-le avec :"
  echo "   kubectl create namespace production"
  exit 1
fi
echo "✅ Namespace 'production' trouvé."

POD_STATUS=$(kubectl get pod webapp -n production --no-headers 2>/dev/null | awk '{print $3}')
if [ "$POD_STATUS" != "Running" ]; then
  echo "❌ Le Pod 'webapp' n'est pas en état Running (état actuel : $POD_STATUS)."
  echo "   Vérifiez avec : kubectl get pods -n production"
  exit 1
fi
echo "✅ Pod 'webapp' en état Running."

SVC=$(kubectl get service api-backend -n production --no-headers 2>/dev/null | awk '{print $1}')
if [ "$SVC" != "api-backend" ]; then
  echo "❌ Le Service 'api-backend' n'existe pas dans le namespace production."
  echo "   Créez-le avec : kubectl create service clusterip api-backend --tcp=8080:8080 --namespace=production"
  exit 1
fi
echo "✅ Service 'api-backend' trouvé."

echo ""
echo "🎉 Infrastructure de test correctement déployée ! Passez à l'étape suivante."
