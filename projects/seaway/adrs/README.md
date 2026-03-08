# Architecture Decision Records (ADR)

Ce dossier contient les décisions d’architecture importantes
prises dans le projet Seaway.

Les ADR documentent :

- le contexte
- la décision prise
- les conséquences
- les alternatives envisagées

Ils permettent de garder une trace des choix techniques
et d'expliquer les raisons derrière ces choix.

---

# Liste des décisions

- ADR-001 — Event Driven Architecture  
  `ADR-001-event-driven-architecture.md`

- ADR-002 — Hexagonal Architecture  
  `ADR-002-hexagonal-architecture.md`

- ADR-003 — Kafka Retry Strategy  
  `ADR-003-kafka-retry-strategy.md`

- ADR-004 — Testcontainers for Integration Tests  
  `ADR-004-testcontainers-for-integration-tests.md`

- ADR-005 — Pull-based Deployment with Watchtower  
  `ADR-005-pull-based-deployment-with-watchtower.md`

- ADR-006 — CQRS Read Model Strategy  
  `ADR-006-cqrs-read-model-strategy.md`

- ADR-007 — Domain Events and Outbox Pattern  
  `ADR-007-domain-events-and-outbox-pattern.md`

- ADR-008 — Idempotent Consumers Strategy  
  `ADR-008-idempotent-consumers-strategy.md`

- ADR-009 — API Streaming Strategy (SSE vs WebSocket vs Polling)  
  `ADR-009-api-streaming-strategy.md`

- ADR-010 — Container Security Strategy  
  `ADR-010-container-security-strategy.md`

- ADR-011 — JWT Authentication Strategy  
  `ADR-011-jwt-authentication-strategy.md`

- ADR-012 — RBAC Authorization Model  
  `ADR-012-rbac-authorization-model.md`

---

# Pourquoi utiliser des ADR

Les Architecture Decision Records permettent de :

- comprendre l’évolution de l’architecture
- documenter les compromis techniques
- faciliter l’onboarding de nouveaux développeurs
- conserver une mémoire technique du projet

Chaque ADR explique **pourquoi une décision a été prise**, et pas
seulement **ce qui a été implémenté**.
