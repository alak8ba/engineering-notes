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
