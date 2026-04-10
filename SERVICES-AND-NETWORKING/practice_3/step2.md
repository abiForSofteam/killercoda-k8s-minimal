## Investigation

Utilisez les observations de l'inventaire pour identifier précisément la cause de chaque rupture de connectivité.

> Quel mécanisme Kubernetes permet à un Service de savoir vers quels Pods acheminer le trafic, et comment ce mécanisme est-il matérialisé dans la définition du Service ?

> Lorsque la liste des Endpoints d'un Service est vide alors que les Pods sont en cours d'exécution, quelles sont les deux explications possibles, et comment les distinguer sans modifier de ressource ?

> Pour le Service `frontend-svc` de type NodePort, les Endpoints ne sont pas vides — pourtant le trafic n'atteint pas le conteneur. Quel paramètre, distinct du sélecteur, est responsable de l'acheminement du trafic entre le Service et le port d'écoute du conteneur ?

<div style="background-color: rgb(255, 235, 235); border-left: 4px solid rgb(200, 50, 50); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(160, 30, 30);">Point d'attention</strong><br/>
  Un Service NodePort avec des Endpoints non vides peut donner l'illusion d'une configuration correcte. La présence d'Endpoints indique uniquement que le sélecteur a matché des Pods — elle ne garantit pas que le port de destination (<code>targetPort</code>) correspond au port sur lequel le conteneur écoute réellement. Ces deux niveaux de configuration sont indépendants et peuvent échouer séparément.
</div>

> Le type d'un Service détermine son périmètre d'exposition. Quels sont les trois types à connaître pour le CKA, et pour chaque type, quel est le périmètre d'accessibilité du trafic entrant ?
