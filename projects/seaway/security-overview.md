# Seaway — Security Overview

## Objectif

Mettre en place une infrastructure sécurisée par défaut
pour l'application Seaway.

---

## Backend

Spring Security configuré en mode stateless.

Choix actuels :

- CSRF désactivé (API REST)
- sessions désactivées
- endpoints API temporairement publics

Préparation pour une future authentification JWT.

---

## Reverse Proxy

Nginx assure :

- terminaison HTTPS
- reverse proxy vers le backend
- protection contre certaines attaques

Headers de sécurité :

- X-Frame-Options
- Strict-Transport-Security
- Referrer-Policy
- Permissions-Policy

---

## Docker Security

Containers exécutés :

- avec un user non-root
- filesystem read-only
- /tmp en tmpfs

---

## Firewall

UFW configuré avec une politique restrictive.

Ports ouverts :

- 22 (SSH)
- 80 (ACME)
- 443 (HTTPS)

Ports internes non exposés :

- PostgreSQL
- Kafka

---

## Infrastructure

Les services sensibles ne sont accessibles
que via le réseau Docker interne.

Kafka et PostgreSQL ne sont jamais exposés
publiquement.
