# Diagnostiquer un DNS cassé — CoreDNS

## Contexte professionnel

Une application web déployée dans le namespace **production** ne parvient plus à communiquer avec son backend API depuis la dernière mise à jour du cluster Kubernetes.

Les logs applicatifs indiquent des erreurs de résolution DNS systématiques :

```
"Name or service not known"
```

- Les Pods applicatifs sont **opérationnels** mais incapables de résoudre les noms de Services internes.
- L'équipe de développement signale que l'application fonctionnait correctement **avant la maintenance nocturne** du cluster.
- L'administrateur système doit identifier et corriger la cause racine de cette défaillance DNS dans un **délai contraint** pour rétablir le service.

## Objectifs pédagogiques

À la fin de cet exercice, vous serez capable de :

- Valider le fonctionnement du Service `kube-dns` et de ses Endpoints
- Analyser les logs CoreDNS pour identifier les codes d'erreur DNS
- Diagnostiquer une configuration DNS incorrecte dans les Pods applicatifs
- Vérifier la connectivité réseau vers le Service DNS sur le port 53
- Corriger une ConfigMap CoreDNS corrompue par erreur de syntaxe

## Prérequis

- Cluster Kubernetes fonctionnel avec accès administrateur
- Commande `kubectl` configurée
- Connaissance des commandes de diagnostic réseau (`nc`, `nslookup`)
- Compréhension de la syntaxe du Corefile CoreDNS

## Contraintes

> ⚠️ Respectez impérativement ces contraintes tout au long de l'exercice :
>
> - Utiliser **exclusivement** les commandes `kubectl` et les outils disponibles dans l'image `busybox:1.28`
> - **Ne pas** redémarrer les nœuds du cluster
> - **Ne pas** supprimer le Deployment CoreDNS
> - **Conserver** la structure générale de la ConfigMap `coredns`
> - Effectuer le diagnostic **sans accès direct** aux nœuds du cluster
