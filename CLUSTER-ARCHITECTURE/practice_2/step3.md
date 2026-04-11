## Jonction du nœud worker

Vous disposez maintenant de la commande `kubeadm join` complète. Il est temps de l'exécuter sur le nœud worker.

### Étape 1 — Générer la commande join depuis le control-plane

Sur `controlplane`, exécutez :

```bash
kubeadm token create --print-join-command
```

La sortie ressemble à :

```
kubeadm join <IP-CONTROL-PLANE>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

Copiez l'intégralité de cette ligne. Le token est valide 24 heures. Le hash `sha256:...` est le fingerprint du certificat CA du control-plane : il garantit que `node01` joint bien votre cluster et non un cluster tiers.

<div style="background-color: rgb(245, 235, 255); border-left: 4px solid rgb(130, 50, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(90, 30, 160);">Analogie</strong><br/>
  Le token est le mot de passe temporaire, le hash CA est l'empreinte de la carte d'identité du control-plane. Le nœud worker vérifie les deux avant d'accepter les ordres : il s'authentifie, et il authentifie celui à qui il parle.
</div>

### Étape 2 — Exécuter kubeadm join sur node01

Connectez-vous à `node01` et lancez la commande join :

```bash
ssh node01
```

Puis, sur `node01` :

```bash
kubeadm join <IP-CONTROL-PLANE>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

Remplacez les valeurs par la sortie exacte obtenue à l'étape 1. L'exécution dure environ 30 à 60 secondes. Une sortie terminant par `This node has joined the cluster` confirme le succès.

### Étape 3 — Revenir sur controlplane

```bash
exit
```

### Étape 4 — Vérifier l'apparition du nœud

```bash
kubectl get nodes
```

`node01` doit apparaître avec le statut `NotReady` dans un premier temps, puis passer à `Ready` en 30 à 60 secondes, le temps que le CNI (Calico) configure le réseau sur le nouveau nœud.

Le passage de `NotReady` à `Ready` est piloté par kubelet, qui remonte son état au kube-apiserver via des heartbeats réguliers (toutes les 10 secondes par défaut).

```bash
kubectl get nodes --watch
```

Utilisez `Ctrl+C` pour quitter le watch une fois que `node01` affiche `Ready`.
