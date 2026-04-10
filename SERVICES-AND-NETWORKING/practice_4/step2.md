## Investigation de la cause racine

Vous avez confirme que la resolution DNS echoue depuis les Pods applicatifs. Il faut maintenant localiser l'origine exacte du dysfonctionnement.

> Quel composant est responsable de la resolution DNS interne dans un cluster Kubernetes, et comment verifier son etat operationnel ?

> Si ce composant est present mais en etat de redemarrage repetitif, quelle source d'information permet de comprendre pourquoi il ne parvient pas a demarrer correctement ?

> La configuration de ce composant est stockee dans une ressource Kubernetes standard. Laquelle, et dans quel namespace ?

<div style="background-color: rgb(255, 235, 235); border-left: 4px solid rgb(200, 50, 50); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(160, 30, 30);">Point d'attention</strong><br/>
  Les Pods CoreDNS peuvent apparaitre en statut <code>Running</code> meme lorsque leur configuration est incorrecte, si le processus a demarré avant la corruption. Verifier le statut seul ne suffit pas : les logs du Pod en cours d'execution sont indispensables pour detecter les erreurs de parsing de configuration.
</div>
