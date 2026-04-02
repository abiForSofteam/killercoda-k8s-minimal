# 🧠 Étape 3 — Diagnostiquer la mauvaise configuration

## Contexte

Vous savez que nginx ne trouve plus `mime.types` dans `/etc/nginx/`. Ce fichier est pourtant présent dans l'image `nginx:1.27`. Il a donc été **écrasé** par quelque chose.

Inspectez la configuration du Pod pour trouver le coupable.

---

## 🔬 À vous de jouer

**Inspectez la définition complète du Pod :**

```
kubectl get pod nginx-subpath -n exo2-subpath -o yaml
```{{exec}}

> Concentrez-vous sur les sections `volumes` et `volumeMounts`.

**Ou ciblez directement les volumeMounts :**

```
kubectl get pod nginx-subpath -n exo2-subpath \
  -o jsonpath='{.spec.containers[0].volumeMounts}' | python3 -m json.tool
```{{exec}}

---

## 📖 Ce que vous devez trouver

> Regardez le `mountPath` du `volumeMount`. Où est-il monté ? Quel champ important est absent ?

<details>
<summary>💡 Indice 1 — Que chercher dans volumeMounts</summary>

Dans la section `volumeMounts`, cherchez ces champs :
- `mountPath` : où le volume est monté dans le conteneur
- `subPath` : quel fichier précis du volume est monté (peut être absent !)

Si `mountPath` pointe sur **un répertoire** et que `subPath` est absent, Kubernetes monte **l'intégralité du volume** à cet endroit.

</details>

<details>
<summary>💡 Indice 2 — Effet d'un montage sans subPath</summary>

Sans `subPath`, monter un volume ConfigMap sur `/etc/nginx/` **remplace intégralement** le contenu de ce répertoire par les fichiers de la ConfigMap.

La ConfigMap `nginx-custom-conf` ne contient qu'une seule clé : `nginx.conf`.

Résultat : après le montage, `/etc/nginx/` ne contient **que** `nginx.conf` — tous les autres fichiers (`mime.types`, `fastcgi_params`, `conf.d/`) issus de l'image ont disparu.

</details>

<details>
<summary>💡 Indice 3 — L'analogie pour bien comprendre</summary>

Monter un volume sur `/etc/nginx/` sans `subPath`, c'est comme vider entièrement une pièce pour y déposer un seul carton. Le carton (votre ConfigMap) est là, mais tout ce qui était dans la pièce avant a disparu.

Avec `subPath`, on pose uniquement le carton **à l'endroit précis prévu**, sans toucher au reste du contenu de la pièce.

**Le champ manquant est donc :** `subPath: nginx.conf`

</details>

---

## 🔎 Pour aller plus loin — Variantes de pannes

| Configuration | Symptôme |
|---------------|----------|
| Pas de `subPath`, montage sur répertoire | `CrashLoopBackOff` — fichiers de l'image écrasés |
| `subPath` avec clé inexistante dans ConfigMap | Pod `Pending` — événement `MountVolume.SetUp failed` |
| `mountPath` sur fichier sans `subPath` | Refus à l'admission — Pod jamais créé |

---

## ✅ Validation

Confirmez que vous avez identifié l'absence du champ `subPath` dans le `volumeMount` du Pod. C'est la cause racine du crash.

Passez à l'étape 4 pour corriger !
