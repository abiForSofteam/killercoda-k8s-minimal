#!/bin/bash
# Foreground - affiché à l'apprenant pendant le setup

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           Préparation de votre environnement...              ║"
echo "║                                                              ║"
echo "║   • Démarrage du cluster Kubernetes                          ║"
echo "║   • Création du namespace exo2-subpath                       ║"
echo "║   • Déploiement du Pod défectueux nginx-subpath              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Attendre que le Pod soit visible (même en erreur)
echo "⏳ Attente du déploiement du Pod..."
sleep 20

while ! kubectl get pod nginx-subpath -n exo2-subpath &>/dev/null; do
  echo "   ... toujours en cours ..."
  sleep 5
done

echo ""
echo "✅ Environnement prêt ! Vous pouvez commencer l'exercice."
echo ""
