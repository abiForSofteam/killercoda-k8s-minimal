# Étape 5 — Résolution de la panne

Vous avez identifié la cause racine : une accolade fermante manquante dans la ConfigMap `coredns`. Il est temps de **restaurer une configuration valide**.

---

## 5.1 — Inspection de la ConfigMap corrompue

Vérifiez d'abord le contenu actuel du Corefile :

```bash
kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}'
```

Vous observez que le bloc `.:53 {` n'est **pas fermé** par l'accolade `}` finale.

---

## 5.2 — Restauration de la configuration valide

### Option A — Restaurer depuis la sauvegarde (recommandé)

```bash
kubectl apply -f coredns-backup.yaml
```

### Option B — Correction directe via patch

Appliquez le Corefile complet et syntaxiquement correct :

```bash
kubectl patch configmap coredns -n kube-system --type=merge -p '{
  "data": {
    "Corefile": ".:53 {\n    errors\n    health {\n        lameduck 5s\n    }\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n        pods insecure\n        fallthrough in-addr.arpa ip6.arpa\n        ttl 30\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf {\n        max_concurrent 1000\n    }\n    cache 30\n    loop\n    reload\n    loadbalance\n}\n"
  }
}'
```

> 💡 **Différence clé :** La configuration corrigée se termine par `}\n` — l'accolade fermante finale du bloc serveur est bien présente.

---

## 5.3 — Attendre le rechargement automatique

Le plugin `reload` détecte automatiquement les changements de ConfigMap. Attendez **10 à 30 secondes** :

```bash
sleep 30
```

---

## 5.4 — Vérifier le redémarrage des Pods CoreDNS

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns --watch
```

Vous devriez observer la progression suivante :

```
NAME                        READY   STATUS    RESTARTS   AGE
coredns-7d8f4c9b6d-abc12   0/1     Running   6          12m
coredns-7d8f4c9b6d-abc12   1/1     Running   6          12m
coredns-7d8f4c9b6d-def34   0/1     Running   6          12m
coredns-7d8f4c9b6d-def34   1/1     Running   6          12m
```

Appuyez sur `Ctrl+C` pour quitter le mode `--watch`.

> ✅ Les Pods passent à l'état `READY 1/1` — la configuration est désormais valide.

---

## 5.5 — Vérifier les Endpoints

```bash
kubectl get endpoints kube-dns -n kube-system
```

Résultat attendu :

```
NAME       ENDPOINTS                           AGE
kube-dns   10.244.0.2:53,10.244.0.3:53,...    45d
```

> ✅ Les Endpoints sont de nouveau peuplés avec les adresses IP des Pods CoreDNS opérationnels.

---

> ⚠️ **Erreur à ne pas commettre :** Ne jamais forcer le redémarrage des Pods CoreDNS **sans avoir d'abord corrigé la ConfigMap** :
> ```bash
> # ❌ Incorrect — les nouveaux Pods redémarreront avec la même config corrompue
> kubectl delete pod -n kube-system -l k8s-app=kube-dns
> ```
> Corrigez **toujours** la ConfigMap en premier, puis laissez le plugin `reload` gérer le rechargement.
