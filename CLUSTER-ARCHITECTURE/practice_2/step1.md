## État des lieux du cluster

Avant d'agir, observez l'état exact du cluster tel qu'il se présente.

**Listez les nœuds connus du cluster :**

```bash
kubectl get nodes -o wide
```

Cette commande révèle combien de nœuds sont enregistrés, leur rôle (`control-plane` ou `<none>`), leur statut (`Ready`, `NotReady`), et leur version de kubelet. Si un nœud est absent de cette liste, le cluster n'en a simplement pas connaissance — il n'est pas "en erreur", il n'existe pas encore du point de vue du control-plane.

**Vérifiez que le control-plane est sain :**

```bash
kubectl get pods -n kube-system
```

Tous les composants du control-plane (kube-apiserver, etcd, kube-scheduler, kube-controller-manager, CoreDNS, kube-proxy) doivent afficher le statut `Running`. Un control-plane dégradé rend toute jonction de nœud impossible.

**Vérifiez que le nœud cible est accessible :**

```bash
ssh node01 "hostname && systemctl status kubelet --no-pager | head -5"
```

Cette commande confirme que la machine est joignable et indique si kubelet est actif ou arrêté. Un kubelet arrêté sur `node01` est attendu — il n'a pas encore été configuré pour rejoindre le cluster.

---

> Notez précisément ce que vous observez avant de passer à l'étape suivante : combien de nœuds sont listés, lesquels sont `Ready`, et quel est l'état de kubelet sur `node01`.
