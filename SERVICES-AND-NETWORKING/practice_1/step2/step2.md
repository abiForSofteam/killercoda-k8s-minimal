# Étape 2 — Simulation de la panne DNS

Vous allez maintenant **introduire volontairement une erreur de syntaxe** dans la ConfigMap `coredns` du namespace `kube-system`.

Cette opération simule ce qui se passe lors d'une mauvaise manipulation en production : une accolade fermante manquante dans le Corefile empêche CoreDNS de démarrer correctement.

## Votre mission

### 1. Sauvegarder la configuration actuelle

Avant toute modification, créez toujours une sauvegarde :

```bash
kubectl get configmap coredns -n kube-system -o yaml > coredns-backup.yaml
```

> ⚠️ **Bonne pratique :** Ne jamais modifier une ConfigMap critique sans sauvegarde préalable.

### 2. Injecter l'erreur de syntaxe

Appliquez le patch suivant qui **supprime l'accolade fermante finale** du bloc serveur :

```bash
kubectl patch configmap coredns -n kube-system --type=merge -p '{
  "data": {
    "Corefile": ".:53 {\n    errors\n    health {\n        lameduck 5s\n    }\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n        pods insecure\n        fallthrough in-addr.arpa ip6.arpa\n        ttl 30\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf {\n        max_concurrent 1000\n    }\n    cache 30\n    loop\n    reload\n    loadbalance\n    "
  }
}'
```

> 💡 **Explication :** La configuration ci-dessus est identique à une configuration valide, mais l'accolade fermante `}` finale du bloc serveur `.:53 { ... }` est absente. CoreDNS ne peut pas parser ce Corefile.

### 3. Attendre la détection par le plugin reload

Le plugin `reload` de CoreDNS surveille les changements de ConfigMap. Attendez **30 secondes** pour qu'il détecte la modification et tente de recharger la configuration :

```bash
sleep 30
```

### 4. Observer la dégradation

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

Vous devriez voir les Pods CoreDNS passer en état `CrashLoopBackOff` :

```
NAME                        READY   STATUS             RESTARTS   AGE
coredns-7d8f4c9b6d-abc12   0/1     CrashLoopBackOff   2          5m
coredns-7d8f4c9b6d-def34   0/1     CrashLoopBackOff   2          5m
```
