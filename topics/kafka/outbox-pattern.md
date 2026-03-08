# Outbox Pattern in Event-Driven Architectures

## Contexte

Dans une architecture orientée événements, un service doit souvent :

1. modifier l'état métier dans la base de données
2. publier un événement dans un broker (Kafka)

Exemple :

- création d’un séjour
- enregistrement en base
- publication d’un événement `SejourCreatedEvent`

Un problème classique apparaît alors :
```
Write DB
+
Publish Event
```


Ces deux opérations ne sont **pas atomiques**.

Si la base est mise à jour mais que la publication
de l’événement échoue, le système devient incohérent.

Ce problème est appelé :

**dual write problem**

---

# Le problème du Dual Write

Scénario possible :

1. la transaction métier est validée en base
2. le service tente de publier un événement Kafka
3. le broker Kafka est indisponible
4. l’événement n’est jamais publié

Résultat :

- la base est modifiée
- les autres services ne sont jamais informés

Le système devient incohérent.

---

# Principe du Outbox Pattern

Le **Outbox Pattern** consiste à enregistrer
les événements dans une table dédiée
dans la même transaction que la modification métier.

Flux :

1. modification métier
2. écriture de l'événement dans la table `outbox`
3. commit de la transaction
4. un processus séparé publie les événements vers Kafka

---

# Architecture

Flux simplifié :
```
Client
|
v
Application Service
|
v
Database Transaction
|
+--> Write Business Data
|
+--> Write Outbox Event
|
Commit
|
v
Outbox Publisher
|
v
Kafka
```

---

# Table Outbox

Exemple de structure :
```
outbox_events

id
aggregate_id
event_type
payload
created_at
processed
```

Le champ `processed` indique
si l'événement a déjà été publié.

---

# Publication des événements

Un composant dédié lit régulièrement
les événements de la table outbox.

Flux :

1. lire les événements non traités
2. publier l'événement dans Kafka
3. marquer l'événement comme traité

---

# Avantages

Le Outbox Pattern apporte plusieurs bénéfices :

- élimine le problème du dual write
- garantit que les événements ne sont pas perdus
- permet de rejouer les événements
- améliore la fiabilité du système

---

# Inconvénients

Le pattern introduit :

- une table supplémentaire
- un composant de publication
- une complexité légèrement supérieure

Cependant cette complexité est généralement
acceptable dans les architectures distribuées.

---

# Interaction avec d'autres patterns

Le Outbox Pattern fonctionne généralement
avec d'autres mécanismes de fiabilité :

- Retry
- Dead Letter Topics
- Idempotent Consumers

Ces patterns combinés permettent de construire
des systèmes distribués robustes.

---

# Alternatives

## Publication directe

Publier directement dans Kafka
après la transaction est plus simple
mais expose au problème du dual write.

---

## Transactions distribuées

Certaines technologies proposent
des transactions distribuées.

Cependant elles sont souvent :

- complexes
- difficiles à maintenir
- peu compatibles avec Kafka

---

# Conclusion

Le Outbox Pattern est une pratique largement
adoptée dans les architectures event-driven.

Il permet de garantir la cohérence
entre la base de données et les événements
publiés dans le système.

Associé à des mécanismes comme
Retry, DLT et Idempotence,
il constitue un pilier de la fiabilité
des systèmes distribués.
