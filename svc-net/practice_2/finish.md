<div style="background-color: rgb(225, 245, 255); border-left: 4px solid rgb(0, 130, 200); padding: 12px 16px; border-radius: 4px; margin-bottom: 16px;">
  <strong style="color: rgb(0, 80, 140);">🧠 À retenir</strong><br/>
  Le modèle réseau Kubernetes garantit par défaut une connectivité L3 totale entre tous les pods, quel que soit leur namespace ou leur nœud. Les NetworkPolicies s'appliquent <em>par-dessus</em> ce plan : dès qu'une policy sélectionne un pod, le comportement bascule vers un deny implicite pour tout flux non listé. Une policy avec <code>policyTypes: [Ingress]</code> et aucune règle <code>ingress</code> est un deny-all ingress valide et silencieux — elle ne génère aucune erreur applicative, seulement un timeout. Toujours inspecter les NetworkPolicies du namespace de <em>destination</em> avant d'explorer d'autres causes réseau.
</div>

## Questions d'autoévaluation

**1. Niveau principe**
Quel est le comportement réseau par défaut entre deux pods dans des namespaces différents, en l'absence de toute NetworkPolicy ?

**2. Niveau mécanisme**
Pourquoi une NetworkPolicy avec `policyTypes: [Ingress]` et aucune règle `ingress` se comporte-t-elle comme un deny-all, alors qu'elle ne contient aucune instruction explicite de refus ?

**3. Niveau transfert**
Dans quels autres contextes ce mécanisme de deny implicite dès qu'une policy existe s'applique-t-il — et comment une équipe sécurité peut-elle l'utiliser intentionnellement pour isoler des namespaces sensibles ?

---

## Pour aller plus loin

- **NetworkPolicies egress** : le même mécanisme s'applique au trafic sortant. Une policy `policyTypes: [Egress]` sans règle `egress` coupe tout trafic sortant du pod — utile pour confiner des workloads sensibles. → [Documentation officielle NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- **Débogage réseau avancé** : l'image `nicolaka/netshoot` embarque `tcpdump`, `nmap`, `traceroute` et `curl` — elle sert de pod de diagnostic éphémère (`kubectl run netshoot --rm -it --image=nicolaka/netshoot -- bash`) pour tracer un flux réseau pas-à-pas dans le cluster.