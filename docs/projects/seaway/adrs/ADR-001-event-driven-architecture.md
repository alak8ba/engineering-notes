
# ADR-001 — Adoption d'une architecture orientée événements

## Statut

Accepté

---

## Contexte

Le système Seaway nécessite un mécanisme permettant
de découpler les différentes parties de l'application
et de faciliter l'évolution du système dans le temps.

Une architecture orientée événements permet de
séparer les producteurs et les consommateurs,
tout en améliorant la traçabilité et la résilience.

---

## Décision

Le projet adopte une architecture orientée événements
avec Kafka comme bus d'événements.

Les événements métier sont publiés par le write model
et consommés par différents composants :

- read models
- audit
- traitements asynchrones

---

## Conséquences

!!! tip "Avantages"

    - découplage entre composants
    - meilleure évolutivité
    - traitement asynchrone
    - possibilité d'ajouter de nouveaux consommateurs

!!! warning "Inconvénients"

    - complexité accrue
    - gestion des retries
    - gestion des doublons

!!! note "Ces problématiques sont traitées via"

    - idempotence
    - retry avec backoff
    - Dead Letter Topics
