#!/bin/bash
# Vérifie que la ConfigMap est corrigée et que les Pods CoreDNS sont opérationnels
echo "=== Vérification de l'étape 5 ==="

# 1. Vérifier la syntaxe du Corefile (accolades équilibrées)
COREFILE=$(kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' 2>/dev/null)
BRACE_OPEN=$(echo "$COREFILE" | grep -o '{' | wc -l)
BRACE_CLOSE=$(echo "$COREFILE" | grep -o '}' | wc -l)

if [ "$BRACE_OPEN" -ne "$BRACE_CLOSE" ]; then
  echo "❌ Le Corefile contient encore une erreur de syntaxe (accolades déséquilibrées : $BRACE_OPEN ouvrantes / $BRACE_CLOSE fermantes)."
  echo "   Restaurez la configuration valide avec : kubectl apply -f coredns-backup.yaml"
  exit 1
fi
echo "✅ Corefile syntaxiquement valide (accolades équilibrées)."

# 2. Vérifier que les Pods CoreDNS sont Ready
echo ""
echo "Vérification de l'état des Pods CoreDNS..."
NOT_READY=$(kubectl get pods -n kube-system -l k8s-app=kube-dns --no-headers 2>/dev/null | grep -v "1/1" | wc -l)

if [ "$NOT_READY" -gt 0 ]; then
  echo "⚠️  Certains Pods CoreDNS ne sont pas encore READY. Attendez quelques secondes et relancez."
  kubectl get pods -n kube-system -l k8s-app=kube-dns
  exit 1
fi
echo "✅ Tous les Pods CoreDNS sont en état READY 1/1."

# 3. Vérifier les Endpoints
echo ""
ENDPOINTS=$(kubectl get endpoints kube-dns -n kube-system -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)
if [ -z "$ENDPOINTS" ]; then
  echo "⚠️  Les Endpoints kube-dns sont encore vides. Attendez 10-30 secondes."
  exit 1
fi
echo "✅ Endpoints kube-dns peuplés : $ENDPOINTS"

echo ""
echo "🎉 Panne résolue avec succès ! Passez à la vérification post-correction."
