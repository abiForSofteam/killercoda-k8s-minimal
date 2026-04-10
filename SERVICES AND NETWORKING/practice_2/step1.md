## Inventaire initial de la situation

Commencez par observer l'état général du cluster et des ressources impliquées.

**1. État des pods dans les deux namespaces concernés :**

```bash
kubectl get pods -n frontend
kubectl get pods -n backend
```

Les pods doivent afficher `Running`. Si ce n'est pas le cas, le problème est applicatif, pas réseau.

**2. État du Service et de ses Endpoints dans le namespace `backend` :**

```bash
kubectl get service api-server -n backend
kubectl get endpoints api-server -n backend
```

Un Service sans Endpoints signifie que son sélecteur ne correspond à aucun pod — ce serait une piste différente. Ici, l'Endpoint doit être présent.

**3. Tentative de communication depuis le pod frontend :**

```bash
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend $FRONTEND_POD -- curl -s --max-time 5 http://api-server.backend.svc.cluster.local
```

Cette commande teste le chemin complet : résolution DNS du nom de service cross-namespace, routage via le ClusterIP, puis transmission au pod backend. Notez le résultat — timeout ou refus de connexion.