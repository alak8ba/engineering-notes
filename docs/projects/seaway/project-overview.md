# Seaway — Project Overview

!!! note  ""
	
    This documentation presents the architectural principles  and engineering practices used in the project.  
	  
	Operational details and internal infrastructure configurations are intentionally omitted.

Projet backend / frontend conçu dans le cadre d’une collaboration
technique autour d’architectures modernes orientées événements.

---

## Contexte

Seaway est un système backend / frontend conçu pour explorer
et mettre en œuvre une architecture orientée événements basée
sur Spring Boot, Kafka et une architecture hexagonale.

Le projet vise à construire une base applicative robuste et
évolutive tout en appliquant des pratiques d’ingénierie proches
d’un environnement de production.

---

## Objectifs du projet

Les objectifs principaux de Seaway sont les suivants :

- construire un backend moderne orienté événements
- expérimenter une architecture hexagonale
- mettre en place une séparation claire entre write model et read model
- travailler avec Kafka dans un contexte métier réaliste
- améliorer la fiabilité via retry, idempotence et DLT
- mettre en place une base de tests sérieuse
- préparer un déploiement réaliste avec Docker
- documenter les décisions techniques et les apprentissages

Le projet sert aussi de base pour structurer une documentation
d’ingénierie réutilisable, potentiellement transformable plus tard
en articles, documentation publique ou ebook technique.

---

## Vision globale

Seaway a été conçu comme un projet d’apprentissage avancé,
mais avec une posture volontairement proche d’un contexte réel.

Le projet couvre plusieurs dimensions :

- architecture backend
- event-driven design
- persistance
- qualité logicielle
- frontend moderne
- déploiement
- sécurité
- CI/CD
- documentation technique

Cette approche permet de travailler non seulement le code,
mais aussi la capacité à penser un système dans son ensemble.

---

## Stack technique

### Backend

- Java 21
- Spring Boot 3
- Spring Data JPA
- Spring Security

### Messaging

- Kafka

### Persistence

- PostgreSQL
- H2 pour certains environnements de développement initiaux
- JSONB, enums, dates
- scripts SQL d’initialisation

### Frontend

- React
- Vite
- TypeScript
- Tailwind CSS

### Infrastructure

- Docker
- Docker Compose
- Nginx
- Certbot
- UFW

### Qualité / Tests

- JUnit
- Spring Boot Test
- @WebMvcTest
- Embedded Kafka
- Testcontainers

### CI/CD

- GitHub Actions
- GHCR
- Watchtower

---

## Architecture backend

Le backend suit une architecture hexagonale avec séparation claire entre :

- domain
- application
- infrastructure

Le domaine porte les règles métier.
L’application orchestre les cas d’usage.
L’infrastructure implémente les détails techniques.

Cette séparation permet :

- une meilleure testabilité
- une meilleure lisibilité
- un découplage entre métier et technique
- une base plus saine pour faire évoluer le projet

Le système suit également une approche event-driven,
avec Kafka comme bus d’événements métier.

---

## Event-driven architecture

Seaway utilise Kafka pour transporter des événements métier.

Exemples :

- Created
- Updated
- Cancelled
- autres événements liés aux évolutions des agrégats

Cette architecture a permis de travailler des sujets importants comme :

- découplage
- publication d’événements
- retry
- backoff
- Dead Letter Topics
- idempotence
- audit événementiel

Une attention particulière a été portée à la résilience du traitement,
afin d’éviter qu’un message en erreur ne bloque tout le flux.

---

## CQRS léger

Le projet applique une forme légère de CQRS :

- un write model pour les opérations métier
- un read model pour la consultation

Le read model est principalement utilisé pour l’interface utilisateur,
afin d’optimiser l’affichage et simplifier certaines lectures côté frontend.

Cette séparation a permis de mieux comprendre :

- la différence entre écriture métier et lecture
- les compromis de duplication contrôlée
- l’intérêt d’un modèle adapté à l’usage

---

## Audit événementiel

Les événements métier sont persistés pour constituer
une base de vérité fonctionnelle et permettre :

- la traçabilité
- l’analyse
- la compréhension de l’historique
- l’audit des changements

Cette démarche renforce la lisibilité du système et prépare
des usages futurs autour de l’observabilité et du diagnostic.

---

## Frontend

Le frontend de Seaway est développé avec :

- React
- Vite
- TypeScript
- Tailwind CSS

L’interface est orientée dashboard / monitoring.

Fonctionnalités principales déjà travaillées :

- liste des séjours via le read model
- détail d’un séjour
- création / mise à jour
- amélioration progressive de l’UI / UX
- structuration d’un design system à base de tokens CSS

Une tentative d’intégration SSE a été faite pour afficher
des événements en temps réel. La partie backend était fonctionnelle,
mais l’intégration frontend a été abandonnée temporairement
par pragmatisme.

---

## Qualité et tests

Le projet a permis de mettre en place progressivement :

- des tests unitaires
- des tests de contrôleurs avec @WebMvcTest
- des tests Kafka
- des tests d’intégration avec Testcontainers

De nombreux problèmes réels ont été rencontrés et traités, notamment :

- conflits de beans Spring
- problèmes de profils
- sérialisation Jackson
- binding Kafka
- backoff mal configuré
- incompatibilités H2 / PostgreSQL
- environnement Docker non reconnu par Testcontainers

Le projet a donc servi de terrain concret pour développer
une démarche de debug structurée et persévérante.

---

## Déploiement et environnement

Le projet est conteneurisé avec Docker et Docker Compose.

Services principaux :

- backend
- frontend
- PostgreSQL
- Kafka
- Zookeeper

Des outils annexes ont aussi été utilisés selon les besoins :

- pgAdmin / Adminer
- Kafka UI

Le projet a progressivement évolué vers une préparation sérieuse
à la production, avec une attention portée à :

- la séparation des environnements
- la sécurité des containers
- la cohérence de la configuration
- la reproductibilité

---

## CI/CD

La partie CI/CD a été mise en place dans une logique réaliste :

- GitHub Actions pour la CI
- build des images Docker
- publication vers GHCR
- déploiement pull-based
- mise à jour automatique via Watchtower

Des principes importants ont été retenus :

- séparation entre CI, release et déploiement
- artefacts immuables
- production qui consomme des images mais ne build jamais
- déploiement volontaire et contrôlé
- sécurité cohérente avec une infra HTTPS-only

Le sujet CI/CD n’est donc plus seulement “à venir” :
il fait maintenant partie intégrante du projet.

---

## Sécurité

Le projet a aussi intégré une réflexion sécurité, avec notamment :

- Spring Security en mode stateless
- désactivation de CSRF pour l’API REST
- reverse proxy Nginx
- HTTPS avec Let’s Encrypt
- headers de sécurité
- user non-root dans les containers
- filesystem read-only
- services internes non exposés publiquement
- UFW avec politique restrictive

Cette partie a contribué à faire évoluer le projet
d’un simple prototype vers une base beaucoup plus crédible.

---

## Démarche d’ingénierie

Au-delà des technologies, Seaway représente une démarche :

- construire
- tester
- comprendre
- corriger
- documenter
- améliorer

Le projet a été mené avec une logique de progression réelle,
en traitant les problèmes au fur et à mesure, sans chercher
à masquer la complexité.

Il sert aujourd’hui à la fois :

- de preuve de compétences
- de base de documentation
- de support d’apprentissage
- de fondation pour de futurs contenus techniques

---

## Résultat global

Seaway est un projet cohérent, ambitieux et réaliste,
qui a permis de développer des compétences transverses en :

- backend avancé
- architecture
- messaging
- qualité
- frontend moderne
- sécurité
- déploiement
- CI/CD

Le projet est désormais dans une phase de consolidation continue,
avec des axes d’amélioration possibles sur :

- observabilité
- monitoring
- authentification future
- approfondissement DDD
- enrichissement métier

---

## Documentation détaillée

Certaines dimensions du projet sont détaillées dans des notes dédiées :

- `architecture-overview.md`
- `ci-cd-overview.md`
- `security-overview.md`

D’autres notes pourront être ajoutées ensuite, par exemple sur :

- Kafka / DLT
- tests d’intégration
- design system frontend
- décisions d’architecture
- agrégats métier

## Contexte de collaboration

Le projet a été mené en collaboration avec une société
spécialisée dans le développement de solutions SaaS.

Cette collaboration a permis de confronter les choix
techniques à des contraintes proches d’un environnement
professionnel réel, notamment en matière de :

- architecture
- fiabilité
- déploiement
- sécurité
- organisation du code
