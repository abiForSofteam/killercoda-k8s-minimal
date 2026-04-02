# 🔧 CrashLoopBackOff — ConfigMap & subPath

## Bienvenue dans cet exercice CKA

---

### Votre mission

Un développeur de l'équipe plateforme vient de vous contacter en urgence :

> *"Mon Pod nginx est en CrashLoopBackOff dès le démarrage. J'ai injecté un fichier de config via une ConfigMap, mais nginx ne tourne pas. Je ne comprends pas ce qui se passe."*

**Vous êtes l'administrateur du cluster. À vous de jouer.**

---

### Ce qui a été déployé pour vous

| Ressource | Nom                 | Namespace      |
|-----------|---------------------|----------------|
| Pod       | `nginx-subpath`     | `exo2-subpath` |
| ConfigMap | `nginx-custom-conf` | `exo2-subpath` |

---

### Plan de l'exercice

Vous allez suivre la méthode de diagnostic CKA en 4 étapes :

1. **Observer** — Identifier le statut du Pod et comprendre ce qu'il indique
2. **Investiguer** — Lire les logs pour trouver l'erreur exacte
3. **Diagnostiquer** — Identifier le champ manquant dans la configuration
4. **Corriger** — Appliquer le fix et valider que le Pod est Running

---

### Temps estimé

| Profil            |    Durée  |
|-------------------|-----------|
|   Préparation CKA |    12 min |
| Première approche | 25–35 min |

---

### Rappel important

> Chaque étape dispose d'indices progressifs si vous êtes bloqué.
> Consultez-les **uniquement** après avoir cherché par vous-même — c'est ainsi qu'on progresse vraiment.

---

**Bonne chance ! Commencez l'étape 1 →**
