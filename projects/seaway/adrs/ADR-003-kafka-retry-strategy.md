# ADR-003 — Kafka Retry and Dead Letter Strategy

## Statut

Accepté

---

## Contexte

Dans une architecture orientée événements, les consommateurs Kafka
doivent être capables de traiter des messages de manière fiable.

Cependant, plusieurs types d'erreurs peuvent survenir lors du traitement :

- erreurs transitoires (base de données temporairement indisponible)
- erreurs de sérialisation
- erreurs métier inattendues
- problèmes d'infrastructure

Sans stratégie de gestion des erreurs, un message en échec peut bloquer
le consumer et empêcher le traitement des messages suivants.

Il est donc nécessaire de mettre en place un mécanisme permettant :

- de réessayer le traitement des messages en erreur
- d’éviter les boucles infinies de retry
- d’isoler les messages définitivement invalides

---

## Décision

Le projet adopte une stratégie basée sur :

- retry avec backoff
- Dead Letter Topics (DLT)
- idempotence côté consommateur

Le mécanisme est implémenté avec le `DefaultErrorHandler`
de Spring Kafka et un `DeadLetterPublishingRecoverer`.

---

## Fonctionnement

Lorsqu'un message échoue :

1. le consumer tente de traiter le message
2. en cas d'erreur, un retry est effectué avec backoff
3. après un nombre maximal de tentatives, le message est envoyé
   dans un Dead Letter Topic

Le message est alors considéré comme non traitable
et isolé dans le DLT pour analyse.

---

## Dead Letter Topics

Chaque topic principal possède un topic associé :
``` <topic>.DLT ```
Exemple :
```
seaway.events
seaway.events.DLT
```


Les messages envoyés dans le DLT peuvent être :

- analysés
- rejoués
- corrigés manuellement si nécessaire

---

## Gestion de l'idempotence

Dans un système distribué, il est possible que certains messages
soient traités plusieurs fois.

Pour éviter les effets de bord :

- les consommateurs doivent être idempotents
- les opérations critiques doivent vérifier l'état existant
  avant d'appliquer une modification

Cette approche garantit la cohérence du système
même en présence de retries ou de redéliveries.

---

## Conséquences

### Avantages

- résilience du système
- aucun blocage du consumer
- isolation des messages invalides
- meilleure observabilité des erreurs

---

### Inconvénients

- complexité supplémentaire
- gestion nécessaire des messages en DLT
- nécessité d'idempotence côté métier

---

## Alternatives considérées

### Retry infini

Cette approche peut bloquer un consumer
si un message est définitivement invalide.

Elle a été écartée.

---

### Ignorer les erreurs

Ignorer les erreurs provoquerait une perte
silencieuse de messages, ce qui est inacceptable
dans un système orienté événements.

---

## Justification

La combinaison :

- retry limité
- backoff
- Dead Letter Topics

constitue une pratique courante dans les architectures
basées sur Kafka.

Elle permet de concilier fiabilité, résilience
et capacité d’analyse des erreurs.
