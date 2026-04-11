<div style="background-color: rgb(230, 240, 255); border-left: 4px solid rgb(50, 100, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(30, 70, 160);">Objectif pédagogique</strong><br/>
  Être capable de joindre un nœud worker à un control-plane Kubernetes existant en utilisant <code>kubeadm token</code> et <code>kubeadm join</code>, et de valider que le cluster est pleinement opérationnel après la jonction.
</div>

<div style="background-color: rgb(240, 240, 240); border-left: 4px solid rgb(120, 120, 120); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(60, 60, 60);">Prérequis</strong><br/>
  <ul style="margin: 8px 0 0 16px; padding: 0;">
    <li>Connaître les composants du control-plane Kubernetes (kube-apiserver, etcd, scheduler, controller-manager)</li>
    <li>Savoir ce que fait <code>kubeadm init</code> à haut niveau</li>
    <li>Être à l'aise avec <code>kubectl get nodes</code> et l'interprétation des statuts de nœuds</li>
    <li>Comprendre le rôle de kubelet sur un nœud worker</li>
  </ul>
</div>

<div style="background-color: rgb(255, 248, 225); border-left: 4px solid rgb(200, 160, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(130, 100, 0);">Durée estimée</strong><br/>
  15 minutes pour un candidat CKA — 30 minutes pour un débutant
</div>

---

L'équipe plateforme vient de provisionner un nouveau nœud de calcul pour absorber la charge croissante de l'environnement de staging. Le control-plane est opérationnel, mais le nœud n'a pas encore été intégré au cluster : aucun Pod de charge ne peut être schedulé sur cette machine tant qu'elle n'est pas membre à part entière.

L'ops en astreinte a commencé la procédure d'ajout hier soir, mais a dû s'arrêter en urgence avant de terminer. Il vous transmet le dossier : le control-plane tourne correctement, le nœud est accessible en SSH, mais le cluster ne le reconnaît pas.

Votre mission est de mener à terme la jonction de ce nœud worker, de vérifier que le cluster est dans un état pleinement fonctionnel, et de valider qu'un Pod peut effectivement être schedulé sur ce nouveau nœud.
