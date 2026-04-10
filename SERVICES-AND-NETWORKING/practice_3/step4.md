## Vérification fonctionnelle

Les corrections sont en place. Il faut maintenant valider que le trafic circule réellement, et non simplement que les ressources semblent correctes dans leur déclaration.

---

**Test 1 — Communication interne via `catalog-svc` (ClusterIP)**

Lancez un Pod temporaire dans le même namespace pour tester la résolution DNS et la connectivité HTTP vers le Service interne :

```bash
kubectl run test-client --image=busybox:1.36 --restart=Never -n ecommerce \
  --rm -it -- wget -qO- http://catalog-svc
```

Le résultat attendu est la page HTML par défaut de nginx. Si la commande retourne une réponse HTML, la communication interne via ClusterIP fonctionne.

---

**Test 2 — Accessibilité externe via `frontend-svc` (NodePort)**

Récupérez l'adresse IP du noeud `controlplane` :

```bash
kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'
```

Puis testez l'accès HTTP sur le port NodePort exposé :

```bash
curl -s http://<IP-DU-NOEUD>:30080 | head -5
```

Remplacez `<IP-DU-NOEUD>` par l'adresse obtenue. Le résultat attendu est les premières lignes HTML de la page nginx.

---

<div style="background-color: rgb(255, 245, 220); border-left: 4px solid rgb(210, 140, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(140, 90, 0);">Critère de succès</strong><br/>
  Les deux tests doivent retourner un contenu HTML valide sans erreur de connexion. La commande <code>kubectl get endpoints -n ecommerce</code> doit afficher des adresses IP non vides pour <code>catalog-svc</code> et <code>frontend-svc</code>. Le contenu HTML confirme que le trafic traverse bien le Service jusqu'au conteneur, sans être bloqué par un mauvais port ou un selector incorrect.
</div>
