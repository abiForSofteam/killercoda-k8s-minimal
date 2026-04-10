## Investigation du chemin réseau

Le Service existe, les Endpoints sont présents, les pods sont `Running` — et pourtant la communication échoue. Il faut maintenant raisonner sur ce qui, dans le modèle réseau Kubernetes, peut bloquer un flux entre deux pods en état sain.

> 💡 Dans le modèle réseau de Kubernetes, tout pod peut joindre tout autre pod par son IP sans NAT. Quel mécanisme de l'API Kubernetes peut légitimement contredire cette règle par défaut ?

> 💡 Lorsqu'une NetworkPolicy existe dans un namespace, quel est son comportement par défaut vis-à-vis du trafic non explicitement autorisé — autorisation ou refus ?

> 💡 Comment distinguer, depuis le pod frontend, un timeout causé par une règle réseau d'un timeout causé par un pod backend qui ne répond pas ? Quelle commande permettrait de tester la connectivité directement vers l'IP du pod backend, en contournant le Service ?

<div style="background-color: rgb(255, 235, 235); border-left: 4px solid rgb(200, 50, 50); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(160, 30, 30);">⚠️ Point d'attention</strong><br/>
  Les Endpoints du Service sont bien peuplés et le pod backend est <code>Running</code> — il est tentant de conclure que le problème vient du frontend ou de la résolution DNS. Vérifiez s'il existe des NetworkPolicies dans le namespace <code>backend</code> avant d'explorer d'autres pistes : une policy appliquée au namespace de destination agit indépendamment de l'état du Service.
</div>

> 💡 Quelle commande permet de lister toutes les NetworkPolicies d'un namespace, et quels champs de leur spec indiquent les flux qu'elles autorisent ou refusent ?