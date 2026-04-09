<div style="background-color: rgb(230, 240, 255); border-left: 4px solid rgb(50, 100, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(30, 70, 160);">🎯 Objectif pédagogique</strong><br/>
  À l'issue de cet exercice, vous serez capable d'identifier pourquoi deux pods ne peuvent pas communiquer dans un cluster Kubernetes, en raisonnant sur le modèle réseau (adressage pod, résolution DNS, flux CNI) et en distinguant une restriction réseau explicite d'une défaillance infra.
</div>

<div style="background-color: rgb(240, 240, 240); border-left: 4px solid rgb(120, 120, 120); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(60, 60, 60);">📚 Prérequis</strong><br/>
  <ul style="margin: 8px 0 0 16px; padding: 0;">
    <li>Connaître les objets Kubernetes de base : Pod, Deployment, Service</li>
    <li>Savoir utiliser <code>kubectl exec</code> et <code>kubectl get</code></li>
    <li>Avoir une notion des adresses IP dans un cluster (pods et services ont chacun leur IP)</li>
  </ul>
</div>

<div style="background-color: rgb(255, 248, 225); border-left: 4px solid rgb(200, 160, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(130, 100, 0);">⏱️ Durée estimée</strong><br/>
  20 minutes pour un candidat CKA — 35 minutes pour un débutant
</div>

L'équipe front-end vous contacte en urgence : leur service ne reçoit plus aucune réponse de l'API backend depuis la maintenance réseau de la nuit dernière. Les appels aboutissent à un timeout systématique, alors que le déploiement de l'API n'a pas bougé et que les pods semblent en état `Running`.

La mise en production d'une nouvelle fonctionnalité est prévue dans deux heures. L'équipe SRE a déjà écarté un problème applicatif — les conteneurs démarrent correctement et les logs ne montrent aucune erreur interne. La piste réseau n'a pas encore été explorée.

Vous êtes ingénieur platform. Votre mission : identifier pourquoi la communication entre le pod frontend et le service backend est impossible, comprendre le mécanisme en cause, et rétablir le flux réseau.