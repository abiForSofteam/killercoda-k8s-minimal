# Félicitations — Exercice terminé !

## Vous avez réussi !

Vous venez de résoudre un cas de panne réel rencontré en production sur des clusters Kubernetes.

---

## Ce que vous avez maîtrisé

| # | Compétence |
|---|------------|
| ✅ | Identifier un `CrashLoopBackOff` et le distinguer d'un `Pending` |
| ✅ | Utiliser `kubectl logs --previous` pour un conteneur redémarré |
| ✅ | Comprendre pourquoi un montage sans `subPath` remplace un répertoire entier |
| ✅ | Utiliser `subPath` pour injecter un fichier unique sans écraser le répertoire |
| ✅ | Valider la correction avec `kubectl exec` |

---

## Les 3 commandes clés à retenir pour le CKA

```bash
# 1. Logs du run précédent d'un conteneur crashé
kubectl logs <pod> -n <ns> --previous

# 2. Inspecter les volumeMounts sans kubectl describe
kubectl get pod <pod> -o jsonpath='{.spec.containers[0].volumeMounts}'

# 3. Vérifier les fichiers dans le conteneur après correction
kubectl exec <pod> -n <ns> -- ls /etc/nginx/
```

---

## La règle d'or à retenir

> **Ne jamais monter un volume ConfigMap directement sur un répertoire système d'une image officielle** (`/etc/nginx/`, `/etc/ssl/`, `/usr/share/…`) **sans `subPath`.**
>
> Le remplacement de répertoire est **silencieux** — aucun warning au déploiement, la panne n'apparaît qu'au démarrage du processus.

---

## Nettoyage de l'environnement

```
kubectl delete namespace exo2-subpath
```{{exec}}

---

## Et maintenant ?

Passez à l'exercice suivant de la formation **KubeSuccess CKA** pour continuer votre progression !
