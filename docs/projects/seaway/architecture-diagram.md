# Seaway — Architecture Diagrams

Ce document présente les principaux diagrammes d’architecture
du système Seaway.

Les diagrammes permettent de comprendre rapidement :

- la structure globale du système
- le flux des événements
- le fonctionnement de l'authentification
- le déploiement de l'application

---

# 1 — Architecture globale

```mermaid
flowchart LR

User[Utilisateur]

Frontend[React Frontend]
Nginx[Nginx Reverse Proxy]
Backend[Spring Boot API]

DB[(PostgreSQL)]
Kafka[(Kafka)]

User --> Frontend
Frontend --> Nginx
Nginx --> Backend

Backend --> DB
Backend --> Kafka

Kafka --> Backend
```
Description :
- L'utilisateur accède à l'application via le frontend React.
- Nginx sert de reverse proxy et gère HTTPS.
- Le backend Spring Boot traite les requêtes.
- PostgreSQL stocke les données métier.
- Kafka transporte les événements du système.

# 2 — Flux Event-Driven
```mermaid
sequenceDiagram

participant Client
participant API
participant Domain
participant Outbox
participant Kafka
participant Consumer
participant ReadModel

Client->>API: Commande métier
API->>Domain: Application du use case
Domain->>Outbox: Enregistrement événement
Outbox->>Kafka: Publication événement
Kafka->>Consumer: Consommation événement
Consumer->>ReadModel: Mise à jour read model
```
Description :
1. une commande est envoyée à l'API
2. le domaine applique la logique métier
3. un événement est généré
4. l'événement est enregistré dans l'outbox
5. l'événement est publié dans Kafka
6. les consumers mettent à jour les read models

# 3 — Flux d’authentification JWT
```mermaid
sequenceDiagram

participant User
participant Frontend
participant Backend
participant DB

User->>Frontend: Login
Frontend->>Backend: POST /auth/login
Backend->>DB: Vérification utilisateur
Backend->>Frontend: Access Token + Refresh Token

Frontend->>Backend: GET /auth/me
Backend->>Frontend: Données utilisateur

Frontend->>Backend: POST /auth/refresh
Backend->>Frontend: Nouveau Access Token
```

Description :

1. l'utilisateur se connecte
2. le backend génère un access token et un refresh token
3. les tokens sont stockés dans des cookies HttpOnly
4. le frontend utilise `/auth/me` pour récupérer l'utilisateur
5. si le token expire, un refresh est effectué automatiquement

# 4 — Architecture CI/CD
```mermaid
flowchart LR

Dev[Developer]
GitHub[GitHub Repo]
CI[GitHub Actions]
Registry[GHCR Registry]
Server[Production Server]
Watchtower[Watchtower]

Dev --> GitHub
GitHub --> CI
CI --> Registry
Server --> Registry
Watchtower --> Server
```

Description :
1. le développeur pousse le code sur GitHub
2. GitHub Actions exécute la CI
3. les images Docker sont construites
4. les images sont publiées dans GHCR
5. le serveur récupère les nouvelles images
6. Watchtower redéploie automatiquement les containers

# Résumé de l'architecture

Le système Seaway repose sur plusieurs principes clés :
- architecture hexagonale
- event-driven architecture
- CQRS léger
- API stateless avec JWT
- déploiement conteneurisé
- CI/CD automatisé

Cette architecture permet :
- une forte modularité
- une bonne résilience
- une évolution progressive du système
