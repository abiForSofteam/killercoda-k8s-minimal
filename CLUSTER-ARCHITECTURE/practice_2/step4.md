## Vérification fonctionnelle du cluster

Un nœud affiché `Ready` ne suffit pas à valider une jonction réussie. La vraie validation est fonctionnelle : le scheduler doit pouvoir placer un Pod sur `node01`, et ce Pod doit démarrer correctement.

### Test de scheduling ciblé

Créez un Pod avec une contrainte `nodeName` pointant explicitement vers `node01` :

```bash
kubectl run test-node01 \
  --image=nginx:stable \
  --overrides='{"spec":{"nodeName":"node01"}}' \
  --restart=Never
```

Attendez que le Pod soit `Running` :

```bash
kubectl get pod test-node01 -o wide --watch
```

La colonne `NODE` doit afficher `node01`. Utilisez `Ctrl+C` pour quitter le watch.

### Vérification des logs

```bash
kubectl logs test-node01
```

Une sortie contenant les logs de démarrage nginx confirme que le runtime de conteneur (`containerd`) est opérationnel sur `node01` et que le réseau Pod fonctionne.

### Nettoyage

```bash
kubectl delete pod test-node01
```

---

<div style="background-color: rgb(255, 245, 220); border-left: 4px solid rgb(210, 140, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(140, 90, 0);">Critère de succès</strong><br/>
  <code>kubectl get nodes</code> affiche deux nœuds (<code>controlplane</code> et <code>node01</code>) avec le statut <code>Ready</code>. Le Pod <code>test-node01</code> passe à l'état <code>Running</code> sur <code>node01</code> et ses logs sont accessibles via <code>kubectl logs</code>.
</div>
