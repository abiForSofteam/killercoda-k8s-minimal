## Inventaire de la situation

Commencez par dresser un état des lieux complet du namespace `ecommerce` avant toute intervention.

**Lister toutes les ressources actives dans le namespace :**

```bash
kubectl get all -n ecommerce
```

Cette commande expose en une seule passe les Deployments, ReplicaSets, Pods et Services présents. Observez les colonnes `READY` des Pods et `ENDPOINTS` des Services.

**Inspecter les endpoints associés à chaque Service :**

```bash
kubectl get endpoints -n ecommerce
```

Un Service Kubernetes route le trafic vers les Pods via ses `Endpoints`. Si la colonne `ENDPOINTS` affiche `<none>`, aucun Pod ne correspond au sélecteur du Service — le trafic est silencieusement abandonné.

**Examiner le détail d'un Service pour comparer sélecteur et labels des Pods :**

```bash
kubectl describe service api-backend-svc -n ecommerce
kubectl describe service frontend-svc -n ecommerce
```

`kubectl describe` affiche le sélecteur configuré sur le Service ainsi que les Endpoints résolus. Comparez ces informations avec les labels effectifs des Pods listés dans la commande précédente.

Notez précisément ce que vous observez sur chacun des deux Services avant de passer à l'investigation.
