## Correction guidée

Deux problèmes distincts coexistent dans cet environnement. Ils doivent être corrigés indépendamment.

---

### Problème 1 — Le Service `catalog-svc` ne sélectionne aucun Pod

En inspectant le `selector` du Service `catalog-svc`, vous avez constaté qu'il cible `app: catalogue`, alors que les Pods du Deployment `catalog` portent le label `app: catalog`. Cette divergence orthographique suffit à rompre la liaison : aucun Endpoint n'est créé, aucun trafic ne transite.

**Correction — patcher le selector du Service**

```bash
kubectl patch service catalog-svc -n ecommerce \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/app", "value": "catalog"}]'
```

Le `selector` est la clé du mécanisme de découverte de services dans Kubernetes : le controller `endpoints` surveille en permanence les Pods dont les labels correspondent au selector de chaque Service, et maintient la liste d'Endpoints à jour. Corriger ce champ suffit à déclencher la mise à jour immédiate des Endpoints, sans redémarrage.

Vérification immédiate :

```bash
kubectl get endpoints catalog-svc -n ecommerce
```

La colonne `ENDPOINTS` doit désormais afficher les adresses IP des Pods `catalog`.

---

### Problème 2 — Le Service `frontend-svc` redirige vers le mauvais port

Le Service `frontend-svc` est de type NodePort. Son `selector` est correct (`app: frontend`), des Endpoints sont donc présents. Cependant, son `targetPort` est configuré à `8080`, alors que le conteneur `nginx` écoute sur le port `80`. Le trafic entrant atteint bien les Pods, mais est rejeté faute de processus à l'écoute sur `8080`.

<div style="background-color: rgb(245, 235, 255); border-left: 4px solid rgb(130, 50, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(90, 30, 160);">Analogie</strong><br/>
  Le <code>targetPort</code> est l'équivalent du numéro d'appartement dans un immeuble. Le Service sait dans quel immeuble livrer le colis (le Pod, via le selector), mais s'il frappe à la porte 8080 alors que le destinataire est au 80, personne ne répond. L'adresse est juste, l'étage est faux.
</div>

**Correction — modifier le targetPort du Service**

```bash
kubectl patch service frontend-svc -n ecommerce \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/ports/0/targetPort", "value": 80}]'
```

Vérification immédiate :

```bash
kubectl describe service frontend-svc -n ecommerce
```

Le champ `TargetPort` doit indiquer `80/TCP`.

---

Les deux Services sont maintenant correctement configurés. Passez à la vérification fonctionnelle.
