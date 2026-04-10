<div style="background-color: rgb(230, 240, 255); border-left: 4px solid rgb(50, 100, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(30, 70, 160);">Objectif pedagogique</strong><br/>
  Etre capable de diagnostiquer une defaillance de la resolution DNS interne dans un cluster Kubernetes, d'identifier la cause dans la configuration CoreDNS, et d'appliquer une correction en production.
</div>

<div style="background-color: rgb(240, 240, 240); border-left: 4px solid rgb(120, 120, 120); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(60, 60, 60);">Prerequis</strong><br/>
  <ul style="margin: 8px 0 0 16px; padding: 0;">
    <li>Connaissance des objets Kubernetes de base : Pod, Deployment, Service</li>
    <li>Utilisation courante de <code>kubectl</code> (get, describe, logs, exec)</li>
    <li>Notions sur le role d'un resolver DNS dans un reseau</li>
  </ul>
</div>

<div style="background-color: rgb(255, 248, 225); border-left: 4px solid rgb(200, 160, 0); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(130, 100, 0);">Duree estimee</strong><br/>
  20 minutes pour un candidat CKA — 35 minutes pour un debutant
</div>

L'equipe frontend de la plateforme e-commerce signale une degradation totale depuis ce matin : les appels vers le service de catalogue produit echouent systematiquement cote client, alors que le service lui-meme repond correctement en acces direct par IP. La regression est apparue apres une intervention de maintenance nocturne sur les composants systeme du cluster. L'astreinte est declenchee, plusieurs milliers de sessions utilisateurs sont impactees. Votre mission est d'identifier l'origine de cette panne de communication inter-services et de retablir un fonctionnement normal sans redemarrer les Pods applicatifs.
