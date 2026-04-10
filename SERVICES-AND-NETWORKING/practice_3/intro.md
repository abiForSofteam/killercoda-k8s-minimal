<div style="background-color: rgb(230, 240, 255); border-left: 4px solid rgb(50, 100, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(30, 70, 160);">Objectif pédagogique</strong><br/>
  A l'issue de cet exercice, vous serez capable d'identifier la cause d'une rupture de connectivité entre services Kubernetes, de corriger la configuration d'un Service ClusterIP et d'un Service NodePort, et de choisir le type de Service adapté à chaque cas d'exposition.
</div>

<div style="background-color: rgb(240, 240, 240); border-left: 4px solid rgb(120, 120, 120); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(60, 60, 60);">Prérequis</strong><br/>
  <ul style="margin: 8px 0 0 16px; padding: 0;">
    <li>Connaissance des objets Kubernetes de base : Pod, Deployment, Service</li>
    <li>Notions sur les labels et les selecteurs Kubernetes</li>
    <li>Utilisation courante de <code>kubectl get</code>, <code>kubectl describe</code> et <code>kubectl edit</code></li>
  </ul>
</div>

<div style="background-color: rgb(255, 248, 225); border-left: 4px solid rgb(200, 160, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(130, 100, 0);">Durée estimée</strong><br/>
  20 minutes pour un candidat CKA — 35 minutes pour un débutant
</div>

L'équipe frontend vous contacte en urgence : depuis la dernière mise à jour des manifestes de l'environnement `ecommerce`, leur application n'arrive plus à joindre l'API backend, et les utilisateurs finaux ne peuvent plus accéder à l'interface web depuis l'extérieur du cluster. Les deux composants semblaient fonctionner individuellement il y a encore une heure, mais les équipes ont appliqué un lot de correctifs en série sans revenir à l'état validé. L'astreinte est déclenchée. Votre mission est de diagnostiquer pourquoi la communication est coupée, de corriger la configuration des Services impliqués, et de rétablir un accès fonctionnel — tant en interne qu'en externe — sans recréer les ressources depuis zéro.
