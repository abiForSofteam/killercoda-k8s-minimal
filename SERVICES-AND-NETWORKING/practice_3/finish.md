<div style="background-color: rgb(225, 245, 255); border-left: 4px solid rgb(0, 130, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(0, 80, 140);">A retenir</strong><br/>
  Un Service Kubernetes opère sur deux niveaux indépendants : le <strong>sélecteur</strong> détermine quels Pods reçoivent le trafic (via les labels), et le <strong>targetPort</strong> détermine sur quel port du conteneur ce trafic est livré. Ces deux niveaux peuvent échouer séparément — des Endpoints non vides ne garantissent pas un acheminement correct. Avant toute correction, distinguer l'absence de correspondance de sélecteur (Endpoints vides) d'un mauvais port de destination (Endpoints présents mais trafic rejeté au conteneur). Le type du Service (ClusterIP, NodePort, LoadBalancer) détermine le périmètre d'exposition, pas la validité du routage interne.
</div>

## Questions d'autoévaluation

**Niveau principe**
Quel est le rôle des Endpoints dans l'architecture d'un Service Kubernetes, et comment sont-ils peuplés automatiquement ?

**Niveau mécanisme**
Pourquoi un Service dont les Endpoints sont non vides peut-il malgré tout échouer à acheminer le trafic vers le conteneur, et quel champ de la spec est en cause ?

**Niveau transfert**
Dans quels autres scénarios Kubernetes — au-delà des Services — la divergence entre un sélecteur configuré et les labels réels d'un objet peut-elle provoquer une rupture silencieuse de fonctionnement ?

---

## Pour aller plus loin

**EndpointSlices** — Depuis Kubernetes 1.21, le contrôleur Endpoints utilise les `EndpointSlice` comme représentation interne. Comprendre leur structure permet d'interpréter les comportements à grande échelle (nombreux Pods) et les erreurs de routage subtiles.

**NetworkPolicy** — Un Service correctement configuré peut voir son trafic bloqué si une `NetworkPolicy` restrictive s'applique aux Pods cibles. La combinaison Service + NetworkPolicy est un vecteur fréquent d'incidents réseau en production.

Documentation officielle : [https://kubernetes.io/docs/concepts/services-networking/service/](https://kubernetes.io/docs/concepts/services-networking/service/)
