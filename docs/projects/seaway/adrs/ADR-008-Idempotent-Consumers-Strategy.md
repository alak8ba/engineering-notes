# ADR-008 — Idempotent Consumers Strategy

## Statut

Accepté

---

## Contexte

Dans une architecture orientée événements basée sur Kafka,
les messages peuvent être livrés plusieurs fois.

Plusieurs situations peuvent provoquer une redélivrance :

- retry du consumer
- redémarrage du service
- rééquilibrage des partitions
- redelivery après un crash
- traitement manuel ou replay d'événements

Kafka garantit une livraison **at-least-once** par défaut.
Cela signifie qu'un message peut être traité plusieurs fois.

Sans protection spécifique, un consumer pourrait :

- créer des doublons
- appliquer plusieurs fois la même modification
- produire des effets de bord incohérents

Il est donc nécessaire de rendre les consommateurs **idempotents**.

---

## Décision

Les consumers Kafka du projet Seaway doivent être **idempotents**.

Le traitement d'un événement doit pouvoir être exécuté
plusieurs fois sans produire d'effet incorrect.

Chaque événement est identifié de manière unique via :

- un `eventId`
- ou une combinaison `aggregateId + version`

Les consumers doivent vérifier si un événement
a déjà été traité avant d'appliquer la modification.

---

## Principe d'idempotence

Un consumer idempotent garantit que :

si le même événement est traité plusieurs fois,
le résultat final reste identique.

Exemple :
```
Event : SejourCreatedEvent (eventId = 123)
```

Si cet événement est reçu deux fois :

1. le consumer vérifie si `eventId=123` a déjà été traité
2. si oui → l'événement est ignoré
3. sinon → l'événement est appliqué

---

## Implémentation possible

Plusieurs stratégies sont possibles.

### Table des événements traités

Une table peut stocker les `eventId` déjà traités.

Exemple :
```
processed_events

event_id
processed_at
```

Avant de traiter un événement :

1. vérifier si `eventId` existe
2. si oui → ignorer
3. sinon → traiter et enregistrer l'eventId

---

### Idempotence par état métier

Dans certains cas, l'état métier peut servir de protection.

Exemple :

- vérifier si une entité existe déjà
- vérifier la version d'un agrégat
- ignorer une modification déjà appliquée

Cette approche évite parfois une table dédiée.

---

## Interaction avec Retry et DLT

La stratégie d'idempotence fonctionne en complément de :

- retry avec backoff
- Dead Letter Topics

Flux typique :

1. un événement est reçu
2. le traitement échoue
3. retry
4. si retry échoue → DLT

Pendant les retries, l'idempotence empêche
l'application multiple d'un même événement.

---

## Conséquences

!!! tip "Avantages"

    - cohérence du système
    - tolérance aux redélivrances Kafka
    - compatibilité avec les retries
    - sécurité en cas de replay d'événements

---

!!! warning "Inconvénients"

    - complexité supplémentaire
    - gestion d'identifiants d'événements
    - stockage éventuel des événements traités

---

## Alternatives considérées

### Exactly-once semantics

Kafka propose certaines garanties "exactly-once",
mais elles ne couvrent pas tous les cas d'usage
et restent difficiles à appliquer dans des systèmes
distribués complets.

Cette approche n'a pas été retenue comme mécanisme principal.

---

### Ignorer le problème

Ignorer les redélivrances peut provoquer :

- incohérences métier
- duplication de données
- effets de bord imprévisibles

Cette approche a été rejetée.

---

## Justification

Dans un système distribué basé sur Kafka,
l'idempotence des consommateurs est une pratique essentielle.

Elle garantit que le système reste cohérent
même en présence de retries, de redémarrages
ou de relecture d'événements.
