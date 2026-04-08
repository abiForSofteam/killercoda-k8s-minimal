# 🎉 Félicitations — Exercice terminé !

Vous avez réussi à diagnostiquer et corriger une panne DNS critique dans un cluster Kubernetes.

---

## Récapitulatif de l'exercice

| Étape | Action | Résultat |
|---|---|---|
| 1 | Déploiement de l'infra de test | Namespace `production`, Pod `webapp`, Service `api-backend` |
| 2 | Simulation de la panne | Injection d'une erreur de syntaxe dans la ConfigMap CoreDNS |
| 3 | Validation de la panne | Confirmation des échecs `nslookup` depuis `webapp` |
| 4 | Diagnostic systématique | Identification du `CrashLoopBackOff` et de l'erreur de parsing |
| 5 | Résolution | Restauration du Corefile valide via `kubectl patch` ou `kubectl apply` |
| 6 | Vérification post-correction | DNS interne, externe, métriques Prometheus — tout opérationnel |

---

## Compétences acquises

- **Lecture des logs CoreDNS** pour identifier des erreurs de parsing Corefile
- **Analyse des Endpoints** pour détecter l'indisponibilité des Pods backend
- **Test de connectivité réseau** distinguant les problèmes réseau des problèmes applicatifs
- **Correction de ConfigMap** sans redémarrage manuel des Pods (plugin `reload`)
- **Vérification multicouche** : résolution interne, externe, métriques

---

## Erreurs fréquentes à éviter

### ❌ Erreur 1 — Oublier de sauvegarder la ConfigMap avant modification
**Conséquence :** Impossibilité de restaurer rapidement la configuration fonctionnelle.
**Bonne pratique :** Toujours créer une sauvegarde **avant** toute modification :
```bash
kubectl get configmap coredns -n kube-system -o yaml > coredns-backup.yaml
```

### ❌ Erreur 2 — Modifier le Deployment CoreDNS au lieu de la ConfigMap
**Conséquence :** Les modifications ne sont pas persistées car le Deployment monte la ConfigMap en volume. La correction doit **toujours** s'effectuer au niveau de la ConfigMap.

### ❌ Erreur 3 — Forcer le redémarrage des Pods sans corriger la ConfigMap
```bash
# Ne jamais faire ceci avant la correction
kubectl delete pod -n kube-system -l k8s-app=kube-dns
```
**Conséquence :** Les nouveaux Pods redémarrent avec la même configuration corrompue. Corriger d'abord la ConfigMap, puis laisser le plugin `reload` gérer le rechargement automatique.

### ❌ Erreur 4 — Tester la résolution DNS avant que les Endpoints soient peuplés
**Conséquence :** Échecs de résolution persistants malgré la correction. Attendre 10-30 secondes après la correction et vérifier :
```bash
kubectl get endpoints kube-dns -n kube-system
```

### ❌ Erreur 5 — Ne pas vérifier les logs après correction
Même si les Pods passent à l'état `Running`, des avertissements dans les logs peuvent indiquer des problèmes non bloquants. Toujours examiner :
```bash
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50
```

### ❌ Erreur 6 — Confondre le port health (8080) avec le port DNS (53)
```bash
# Ceci valide uniquement le health endpoint HTTP, pas le DNS
nc -zv 10.96.0.10 8080

# Toujours tester le port 53 pour valider la disponibilité DNS
nc -zv 10.96.0.10 53
```

---

## Pour aller plus loin

- [Documentation officielle CoreDNS](https://coredns.io/manual/toc/)
- [CoreDNS dans Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)
- [Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)

---

*KubeSuccess — Formation Kubernetes | Niveau CKA | © 2026*
