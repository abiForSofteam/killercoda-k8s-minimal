## Correction du probleme

Vous avez identifie que la configuration CoreDNS contient une directive invalide. Voici la demarche de correction.

Recuperez la configuration actuelle du ConfigMap CoreDNS pour visualiser l'erreur :

```bash
kubectl get configmap coredns -n kube-system -o yaml
```

Examinez le champ `Corefile`. Un plugin mal orthographie ou inexistant provoque un echec de demarrage ou de rechargement de CoreDNS. Le plugin `errorz` n'existe pas — le nom correct est `errors`.

<div style="background-color: rgb(245, 235, 255); border-left: 4px solid rgb(130, 50, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(90, 30, 160);">Analogie</strong><br/>
  Le Corefile de CoreDNS fonctionne comme un fichier de configuration Apache ou Nginx : chaque directive doit correspondre exactement a un plugin compile dans le binaire. Une faute de frappe dans le nom d'un plugin est silencieuse au niveau de Kubernetes, mais fatale au demarrage du processus DNS lui-meme.
</div>

Corrigez le ConfigMap en remplacant la directive invalide par le nom correct :

```bash
kubectl edit configmap coredns -n kube-system
```

Dans l'editeur, remplacez `errorz` par `errors` dans le bloc `Corefile`, sauvegardez et quittez.

CoreDNS surveille son ConfigMap et recharge sa configuration automatiquement. Pour accelerer la prise en compte, forcez un redemarrage du Deployment :

```bash
kubectl rollout restart deployment/coredns -n kube-system
```

Attendez que le rollout soit complet :

```bash
kubectl rollout status deployment/coredns -n kube-system
```

La commande doit retourner `successfully rolled out` avant de passer a la verification.
