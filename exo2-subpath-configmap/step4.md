# ✅ Étape 4 — Corriger et valider

## Contexte

Vous avez diagnostiqué le problème : le `volumeMount` monte l'intégralité de la ConfigMap sur `/etc/nginx/` sans `subPath`, écrasant tous les fichiers de l'image nginx.

La correction consiste à :
1. Supprimer le Pod défectueux
2. Le recréer avec `subPath: nginx.conf` et `mountPath: /etc/nginx/nginx.conf`

---

##  Étape 4.1 — Supprimer le Pod défectueux

```
kubectl delete pod nginx-subpath -n exo2-subpath
```{{exec}}

---

##  Étape 4.2 — Appliquer le manifeste corrigé

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-subpath
  namespace: exo2-subpath
spec:
  containers:
  - name: nginx
    image: nginx:1.27
    volumeMounts:
    - name: nginx-config-vol
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf
      readOnly: true
  volumes:
  - name: nginx-config-vol
    configMap:
      name: nginx-custom-conf
EOF
```{{exec}}

---

##  Étape 4.3 — Surveiller le Pod en temps réel

```
kubectl get pod nginx-subpath -n exo2-subpath -w
```{{exec}}

> Attendez de voir `Running` avec `READY 1/1` et `RESTARTS 0`. Appuyez sur `Ctrl+C` pour quitter.

---

##  Étape 4.4 — Vérifier que les fichiers de l'image sont préservés

```
kubectl exec nginx-subpath -n exo2-subpath -- ls /etc/nginx/
```{{exec}}

> Vous devez voir : `conf.d  fastcgi_params  mime.types  nginx.conf  ...`
> Tous les fichiers de l'image sont présents, **et** votre `nginx.conf` de la ConfigMap est là.

**Vérifiez que le nginx.conf injecté est bien celui de la ConfigMap :**

```
kubectl exec nginx-subpath -n exo2-subpath -- cat /etc/nginx/nginx.conf | head -5
```{{exec}}

---

##  Ce que vous venez de faire

|            Avant                     |                             Après                             |
|--------------------------------------|---------------------------------------------------------------|
|      `mountPath: /etc/nginx/`        |           `mountPath: /etc/nginx/nginx.conf`                  |
|             Pas de `subPath`         |           `subPath: nginx.conf`                               |
| Tous les fichiers de l'image écrasés |            Seul `nginx.conf` est injecté                      |
|         `CrashLoopBackOff`.          |            `Running`                                          |

---

<details>
<summary>💡 Pourquoi changer aussi mountPath ?</summary>

Avec `subPath`, vous ne montez plus **un répertoire** mais **un fichier unique**. Le `mountPath` doit donc pointer vers le **chemin complet du fichier** dans le conteneur (`/etc/nginx/nginx.conf`), et non plus vers le répertoire parent (`/etc/nginx/`).

`subPath` désigne la **clé dans le volume** (le nom dans la ConfigMap), `mountPath` désigne le **fichier cible dans le conteneur**.

</details>

---

## ✅ Validation finale

Le scénario est validé si :
- Le Pod est en `Running` avec `READY 1/1`
- `RESTARTS` est à `0`
- `ls /etc/nginx/` montre `mime.types`, `conf.d/`, `fastcgi_params` **et** `nginx.conf`
