# Étape 6 — Vérification post-correction

La panne est résolue. Vous devez maintenant effectuer une **validation complète** pour confirmer que tous les services DNS fonctionnent normalement.

---

## 6.1 — Résolution DNS des Services internes

Testez la résolution du Service `api-backend` depuis le Pod `webapp` :

```bash
kubectl exec -n production webapp -- nslookup api-backend.production.svc.cluster.local
```

Résultat attendu :

```
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      api-backend.production.svc.cluster.local
Address 1: 10.96.150.200 api-backend.production.svc.cluster.local
```

Testez également la résolution du Service standard Kubernetes :

```bash
kubectl exec -n production webapp -- nslookup kubernetes.default
```

Résultat attendu :

```
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes.default
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
```

> ✅ Les deux résolutions DNS internes fonctionnent correctement.

---

## 6.2 — Résolution DNS externe

Vérifiez que la résolution des domaines externes (forward DNS) est également opérationnelle :

```bash
kubectl exec -n production webapp -- nslookup google.com
```

Résultat attendu :

```
Server:    10.96.0.10
Address:   10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      google.com
Address 1: 142.250.185.46
Address 2: 2a00:1450:4007:80f::200e
```

> ✅ Le plugin `forward` de CoreDNS transmet correctement les requêtes vers `/etc/resolv.conf`.

---

## 6.3 — Vérification des métriques Prometheus

CoreDNS expose des métriques sur le port `9153` via le plugin `prometheus`. Vérifiez leur accessibilité :

```bash
kubectl port-forward -n kube-system svc/kube-dns 9153:9153 &
sleep 2
curl -s http://localhost:9153/metrics | grep coredns_dns_requests_total | head -n 3
kill %1
```

Résultat attendu :

```
# HELP coredns_dns_requests_total Counter of DNS requests made per zone, protocol and family.
# TYPE coredns_dns_requests_total counter
coredns_dns_requests_total{family="1",proto="udp",server="dns://:53",zone="."} 145
```

> ✅ Les métriques CoreDNS sont de nouveau accessibles, confirmant le bon fonctionnement du plugin `prometheus`.

---

## 6.4 — Nettoyage des ressources de test

Une fois la validation terminée, supprimez les ressources créées pour cet exercice :

```bash
kubectl delete pod webapp -n production
kubectl delete service api-backend -n production
kubectl delete namespace production
```

Vérifiez la suppression :

```bash
kubectl get namespace production
```

```
Error from server (NotFound): namespaces "production" not found
```

Supprimez le fichier de sauvegarde :

```bash
rm -f coredns-backup.yaml
```

> ✅ La ConfigMap CoreDNS est restaurée dans son état fonctionnel. Les Pods CoreDNS continuent de fonctionner normalement pour l'ensemble du cluster.
