# Étape 4 — Diagnostic systématique

Le diagnostic doit suivre une approche **méthodique et ordonnée** : de la couche applicative vers la couche infrastructure.

---

## 4.1 — État des Pods CoreDNS

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

Résultat observé :

```
NAME                        READY   STATUS             RESTARTS     AGE
coredns-7d8f4c9b6d-abc12   0/1     CrashLoopBackOff   5 (2m ago)   10m
coredns-7d8f4c9b6d-def34   0/1     CrashLoopBackOff   5 (2m ago)   10m
```

> ⚠️ L'état `CrashLoopBackOff` indique que les Pods **crashent en boucle** au démarrage. Kubernetes les redémarre automatiquement, mais ils échouent à chaque tentative.

---

## 4.2 — Analyse des logs CoreDNS

Récupérez les logs d'un des Pods CoreDNS pour identifier l'erreur :

```bash
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=20
```

Ou en ciblant un Pod spécifique (remplacez le nom par celui obtenu à l'étape précédente) :

```bash
kubectl logs -n kube-system coredns-7d8f4c9b6d-abc12
```

Résultat observé :

```
.:53
plugin/reload: Running configuration SHA512 = ...
Corefile:2: Parse error: unexpected end of file, expecting '}'
```

> 🎯 **Cause racine identifiée :** Le log confirme une **erreur de parsing** à la ligne 2 du Corefile — une accolade fermante `}` est manquante. CoreDNS ne peut pas démarrer avec un Corefile invalide.

---

## 4.3 — Vérification des Endpoints du Service kube-dns

```bash
kubectl get endpoints kube-dns -n kube-system
```

Résultat observé :

```
NAME       ENDPOINTS   AGE
kube-dns   <none>      45d
```

> ⚠️ Les Endpoints sont **vides** car les Pods CoreDNS ne sont pas opérationnels. Le Service `kube-dns` existe mais ne peut router aucune requête DNS.

---

## 4.4 — Test de connectivité réseau vers le Service kube-dns

Depuis le Pod `webapp`, testez la connectivité réseau vers l'IP du Service `kube-dns` sur le port `53` :

```bash
kubectl exec -n production webapp -- nc -zv 10.96.0.10 53
```

Résultat observé :

```
10.96.0.10 (10.96.0.10:53) open
```

> ✅ **La connectivité réseau est établie** sur le port 53 — le problème n'est pas lié au réseau ou à des règles `NetworkPolicy`. Le Service `kube-dns` est joignable, mais ses Pods backend sont défaillants.

---

## Synthèse du diagnostic

| Composant | État | Cause |
|---|---|---|
| Pod `webapp` | ✅ Running | — |
| Service `kube-dns` | ✅ Existant | — |
| Endpoints `kube-dns` | ❌ Vides | Pods CoreDNS en CrashLoopBackOff |
| Pods CoreDNS | ❌ CrashLoopBackOff | Erreur de syntaxe dans le Corefile |
| Connectivité port 53 | ✅ Ouverte | — |
| Résolution DNS | ❌ Échec | Pods CoreDNS indisponibles |

**Conclusion :** L'accolade fermante manquante dans la ConfigMap `coredns` empêche CoreDNS de démarrer. La correction doit s'effectuer au niveau de la ConfigMap.
