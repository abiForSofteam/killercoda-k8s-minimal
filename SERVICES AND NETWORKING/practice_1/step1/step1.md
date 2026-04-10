# Étape 1 — Déploiement de l'infrastructure de test

Avant de simuler la panne, vous devez mettre en place l'infrastructure de test qui permettra de reproduire le scénario réel.

## Votre mission

Créez les ressources suivantes dans le namespace **production** :

1. Un **namespace** `production`
2. Un **Pod** nommé `webapp` utilisant l'image `busybox:1.28` avec la commande `sleep 3600`
3. Un **Service** nommé `api-backend` de type `ClusterIP` sur le port `8080`

## Commandes à exécuter

### 1. Créer le namespace production

```bash
kubectl create namespace production
```

### 2. Déployer le Pod webapp

```bash
kubectl run webapp \
  --image=busybox:1.28 \
  --namespace=production \
  --command -- sleep 3600
```

### 3. Créer le Service api-backend

```bash
kubectl create service clusterip api-backend \
  --tcp=8080:8080 \
  --namespace=production
```

```bash
kubectl label service api-backend app=backend --namespace=production
```

## Vérification

Assurez-vous que les ressources sont bien démarrées :

```bash
kubectl get pods -n production
```

```bash
kubectl get service api-backend -n production
```

Vous devriez obtenir :

```
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          10s
```

```
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
api-backend   ClusterIP   10.96.150.200   <none>        8080/TCP   15s
```

> 💡 **Note :** Le Service `api-backend` n'a pas de Pods cibles pour le moment — c'est volontaire. Il sert uniquement à tester la résolution DNS.
