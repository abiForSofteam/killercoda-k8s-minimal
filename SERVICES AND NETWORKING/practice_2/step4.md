## Vérification fonctionnelle

Retestez la communication depuis le pod frontend vers le service backend :

```bash
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend $FRONTEND_POD -- curl -s --max-time 5 http://api-server.backend.svc.cluster.local
```

Vérifiez également que la communication directe pod-à-pod fonctionne (modèle réseau de base) :

```bash
BACKEND_POD_IP=$(kubectl get pod -n backend -l app=api-server -o jsonpath='{.items[0].status.podIP}')
kubectl exec -n frontend $FRONTEND_POD -- curl -s --max-time 5 http://$BACKEND_POD_IP:5678
```

<div style="background-color: rgb(255, 245, 220); border-left: 4px solid rgb(210, 140, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(140, 90, 0);">✅ Critère de succès</strong><br/>
  Les deux commandes retournent <code>OK from api-server</code> sans timeout. La première valide le chemin DNS → ClusterIP → pod. La seconde confirme que le plan réseau CNI (pod-to-pod) est opérationnel et que la correction de la NetworkPolicy est bien en place.
</div>