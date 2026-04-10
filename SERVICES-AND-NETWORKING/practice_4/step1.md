## Inventaire initial de la situation

Commencez par verifier l'etat general des ressources dans le namespace applicatif et l'etat des Pods systeme.

```bash
kubectl get pods -n commerce
kubectl get pods -n kube-system
```

Ces deux commandes donnent une premiere lecture de l'etat des Pods applicatifs et systeme. Notez en particulier le statut et le nombre de redemarrages de chaque Pod.

Verifiez ensuite si la resolution DNS fonctionne depuis le Pod frontend :

```bash
FRONTEND_POD=$(kubectl get pod -n commerce -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n commerce $FRONTEND_POD -- nslookup catalog.commerce.svc.cluster.local
```

Cette commande tente une resolution DNS du service `catalog` depuis l'interieur du cluster. Un echec ici confirme que le probleme est bien au niveau de la resolution de noms, et non au niveau du service lui-meme.
