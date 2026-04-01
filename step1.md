# Déployer un Pod Nginx

Dans ce scénario, vous allez créer votre premier Pod Kubernetes.

## Objectif

Créer un Pod avec l'image nginx.

## Instructions

1. Créez un Pod nommé `nginx-pod`
2. Utilisez l'image `nginx`
3. Vérifiez qu'il est en état `Running`

## Commandes utiles

```bash
kubectl run nginx-pod --image=nginx
kubectl get pods
