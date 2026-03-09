# Seaway — Architecture Overview

!!! note  ""

	This documentation presents the architectural principles  and engineering practices used in the project.  
	  
	Operational details and internal infrastructure configurations are intentionally omitted.
## Contexte général

Seaway est un projet backend / frontend développé from scratch.
L'objectif était de construire un système réaliste permettant
d'expérimenter des architectures backend modernes et des pratiques
de développement proches d'un environnement de production.

Le projet sert à la fois :

- de terrain d'apprentissage avancé
- de démonstration de compétences techniques
- de base pour documenter des décisions d'architecture

---

## Architecture Backend

### Stack

- Java 21
- Spring Boot
- Spring Data JPA
- Kafka
- PostgreSQL

### Architecture hexagonale

Le backend suit une architecture hexagonale avec séparation claire :

domain  
application  
infrastructure

Utilisation de ports et adapters pour isoler le domaine des
dépendances techniques.

---

## Event-Driven Architecture

Kafka est utilisé comme bus d'événements.

Le système produit des événements métier comme :

- EntityCreated
- EntityUpdated
- EntityDeleted

Objectifs :

- découplage des composants
- traçabilité
- possibilité d'évolution vers des microservices

### Fiabilité

Plusieurs mécanismes ont été implémentés :

- idempotence pour éviter les doublons
- retry avec backoff
- Dead Letter Topics (DLT)

---

## CQRS léger

Séparation entre :

write model  
read model

Le read model est optimisé pour la consultation par l'interface utilisateur.

---

## Audit événementiel

Les événements produits sont persistés afin de permettre :

- traçabilité des actions
- reconstitution d'état
- analyse ultérieure

---

## Persistence

Base de données : PostgreSQL

Gestion de types avancés :

- JSONB
- enums
- dates

Scripts SQL d'initialisation utilisés pour préparer l'environnement.

---

## Sécurité

Mise en place de :

- Spring Security
- reverse proxy via Nginx

---

## Frontend

Stack :

- React
- Vite
- TypeScript
- Tailwind

Interface orientée dashboard.

Fonctionnalités :

- liste des séjours
- détail séjour
- création / modification

Une tentative d'intégration SSE pour le temps réel a été réalisée côté backend,
mais abandonnée temporairement côté frontend pour des raisons pragmatiques.

---

## Tests & Qualité

Tests mis en place progressivement :

- tests unitaires
- @WebMvcTest pour les contrôleurs
- tests Kafka

Outils :

- Embedded Kafka
- Testcontainers

---

## Déploiement

Environnement conteneurisé :

Docker  
Docker Compose

Services :

- backend
- PostgreSQL
- Kafka

Gestion de profils Spring :

dev → H2  
postgres → PostgreSQL

---

## Améliorations en cours

Plusieurs axes d'amélioration ont été identifiés :

- mise en place d'un pipeline CI/CD
- build automatisé
- push d'images Docker
- séparation claire des environnements

Ces sujets feront l'objet d'une phase de consolidation.

---

## Objectif du projet

Ce projet vise à développer des compétences avancées en :

- architecture backend
- systèmes distribués
- messaging
- fiabilité
- déploiement

L'objectif à long terme est de consolider un niveau
d'ingénieur backend senior.
