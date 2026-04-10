<div style="background-color: rgb(230, 240, 255); border-left: 4px solid rgb(50, 100, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(30, 70, 160);">Objectif pédagogique</strong><br/>
  A l'issue de cet exercice, vous serez capable de diagnostiquer une rupture d'accessibilité applicative liée à une mauvaise configuration de Services Kubernetes, et de corriger les types ClusterIP et NodePort pour rétablir la communication interne et l'exposition externe.
</div>

<div style="background-color: rgb(240, 240, 240); border-left: 4px solid rgb(120, 120, 120); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(60, 60, 60);">Prérequis</strong><br/>
  <ul style="margin: 8px 0 0 16px; padding: 0;">
    <li>Connaissance des objets Kubernetes fondamentaux : Pod, Deployment, Service</li>
    <li>Compréhension du modèle réseau Kubernetes (pod-to-pod, ClusterIP)</li>
    <li>Maîtrise de base de <code>kubectl</code> : get, describe, edit, patch</li>
  </ul>
</div>

<div style="background-color: rgb(255, 248, 225); border-left: 4px solid rgb(200, 160, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(130, 100, 0);">Durée estimée</strong><br/>
  20 minutes pour un candidat CKA — 35 minutes pour un débutant
</div>

---

L'équipe frontend de la plateforme e-commerce signale que le site ne répond plus depuis ce matin. Les utilisateurs obtiennent des pages vides ou des erreurs de connexion selon le point d'entrée utilisé. L'équipe backend confirme que le service de catalogue de produits, pourtant déployé et en cours d'exécution, ne reçoit aucune requête de la part du frontend.

Hier soir, un membre de l'équipe infrastructure a procédé à une réorganisation des manifestes de Services dans le namespace `ecommerce` dans le cadre d'une mise en conformité. Depuis, aucune communication ne passe entre les composants, et le frontend n'est plus accessible depuis l'extérieur du cluster.

Vous êtes l'ingénieur de garde. Votre mission est d'identifier ce qui empêche le trafic d'atteindre les applications, puis de rétablir à la fois la communication interne entre les services et l'accessibilité externe du frontend.
