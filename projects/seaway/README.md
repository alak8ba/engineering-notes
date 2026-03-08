# Seaway — Engineering Notes

Projet backend / frontend conçu dans le cadre d’une collaboration
technique autour d’architectures modernes orientées événements.

Ces notes documentent l’architecture, les décisions techniques
et les aspects d’infrastructure du projet SEAWAY.

---

# Vue d’ensemble

- [Project Overview](project-overview.md)
- [Architecture Overview](architecture-overview.md)
- [Architecture Diagrams](architecture-diagram.md)
- [CI/CD Overview](ci-cd-overview.md)
- [Security Overview](security-overview.md)

---

# Architecture Decision Records (ADR)

Les décisions d’architecture importantes sont documentées
dans le dossier `adrs/`.

## Liste des ADR

- [ADR-001 — Event Driven Architecture](adrs/ADR-001-event-driven-architecture.md)
- [ADR-002 — Hexagonal Architecture](adrs/ADR-002-hexagonal-architecture.md)
- [ADR-003 — Kafka Retry Strategy](adrs/ADR-003-kafka-retry-strategy.md)
- [ADR-004 — Testcontainers for Integration Tests](adrs/ADR-004-testcontainers-for-integration-tests.md)
- [ADR-005 — Pull-based Deployment with Watchtower](adrs/ADR-005-pull-based-deployment-with-watchtower.md)
- [ADR-006 — CQRS Read Model Strategy](adrs/ADR-006-cqrs-read-model-strategy.md)
- [ADR-007 — Domain Events and Outbox Pattern](adrs/ADR-007-domain-events-and-outbox-pattern.md)
- [ADR-008 — Idempotent Consumers Strategy](adrs/ADR-008-idempotent-consumers-strategy.md)
- [ADR-009 — API Streaming Strategy](adrs/ADR-009-api-streaming-strategy.md)
- [ADR-010 — Container Security Strategy](adrs/ADR-010-container-security-strategy.md)
- [ADR-011 — JWT Authentication Strategy](adrs/ADR-011-jwt-authentication-strategy.md)
- [ADR-012 — RBAC Authorization Model](adrs/ADR-012-rbac-authorization-model.md)

---

# Architecture principale

Le projet SEAWAY repose sur plusieurs principes d’architecture :

- architecture hexagonale (Ports / Adapters)
- event-driven architecture
- CQRS léger (write model / read model)
- API REST stateless
- authentification JWT
- déploiement conteneurisé
- CI/CD automatisé

---

# Objectif de ces notes

Cette documentation vise à :

- expliquer les décisions techniques
- garder une trace de l’évolution de l’architecture
- structurer la compréhension du système
- faciliter l’onboarding de nouveaux développeurs

Ces notes constituent une mémoire technique du projet
et servent de référence pour les choix d’architecture.
