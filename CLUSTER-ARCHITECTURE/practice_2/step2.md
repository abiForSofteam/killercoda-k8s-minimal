## Identification des prérequis manquants

Pour joindre un nœud worker à un cluster kubeadm, deux éléments sont nécessaires : un token de jonction valide et le hash du certificat CA du control-plane. Ces informations permettent à `kubeadm join` de s'authentifier auprès du kube-apiserver en toute sécurité.

---

> Quel mécanisme kubeadm utilise-t-il pour s'assurer que le nœud rejoint bien le bon cluster, et non un cluster malveillant qui usurperait l'adresse du control-plane ?

> Les tokens de jonction kubeadm ont une durée de vie par défaut. Quelle commande vous permettrait de lister les tokens existants pour savoir si l'un d'eux est encore utilisable ?

> Si aucun token valide n'existe, quelle commande crée un nouveau token et affiche directement la commande `kubeadm join` complète, prête à être copiée-collée ?

<div style="background-color: rgb(255, 235, 235); border-left: 4px solid rgb(200, 50, 50); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(160, 30, 30);">Point d'attention</strong><br/>
  La commande <code>kubeadm token list</code> peut afficher un token dont le champ TTL est vide ou expiré. Un token expiré ne produit pas d'erreur à la lecture — il échoue silencieusement uniquement au moment du <code>kubeadm join</code>. Vérifiez systématiquement la colonne <code>EXPIRES</code> avant de réutiliser un token existant.
</div>

> Une fois le token obtenu, sur quel nœud la commande `kubeadm join` doit-elle être exécutée — et pourquoi pas sur `controlplane` ?

---

<details>
<summary>Voir la solution</summary>

**Lister les tokens existants :**

```bash
kubeadm token list
```

**Créer un nouveau token et obtenir la commande join complète :**

```bash
kubeadm token create --print-join-command
```

Cette commande génère un token avec une TTL de 24 heures et affiche la commande `kubeadm join` complète incluant l'adresse du kube-apiserver, le token, et le hash du certificat CA. Copiez l'intégralité de la sortie — elle sera utilisée à l'étape suivante.

</details>
