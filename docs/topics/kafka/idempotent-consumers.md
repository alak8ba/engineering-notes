# Idempotent Consumers in Event-Driven Systems

## Contexte

Dans un système basé sur Kafka, un message peut être livré
plusieurs fois au consommateur.

Kafka garantit par défaut une livraison **at-least-once**,
ce qui signifie qu’un message peut être traité plusieurs fois.

Plusieurs situations peuvent provoquer une redélivrance :

- retry du consumer
- redémarrage du service
- crash du consumer
- rééquilibrage des partitions
- replay d’événements
- erreurs de commit d’offset

Sans protection spécifique, un consumer peut appliquer
plusieurs fois la même opération.

Cela peut provoquer :

- des doublons
- des incohérences métier
- des effets de bord indésirables

Pour éviter ces problèmes, les consommateurs doivent être
**idempotents**.

---

# Définition

Une opération est **idempotente** si son exécution
plusieurs fois produit le même résultat que
son exécution une seule fois.

Exemple :
```
traiter(eventId=123)
traiter(eventId=123)
traiter(eventId=123)
```

Le résultat final doit rester identique.

---

# Pourquoi l'idempotence est essentielle

Dans un système distribué, plusieurs mécanismes
peuvent provoquer des redélivrances :

- retry automatique
- réexécution d'événements
- duplication réseau
- reprise après crash

L'idempotence permet de garantir
la cohérence du système malgré ces situations.

---

# Stratégies d’implémentation

Plusieurs approches peuvent être utilisées.

---

## 1 — Table des événements traités

Une stratégie consiste à enregistrer
les identifiants des événements déjà traités.

Exemple de table :
```
processed_events

event_id
processed_at
```

Flux de traitement :

1. vérifier si `event_id` existe
2. si oui → ignorer l’événement
3. sinon → traiter et enregistrer l’événement

Cette approche est simple et fiable.

---

## 2 — Vérification de l’état métier

Dans certains cas, le modèle métier
permet déjà de détecter les doublons.

Exemple :

- vérifier si une entité existe déjà
- vérifier la version d’un agrégat
- vérifier l’état actuel avant modification

Exemple :
``` java
if (sejour.exists(id)) {
ignore event
}
```

---

## 3 — Versionnement des agrégats

Dans une architecture orientée événements,
chaque agrégat peut posséder une version.

Un événement contient :
```
aggregate_id
version
```

Si la version reçue est déjà appliquée,
l’événement est ignoré.

---

# Interaction avec Retry et DLT

L'idempotence fonctionne en complément
du mécanisme Retry + Dead Letter Topic.

Flux typique :

1. un message est consommé
2. une erreur se produit
3. retry du message
4. le message est traité plusieurs fois
5. l'idempotence empêche les effets de bord

Sans idempotence, les retries
peuvent provoquer des incohérences.

---

# Bonnes pratiques

Pour construire des consumers robustes :

- inclure un `eventId` unique dans les événements
- éviter les effets de bord non contrôlés
- rendre les opérations métier idempotentes
- combiner idempotence + retry + DLT
- surveiller les événements du DLT

---

# Exemple simplifié

Pseudo-code :
``` java
if processedEvents.contains(eventId):
return

process(event)

processedEvents.save(eventId)
```

---

# Conclusion

Dans les architectures event-driven,
les redélivrances sont normales.

Les consumers doivent être conçus
pour gérer ces situations.

L’idempotence est un principe clé
pour garantir la cohérence
des systèmes distribués.

