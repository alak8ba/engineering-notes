# Dev Journal — Infrastructure Setup
**Date:** 2026-03-01  
**Project:** Seaway  
**Topic:** Docker Infrastructure

---

## Context

Today I finalized the base infrastructure for the Seaway platform.

The objective was to move from a simple development setup to a more structured environment that is easier to deploy, isolate, and maintain. I wanted the platform to run through a reproducible containerized stack instead of relying on local machine assumptions.

This step was important because infrastructure decisions directly affect deployment reliability, service isolation, and future production hardening.

---

## Initial Goal

The main target for this phase was to assemble the core runtime environment of the platform around a small number of clearly separated services:

- a relational database
- an event streaming layer
- a backend API
- a frontend served through Nginx

I also wanted to make sure that each service had a clear responsibility and communicated through an internal Docker network.

---

## Core Services

The platform is now organized around the following services:

| Service | Responsibility |
|---|---|
| PostgreSQL | Main relational database |
| Zookeeper | Kafka coordination |
| Kafka | Event streaming and messaging |
| Backend | Spring Boot API |
| Frontend | Static SPA + reverse proxy via Nginx |

This structure gives the project a clean separation between persistence, messaging, business logic, and delivery layer.

---

## Docker Network Design

A dedicated bridge network was introduced for internal communication between containers.

This means that services can talk to each other through Docker DNS names such as:

- `postgres`
- `kafka`
- `backend`

That keeps the internal topology simple and avoids exposing unnecessary services directly on the host machine.

Only the frontend reverse proxy is exposed publicly.

---

## Reverse Proxy Role

Nginx now acts as the public entry point of the platform.

It is responsible for:

- serving the frontend static files
- redirecting HTTP to HTTPS
- terminating TLS
- forwarding `/api/` traffic to the backend service

This centralizes inbound traffic management and creates a clean separation between the public web layer and internal application services.

---

## Public vs Internal Exposure

One of the most important infrastructure decisions was to keep internal services private whenever possible.

Exposure rules are now the following:

| Service | Exposure |
|---|---|
| PostgreSQL | localhost only |
| Kafka | internal Docker network only |
| Backend | internal Docker network only |
| Frontend / Nginx | public |

This approach reduces the public attack surface and makes the deployment model easier to reason about.

---

## Environment Configuration

Production configuration is now externalized through environment variables.

This includes:

- database name
- database credentials
- JWT secret
- refresh token pepper
- Spring profile
- Kafka bootstrap servers
- JVM options

This separation makes the deployment cleaner and allows the same images to be reused across environments with different runtime configuration.

---

## Service Dependencies

The containers are no longer treated as isolated startup units.

Dependencies were introduced so that:

- the backend starts after PostgreSQL is healthy
- the backend starts after Kafka is healthy
- the frontend starts after the backend is healthy

This improves startup consistency and reduces transient boot errors.

It also makes the environment more robust during restarts and redeployments.

---

## Health Checks

Health checks were added to validate that services are actually ready and not only started.

Examples include:

- PostgreSQL readiness check with `pg_isready`
- Kafka broker check
- backend HTTP response check

This helps Docker distinguish between a running container and a usable service.

That distinction is especially important in multi-service deployments.

---

## Restart Policy

Restart policies were enabled so that containers recover automatically after crashes or host reboots.

This improves resilience and makes the stack better suited for long-running deployment on a server.

It also reduces the amount of manual intervention required after infrastructure incidents.

---

## First Production-Oriented Thinking

Even though this phase was mainly about infrastructure setup, it already introduced several production-oriented concerns:

- service isolation
- internal networking
- controlled exposure of ports
- health-aware startup ordering
- externalized configuration
- reverse proxy centralization

This phase created the base that later security hardening could build on.

---

## Challenges

A key challenge was making sure the stack stayed simple enough for development while still moving toward a production-ready shape.

Adding Kafka and multiple containers increases operational complexity, so the goal was not just to “make everything run,” but to do it in a way that remains understandable and maintainable.

Another challenge was ensuring that the reverse proxy and backend communication worked cleanly once everything moved behind Docker networking.

---

## Outcome

At the end of this phase, Seaway now runs inside a structured Docker-based environment with:

- isolated services
- a dedicated internal network
- reverse proxy routing
- environment-based configuration
- startup dependency control
- health checks
- automatic restart behavior

This was a foundational milestone because it transformed the project from a local application into a platform that can realistically be deployed on a server.

---

## Reflection

This phase helped clarify an important point: infrastructure is not just about running containers, but about defining boundaries between services and making operational behavior predictable.

It also established the baseline needed for later improvements in security, observability, and deployment automation.