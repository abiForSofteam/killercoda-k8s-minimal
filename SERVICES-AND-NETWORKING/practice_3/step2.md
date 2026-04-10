## Investigation

Vous disposez maintenant d'un premier état des lieux. Avant de corriger quoi que ce soit, il faut comprendre précisément pourquoi le trafic ne circule pas.

> 💡 Un Service Kubernetes sélectionne ses Pods via des labels. Quelle propriété du Service définit ce critère de sélection, et comment vérifier que les Pods existants y correspondent réellement ?

> 💡 Vous observez qu'un Service affiche des Endpoints vides. Quelles sont les deux causes possibles qui expliqueraient qu'aucun Pod ne soit retenu, sans que le Deployment soit en erreur ?

> 💡 Pour le Service de type NodePort, à quel niveau du chemin réseau le `targetPort` intervient-il, et quelle conséquence une valeur incorrecte a-t-elle sur la capacité du Service à relayer le trafic vers le conteneur ?

<div style="background-color: rgb(255, 235, 235); border-left: 4px solid rgb(200, 50, 50); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(160, 30, 30);">Point d'attention</strong><br/>
  Un Service de type NodePort dont les Pods sont correctement sélectionnés (Endpoints non vides) peut malgré tout ne pas répondre sur le port exposé. La présence d'Endpoints n'est pas une garantie de bon fonctionnement de bout en bout : le <code>targetPort</code> doit correspondre exactement au port sur lequel le processus écoute à l'intérieur du conteneur, et non au port exposé par le Service ou au nodePort.
</div>

> 💡 Comment vérifier sur quel port un conteneur en cours d'exécution écoute réellement, sans accéder au code source de l'application ?
