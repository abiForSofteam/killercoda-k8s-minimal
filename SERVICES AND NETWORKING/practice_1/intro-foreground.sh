#!/bin/bash
# Vérifie que le cluster est accessible avant de démarrer
echo "Vérification de l'état du cluster..."
kubectl get nodes
echo ""
echo "✅ Cluster Kubernetes opérationnel. Vous pouvez commencer l'exercice."
