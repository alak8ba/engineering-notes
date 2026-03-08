# Docker Production Pattern

## Contexte

Docker est largement utilisé pour déployer des applications
backend modernes. Il permet d'encapsuler une application
et ses dépendances dans un conteneur portable.

Cependant, un conteneur utilisé en production doit être
construit différemment d'un conteneur de développement.

Les objectifs principaux sont :

- sécurité
- reproductibilité
- performance
- isolation

Une mauvaise configuration peut exposer le système à
des vulnérabilités ou compliquer la maintenance.

---

# Principe

Le pattern "Docker Production" consiste à construire
des images conteneurisées :

- minimalistes
- sécurisées
- reproductibles

Cela implique plusieurs bonnes pratiques.

---

# Multi-stage Build

Les images Docker doivent être construites en plusieurs étapes.

Objectif :

- séparer la phase de build
- produire une image finale minimale

Exemple :
``` DockerFile
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY . .
RUN mvn package

FROM eclipse-temurin:21-jre

COPY --from=build /app/target/app.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
```
