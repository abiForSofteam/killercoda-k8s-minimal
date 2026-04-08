#!/bin/bash
# Vérifie que la ConfigMap a bien été modifiée (syntaxe corrompue injectée)
echo "=== Vérification de l'étape 2 ==="

COREFILE=$(kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' 2>/dev/null)

# Vérifie que la sauvegarde existe
if [ ! -f "coredns-backup.yaml" ]; then
  echo "⚠️  Fichier coredns-backup.yaml non trouvé dans le répertoire courant."
  echo "   Il est fortement recommandé de sauvegarder avant toute modification :"
  echo "   kubectl get configmap coredns -n kube-system -o yaml > coredns-backup.yaml"
fi

# Vérifie que la ConfigMap a bien la syntaxe corrompue (accolade finale absente)
BRACE_COUNT_OPEN=$(echo "$COREFILE" | grep -o '{' | wc -l)
BRACE_COUNT_CLOSE=$(echo "$COREFILE" | grep -o '}' | wc -l)

if [ "$BRACE_COUNT_OPEN" -le "$BRACE_COUNT_CLOSE" ]; then
  echo "❌ La ConfigMap ne semble pas avoir d'erreur de syntaxe (accolades équilibrées)."
  echo "   Appliquez le patch de simulation de panne décrit dans l'étape 2."
  exit 1
fi

echo "✅ Erreur de syntaxe correctement injectée dans la ConfigMap coredns."
echo ""
echo "Vérification de l'état des Pods CoreDNS..."
kubectl get pods -n kube-system -l k8s-app=kube-dns
echo ""
echo "🎉 Panne simulée avec succès ! Passez à l'étape de validation."
