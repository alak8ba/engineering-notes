# Dev Journal — Event Architecture with Kafka

**Date:** 2026-03-05
**Project:** Seaway
**Topic:** Event-Driven Architecture

---

## Context

Today I introduced Kafka as the messaging backbone of the Seaway platform.

The objective was to move towards an **event-driven architecture** for certain domain operations.

---

# Why Kafka

Kafka was chosen for several reasons:

* durable event log
* high throughput
* consumer scalability
* strong ecosystem

It allows the platform to decouple **command processing from event handling**.

---

# Event Flow

The architecture now follows a simple flow:

```
Command → Domain → Event → Kafka → Consumers
```

For example:

1. a user action triggers a command
2. the domain logic processes the command
3. a domain event is emitted
4. the event is published to Kafka
5. consumers react to the event

---

# Reliability

Kafka producers are configured with:

* `acks=all`
* retries
* idempotence enabled

Consumers use retry policies and dead-letter topics.

This ensures events are processed reliably.

---

# Dead Letter Topic

A dedicated **DLT (Dead Letter Topic)** was introduced.

If event processing fails repeatedly, the event is redirected to the DLT for later inspection.

This prevents blocking the main consumer pipeline.

---

# Outcome

The project now supports **event-driven processing**, which will enable:

* asynchronous workflows
* better scalability
* improved separation between components
