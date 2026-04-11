<div style="background-color: rgb(225, 245, 255); border-left: 4px solid rgb(0, 130, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(0, 80, 140);">À retenir</strong><br/>
  Joindre un nœud worker à un cluster kubeadm requiert toujours trois éléments : l'adresse du kube-apiserver, un token de jonction valide (TTL 24h par défaut), et le hash SHA-256 du certificat CA du control-plane. La commande <code>kubeadm token create --print-join-command</code> produit ces trois éléments en une seule invocation. Le statut <code>NotReady</code> immédiatement après la jonction est normal : il disparaît dès que le CNI a configuré le réseau du nœud. La validation fonctionnelle — scheduler un Pod sur le nœud — est toujours plus fiable que la seule lecture du statut <code>Ready</code>.
</div>

---

## Questions d'autoévaluation

**Niveau principe**
Quel est le rôle du hash `--discovery-token-ca-cert-hash` dans la commande `kubeadm join`, et quel risque de sécurité ce mécanisme adresse-t-il ?

**Niveau mécanisme**
Pourquoi un nœud worker nouvellement joint affiche-t-il le statut `NotReady` pendant plusieurs dizaines de secondes, et quel composant est responsable du passage à `Ready` ?

**Niveau transfert**
Dans quels autres scénarios opérationnels (maintenance, scaling, reprise après incident) la procédure `kubeadm token create --print-join-command` suivie de `kubeadm join` est-elle utilisée de la même façon ?

---

## Pour aller plus loin

**Mise à jour d'un cluster kubeadm** — Une fois la jonction maîtrisée, la prochaine compétence associée est la mise à jour du control-plane puis des workers via `kubeadm upgrade`. La procédure suit un ordre strict : control-plane d'abord, workers ensuite, un par un.

**Gestion des certificats du cluster** — Les tokens de jonction expirent, mais les certificats du cluster eux-mêmes (kube-apiserver, etcd, front-proxy) ont une durée de vie d'un an par défaut. `kubeadm certs check-expiration` et `kubeadm certs renew` sont les commandes associées.

Documentation officielle : https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
