# Étape 3 — Validation de la panne

Maintenant que la panne a été simulée, vous allez **confirmer** que la résolution DNS est bien défaillante depuis le Pod applicatif.

## Votre mission

Exécutez les commandes suivantes depuis le Pod `webapp` et observez les échecs de résolution.

### 1. Tenter de résoudre le Service interne api-backend

```bash
kubectl exec -n production webapp -- nslookup api-backend.production.svc.cluster.local
```

Résultat attendu (échec) :

```
Server:    10.96.0.10
Address 1: 10.96.0.10

nslookup: can't resolve 'api-backend.production.svc.cluster.local': Try again
command terminated with exit code 1
```

### 2. Tenter de résoudre le Service kubernetes.default

```bash
kubectl exec -n production webapp -- nslookup kubernetes.default
```

Résultat attendu (échec) :

```
Server:    10.96.0.10
Address:   10.96.0.10

nslookup: can't resolve 'kubernetes.default': Try again
command terminated with exit code 1
```

## Analyse

> 🔍 **Observations clés :**
>
> - Le Pod `webapp` **connaît bien l'adresse IP** du Service `kube-dns` (`10.96.0.10`) — la configuration réseau du Pod est correcte.
> - Cependant, `kube-dns` **ne répond pas** aux requêtes DNS — les Pods CoreDNS backend sont en `CrashLoopBackOff`.
> - **Les deux types de résolution échouent** : services internes ET services standard Kubernetes.
>
> La chaîne de résolution DNS dans Kubernetes est :
> ```
> Pod applicatif → Service kube-dns (10.96.0.10:53) → Pods CoreDNS → API Server
> ```
> Une défaillance CoreDNS bloque toute la chaîne.

Passez maintenant à l'étape de **diagnostic systématique** pour identifier précisément la cause racine.
