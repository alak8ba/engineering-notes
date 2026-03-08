# ADR-007 — Domain Events and Outbox Pattern

## Statut

Accepté

---

## Contexte

Le système Seaway repose sur une architecture orientée événements.
Les changements d'état métier doivent être publiés sous forme
d'événements Kafka afin d'alimenter différents consommateurs :

- read models
- audit
- traitements asynchrones
- autres services potentiels

Un problème classique apparaît dans ce type d'architecture :

si la base de données est mise à jour mais que la publication
de l'événement échoue, le système devient incohérent.

Exemple :

1. la transaction métier est validée en base
2. l'événement Kafka n'est pas publié
3. les consommateurs ne sont jamais informés du changement

Cette situation est appelée **dual write problem**.

---

## Décision

Le projet adopte le principe suivant :

- les changements métier produisent des **domain events**
- les événements sont enregistrés dans une **table outbox**
- un processus dédié publie les événements vers Kafka

Cette approche garantit que les événements ne sont jamais perdus
même si la publication vers Kafka échoue temporairement.

---

## Domain Events

Les événements métier représentent un changement
d'état significatif dans le domaine.

Exemples :

- SejourCreatedEvent
- SejourUpdatedEvent
- ServiceCreatedEvent
- ServiceScheduledEvent

Les événements :

- sont immuables
- portent les informations nécessaires aux consommateurs
- sont versionnés

Ils ne contiennent aucune dépendance technique.

---

## Outbox Pattern

Le pattern Outbox consiste à :

1. enregistrer l'événement dans une table `outbox`
   dans la même transaction que la modification métier
2. un processus séparé lit la table outbox
3. les événements sont publiés vers Kafka
4. les événements publiés sont marqués comme traités

Cela garantit que :

- la modification métier et l'événement sont atomiques
- les événements peuvent être rejoués en cas d'échec

---

## Architecture simplifiée

Flux typique :

1. une commande est exécutée
2. l'agrégat applique la modification métier
3. un événement de domaine est généré
4. l'événement est enregistré dans la table outbox
5. un publisher lit l'outbox et publie l'événement vers Kafka

---

## Conséquences

### Avantages

- élimine le problème du dual write
- améliore la fiabilité des événements
- permet de rejouer les événements si nécessaire
- facilite l'observabilité des flux événementiels

---

### Inconvénients

- complexité supplémentaire
- table outbox à maintenir
- nécessité d'un composant de publication

---

## Alternatives considérées

### Publication directe vers Kafka

Publier directement l'événement après la transaction
est plus simple mais expose au problème du dual write.

Cette approche a été écartée.

---

### Transaction distribuée

Utiliser une transaction distribuée entre
la base de données et Kafka n'est pas réaliste
dans la plupart des systèmes modernes.

Cette approche a été rejetée.

---

## Justification

Le pattern Outbox est une pratique reconnue
dans les architectures event-driven.

Il permet de garantir la cohérence entre
les changements métier et les événements publiés,
tout en restant compatible avec une architecture
basée sur Kafka et des services découplés.
