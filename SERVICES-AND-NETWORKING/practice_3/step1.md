## Inventaire de l'environnement

Commencez par dresser un état des lieux des ressources déployées dans le namespace `ecommerce`.

**Commande 1 — Etat général des ressources**

```bash
kubectl get all -n ecommerce
```

Cette commande liste l'ensemble des ressources actives : Pods, Deployments, ReplicaSets et Services. Elle permet de distinguer ce qui tourne effectivement de ce qui est déclaré, et de repérer en un coup d'oeil les Services présents et leurs types (ClusterIP, NodePort, LoadBalancer).

**Commande 2 — Inspection des endpoints associés aux Services**

```bash
kubectl get endpoints -n ecommerce
```

Les Endpoints représentent les adresses IP réelles des Pods sélectionnés par chaque Service. Un Service dont la colonne `ENDPOINTS` affiche `<none>` n'achemine aucun trafic, quelle que soit son apparence dans `kubectl get services`. C'est un signal d'alarme immédiat.

**Commande 3 — Détail des Services**

```bash
kubectl describe service catalog-svc -n ecommerce
kubectl describe service frontend-svc -n ecommerce
```

Le champ `Selector` indique quel label le Service utilise pour sélectionner ses Pods cibles. Le champ `Endpoints` confirme si des Pods ont effectivement été retenus. Le champ `TargetPort` précise sur quel port du conteneur le trafic est redirigé.

---

Prenez note de ce que vous observez avant de passer à l'investigation.
