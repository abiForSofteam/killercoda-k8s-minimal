## Vérification fonctionnelle

Validez chaque correction par un test de connectivité réel, non par l'inspection de la ressource.

**Test 1 — Accès interne au backend via le Service ClusterIP**

Lancez un Pod client temporaire dans le même namespace et tentez d'atteindre le Service `api-backend-svc` via son nom DNS interne :

```bash
kubectl run test-client --image=busybox:1.36 --restart=Never --rm -it \
  -n ecommerce -- wget -qO- http://api-backend-svc.ecommerce.svc.cluster.local
```

La réponse attendue est `api-backend-response`. Le Pod se supprime automatiquement après l'exécution grâce à `--rm`.

**Test 2 — Accès externe au frontend via le Service NodePort**

Récupérez l'adresse IP du nœud `controlplane` :

```bash
kubectl get node controlplane -o wide
```

Puis testez l'accès sur le port NodePort `30080` :

```bash
curl http://<INTERNAL-IP>:30080
```

Remplacez `<INTERNAL-IP>` par l'adresse IP affichée dans la colonne `INTERNAL-IP`. La réponse attendue est `frontend-response`.

<div style="background-color: rgb(255, 245, 220); border-left: 4px solid rgb(210, 140, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(140, 90, 0);">Critère de succès</strong><br/>
  Les deux tests doivent retourner le contenu texte du Pod cible (<code>api-backend-response</code> et <code>frontend-response</code>) sans erreur de connexion ni timeout. Un résultat <code>Connection refused</code> ou <code>wget: server returned error</code> indique qu'une des deux corrections est incomplète.
</div>
