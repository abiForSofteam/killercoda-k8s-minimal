## Correction et explication du mécanisme

### Identification de la cause

Listez les NetworkPolicies présentes dans le namespace `backend` :

```bash
kubectl get networkpolicy -n backend
```

Inspectez la policy identifiée :

```bash
kubectl describe networkpolicy backend-hardening -n backend
```

Vous observez une policy dont le `podSelector` est vide (`{}`) — elle s'applique donc à **tous les pods** du namespace — et qui déclare `policyTypes: [Ingress]` sans aucune règle `ingress`. C'est la forme canonique d'une politique de **deny-all ingress** : tout trafic entrant vers les pods du namespace `backend` est silencieusement rejeté.

<div style="background-color: rgb(245, 235, 255); border-left: 4px solid rgb(130, 50, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(90, 30, 160);">🔎 Analogie</strong><br/>
  Une NetworkPolicy sans règle <code>ingress</code> mais avec <code>policyTypes: [Ingress]</code> agit comme un portier qui a reçu la consigne de filtrer les entrées, mais aucune liste blanche. Résultat : il refuse tout le monde, sans message d'erreur explicite — le visiteur attend simplement que la porte s'ouvre.
</div>

### Correction

Deux approches sont possibles selon le contexte :

**Option A — Supprimer la NetworkPolicy (si elle n'est pas intentionnelle) :**

```bash
kubectl delete networkpolicy backend-hardening -n backend
```

**Option B — Amender la NetworkPolicy pour autoriser le trafic depuis le namespace `frontend` (approche sécurisée recommandée en production) :**

```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-hardening
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
EOF
```

Cette version autorise explicitement le trafic ingress depuis tout pod du namespace `frontend`, et continue de bloquer tout autre source.

### Pourquoi ça fonctionne

Dans le modèle réseau Kubernetes, le CNI (ici Calico) garantit la connectivité L3 entre tous les pods par défaut. Les NetworkPolicies sont des règles appliquées **par-dessus** ce plan de base. Dès qu'une NetworkPolicy sélectionne un pod, le comportement par défaut bascule de "tout autoriser" à "tout refuser sauf ce qui est explicitement listé". Supprimer ou corriger la policy restitue (ou filtre correctement) le flux réseau sans toucher à l'infrastructure.