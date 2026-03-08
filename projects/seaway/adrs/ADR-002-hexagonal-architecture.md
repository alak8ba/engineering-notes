# ADR-002 — Adoption de l'architecture hexagonale

## Statut

Accepté

---

## Contexte

Le projet Seaway nécessite une architecture permettant :

- une séparation claire entre la logique métier et les détails techniques
- une testabilité élevée
- une capacité d’évolution du système sans dépendances fortes aux frameworks
- une meilleure maintenabilité du code

Dans les architectures traditionnelles, la logique métier devient souvent
fortement couplée aux frameworks (Spring, JPA, HTTP, etc.), ce qui rend
les tests, la maintenance et les évolutions plus difficiles.

Une architecture hexagonale (Ports & Adapters) permet de placer le domaine
au centre du système et d’isoler les dépendances techniques en périphérie.

---

## Décision

Le projet adopte une architecture hexagonale structurée en trois couches principales :

### Domain

Le domaine contient :

- les entités métier
- les agrégats
- les règles métier
- les événements de domaine
- les exceptions métier

Le domaine ne dépend d'aucun framework.

---

### Application

La couche application orchestre les cas d’usage.

Responsabilités :

- exécution des use cases
- coordination entre domaine et infrastructure
- gestion des transactions
- publication d’événements

Elle utilise des **ports** pour communiquer avec l’infrastructure.

---

### Infrastructure

La couche infrastructure implémente les **adapters** techniques.

Exemples :

- repositories JPA
- configuration Spring
- consommateurs Kafka
- publication d’événements
- API REST

Cette couche dépend des frameworks et des technologies.

---

## Structure typique

Le projet est organisé de la manière suivante :
