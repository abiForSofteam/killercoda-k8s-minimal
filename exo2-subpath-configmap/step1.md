###  Étape 1 — Observer le Pod en erreur

#### Contexte

Le Pod a été déployé dans le namespace `exo2-subpath`. Votre première mission est d'observer son état et de comprendre ce qu'il vous dit.

---

###  Objectif

Listez les Pods du namespace `exo2-subpath` et répondez mentalement à ces questions :
- Quel est le statut du Pod ?
- Combien de redémarrages a-t-il subi ?
- Le Pod a-t-il obtenu une adresse IP ?

---

###  À vous de jouer

Listez les Pods avec le maximum d'informations :

```
kubectl get pods -n exo2-subpath -o wide
```{{exec}}

---

###  Ce que vous devez comprendre

> Prenez le temps d'analyser la sortie avant de lire la suite.

<details>
<summary> Indice 1 — Que signifie CrashLoopBackOff ?</summary>

`CrashLoopBackOff` signifie que le **conteneur démarre mais se termine immédiatement** avec un code d'erreur non nul.

Le kubelet le redémarre automatiquement, mais applique un **délai exponentiel** entre chaque tentative : 10s, 20s, 40s, 80s...

Ce statut est **fondamentalement différent** de `Pending` : le Pod a été schedulé, il a une IP, l'image a été téléchargée. Le problème est **applicatif**, pas infrastructurel.

</details>

<details>
<summary> Indice 2 — CrashLoopBackOff vs Pending vs ImagePullBackOff</summary>

| Statut | Signification |
|--------------------|--------------------------------------------------|
| `Pending`          |   Pod schedulé mais conteneur pas encore démarré |
| `ImagePullBackOff` |      L'image Docker ne peut pas être téléchargée |
| `CrashLoopBackOff` | L'image est OK, le conteneur démarre mais plante |
| `Running`          | Le conteneur tourne normalement                  |

La présence d'une **adresse IP** dans la colonne `IP` confirme que le scheduling et le réseau fonctionnent — le bug est dans le processus du conteneur.

</details>

---

## ✅ Validation

Une fois que vous avez observé le statut `CrashLoopBackOff` et noté le nombre de `RESTARTS`, passez à l'étape suivante.

> 🏁 La validation se fait automatiquement dès que le Pod est détecté en CrashLoopBackOff dans le namespace.
