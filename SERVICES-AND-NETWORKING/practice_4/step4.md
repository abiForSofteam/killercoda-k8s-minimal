## Verification fonctionnelle

Verifiez que la resolution DNS est retablie depuis le Pod frontend vers le service catalog :

```bash
FRONTEND_POD=$(kubectl get pod -n commerce -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n commerce $FRONTEND_POD -- nslookup catalog.commerce.svc.cluster.local
```

Verifiez egalement la resolution de noms externes pour confirmer que CoreDNS fonctionne dans sa globalite :

```bash
kubectl exec -n commerce $FRONTEND_POD -- nslookup kubernetes.default.svc.cluster.local
```

<div style="background-color: rgb(255, 245, 220); border-left: 4px solid rgb(210, 140, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(140, 90, 0);">Critere de succes</strong><br/>
  La commande <code>nslookup catalog.commerce.svc.cluster.local</code> retourne une adresse IP de type <code>10.x.x.x</code> (ClusterIP du service catalog) sans message d'erreur. La commande <code>nslookup kubernetes.default.svc.cluster.local</code> retourne egalement une adresse IP valide. Les Pods CoreDNS sont en statut <code>Running</code> sans redemarrages recents.
</div>
