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
```
domain/
application/
infrastructure/
```
Les dépendances sont dirigées vers l’intérieur :
``` infrastructure → application → domain ```

Le domaine ne dépend jamais des couches externes.

---

## Conséquences

### Avantages

- forte séparation des responsabilités
- domaine indépendant des frameworks
- meilleure testabilité
- facilité de remplacement des technologies
- meilleure lisibilité de l’architecture

---

### Inconvénients

- structure de projet plus complexe
- plus de classes et d’interfaces
- nécessité de discipline architecturale

---

## Alternatives considérées

### Architecture en couches classique

Structure :
``` controller → service → repository ```

Cette approche est simple mais conduit souvent à un fort couplage
entre la logique métier et les frameworks.

Elle rend plus difficile l’évolution de l’architecture et les tests unitaires.

---

## Justification

L’architecture hexagonale a été retenue afin de :

- maintenir un domaine métier propre
- limiter les dépendances techniques
- faciliter les tests unitaires
- préparer l’évolution vers des systèmes plus distribués

Elle s’intègre également bien avec l’architecture orientée événements
mise en place dans le projet.

