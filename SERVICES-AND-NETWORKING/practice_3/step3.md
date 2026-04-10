## Correction guidée

Deux anomalies sont à corriger, dans l'ordre suivant : d'abord le Service `api-backend-svc`, ensuite le Service `frontend-svc`.

---

### Correction 1 — Sélecteur incorrect sur `api-backend-svc`

Le Service `api-backend-svc` possède un sélecteur `app: api` qui ne correspond à aucun Pod. Les Pods du Deployment `api-backend` portent le label `app: api-backend`. Le sélecteur doit être mis à jour pour cibler le bon ensemble de Pods.

```bash
kubectl patch service api-backend-svc -n ecommerce \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/app", "value": "api-backend"}]'
```

`kubectl patch` avec le type `json` permet de cibler un champ précis du manifeste sans réécrire l'intégralité de la ressource. L'opération `replace` sur `/spec/selector/app` écrase uniquement la valeur du label cible. Dès que le sélecteur est corrigé, le contrôleur Endpoints reconcilie immédiatement la liste et les Pods correspondants apparaissent.

Vérifiez que les Endpoints sont maintenant peuplés :

```bash
kubectl get endpoints api-backend-svc -n ecommerce
```

La colonne `ENDPOINTS` doit afficher les adresses IP des deux Pods `api-backend`.

---

### Correction 2 — Port de destination incorrect sur `frontend-svc`

Le Service `frontend-svc` est correctement sélectionné — ses Endpoints pointent vers les Pods `frontend`. Mais le champ `targetPort` est réglé à `9090`, alors que le conteneur écoute sur le port `8080`. Tout paquet entrant est rejeté au niveau du conteneur.

```bash
kubectl patch service frontend-svc -n ecommerce \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/ports/0/targetPort", "value": 8080}]'
```

Le `targetPort` est le port sur lequel le processus à l'intérieur du conteneur reçoit effectivement les connexions. Il doit correspondre à la valeur déclarée dans `containerPort` du Pod (ou à l'argument d'écoute de l'application). Le `port` du Service (ici `80`) est le port exposé côté cluster — ces deux valeurs sont indépendantes.

<div style="background-color: rgb(245, 235, 255); border-left: 4px solid rgb(130, 50, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(90, 30, 160);">Analogie</strong><br/>
  Un Service Kubernetes ressemble à un standard téléphonique d'entreprise : le numéro externe (port du Service) est celui que compose l'appelant, mais le standard le redirige vers le poste interne du collaborateur (targetPort). Si le poste interne est incorrect, la sonnerie ne retentit jamais — même si le numéro externe est parfaitement valide et le combiné décroché.
</div>

Vérifiez la correction :

```bash
kubectl describe service frontend-svc -n ecommerce
```

Le champ `TargetPort` doit afficher `8080/TCP`.
