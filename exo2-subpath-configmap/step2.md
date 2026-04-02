###  Étape 2 — Lire les logs du conteneur

#### Contexte

Vous avez confirmé que le Pod est en `CrashLoopBackOff`. La prochaine étape **réflexe** en CKA : **lire les logs**. Ils contiennent le message d'erreur exact produit par nginx au moment du crash.

---

##  Attention — Conteneur déjà redémarré

Quand un conteneur est en `CrashLoopBackOff`, il peut déjà avoir été redémarré plusieurs fois. La commande `kubectl logs` affiche les logs du **run actuel**, mais si le conteneur est déjà redémarré, vous devez ajouter `--previous`.

---

##  À vous de jouer

**Tentez d'abord les logs du conteneur actuel :**

```
kubectl logs nginx-subpath -n exo2-subpath
```{{exec}}

**Si le conteneur a déjà redémarré, utilisez `--previous` :**

```
kubectl logs nginx-subpath -n exo2-subpath --previous
```{{exec}}

---

##  Ce que vous devez trouver

> Lisez le message d'erreur affiché. Quel fichier nginx ne trouve-t-il pas ?

<details>
<summary> Indice 1 — Je ne vois pas de logs</summary>

Si `kubectl logs` ne retourne rien, c'est que le conteneur vient de redémarrer et n'a pas encore écrit de logs. Attendez quelques secondes et relancez avec `--previous` pour voir les logs du run précédent.

</details>

<details>
<summary> Indice 2 — Analyser le message d'erreur</summary>

Vous devriez voir quelque chose comme :

```
nginx: [emerg] open() "/etc/nginx/mime.types" failed (2: No such file or directory)
nginx: configuration file /etc/nginx/nginx.conf test failed
```

**Décomposons ce message :**
- `[emerg]` = erreur fatale, nginx s'arrête immédiatement
- `open() "..." failed (2: No such file or directory)` = le fichier n'existe pas
- nginx cherche `mime.types` dans `/etc/nginx/` — ce fichier fait partie de l'image nginx de base

La question est : **pourquoi ce fichier a-t-il disparu ?**

</details>

<details>
<summary> Indice 3 — Pourquoi mime.types a disparu</summary>

Le fichier `mime.types` est normalement fourni par **l'image nginx:1.27** dans `/etc/nginx/`.

Mais quelque chose a **remplacé** le contenu de ce répertoire. Réfléchissez : qu'est-ce qui a été monté dans `/etc/nginx/` dans la configuration du Pod ?

→ Allez voir la configuration du volume dans l'étape suivante.

</details>

---

##  Retenez cette commande

> `kubectl logs <pod> -n <ns> --previous` est **indispensable** face à un CrashLoopBackOff.
> C'est la première commande à exécuter après `kubectl get pods`. Mémorisez-la pour le CKA.

---

## ✅ Validation

Vous avez identifié que nginx cherche `mime.types` et ne le trouve pas dans `/etc/nginx/`. Passez à l'étape 3 pour comprendre pourquoi.
