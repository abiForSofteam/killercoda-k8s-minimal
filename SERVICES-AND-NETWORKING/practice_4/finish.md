<div style="background-color: rgb(225, 245, 255); border-left: 4px solid rgb(0, 130, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(0, 80, 140);">A retenir</strong><br/>
  CoreDNS est le resolver DNS interne de tout cluster Kubernetes. Sa configuration est portee par le ConfigMap <code>coredns</code> dans le namespace <code>kube-system</code>. Une erreur dans le Corefile — meme mineure — empeche CoreDNS de demarrer ou de recharger sa configuration, rendant toute resolution de nom inter-services impossible. Le statut <code>Running</code> d'un Pod CoreDNS ne garantit pas que sa configuration est valide : les logs sont la source de verite. Toute panne de communication entre services qui fonctionne par IP mais echoue par nom de service doit orienter immediatement vers CoreDNS.
</div>

## Questions d'autoevaluation

**Niveau principe** : Quel est le role de CoreDNS dans un cluster Kubernetes, et quelle ressource porte sa configuration ?

**Niveau mecanisme** : Pourquoi un Pod CoreDNS peut-il afficher le statut `Running` alors que la resolution DNS est totalement defaillante pour les services du cluster ?

**Niveau transfert** : Dans quels autres scenarios une panne de resolution DNS interne peut-elle se manifester, et comment distinguer une erreur de configuration CoreDNS d'une NetworkPolicy trop restrictive bloquant le port 53 ?

## Pour aller plus loin

- **EndpointSlices et Endpoints** : comprendre pourquoi CoreDNS retourne une IP de service et non directement l'IP du Pod, et le role des Endpoints dans ce mecanisme.
- **NetworkPolicy sur le port 53** : une NetworkPolicy restrictive sur le namespace `kube-system` ou sur le namespace applicatif peut bloquer les requetes DNS meme si CoreDNS fonctionne correctement — un cas frequent en environnement securise.
- Documentation officielle : [https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
