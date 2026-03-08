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

-L'utilisateur accède à l'application via le frontend React.

-Nginx sert de reverse proxy et gère HTTPS.

-Le backend Spring Boot traite les requêtes.

-PostgreSQL stocke les données métier.

-Kafka transporte les événements du système.
