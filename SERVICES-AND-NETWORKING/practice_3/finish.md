<div style="background-color: rgb(225, 245, 255); border-left: 4px solid rgb(0, 130, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(0, 80, 140);">A retenir</strong><br/>
  Un Service Kubernetes n'achemine du trafic que si trois conditions sont simultanément remplies : le <code>selector</code> correspond exactement aux labels des Pods cibles (la moindre divergence orthographique suffit à produire des Endpoints vides), le <code>targetPort</code> correspond au port réellement écouté par le processus dans le conteneur, et le type de Service est adapté au périmètre d'exposition souhaité. La présence d'Endpoints non vides est une condition nécessaire mais non suffisante : un <code>targetPort</code> incorrect laisse les Endpoints peuplés tout en rendant le Service inopérant. Diagnostiquer un Service commence toujours par <code>kubectl get endpoints</code>.
</div>

---

## Questions d'autoévaluation

**Niveau principe**
Quel est le rôle du champ `selector` dans un Service Kubernetes, et quel mécanisme du control-plane maintient la cohérence entre ce champ et la liste des Endpoints ?

**Niveau mécanisme**
Pourquoi un Service de type NodePort peut-il afficher des Endpoints non vides et rester pourtant inaccessible depuis l'extérieur du cluster ?

**Niveau transfert**
Dans quels autres contextes Kubernetes le principe de correspondance stricte entre labels et selectors s'applique-t-il, en dehors des Services ?

---

## Pour aller plus loin

**NetworkPolicies** — Une fois les Services correctement configurés, les NetworkPolicies permettent de contrôler finement quels Pods ont le droit d'atteindre quels Services, au niveau du trafic réseau entrant et sortant. La maîtrise des NetworkPolicies est complémentaire à celle des Services pour sécuriser les communications intra-cluster.

**Ingress et IngressClass** — Le type LoadBalancer et NodePort exposent des Services individuels. L'objet Ingress permet de centraliser l'exposition HTTP/HTTPS de plusieurs Services derrière un point d'entrée unique, avec routage par hôte ou par chemin. C'est le pattern standard en production pour les applications web.

Documentation officielle : https://kubernetes.io/docs/concepts/services-networking/service/
