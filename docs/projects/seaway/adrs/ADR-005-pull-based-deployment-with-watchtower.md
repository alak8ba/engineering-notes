# ADR-005 — Adoption d’un déploiement pull-based avec Watchtower

## Statut

Accepté

---

## Contexte

Le projet Seaway est déployé sur un serveur auto-hébergé
(Debian) derrière un NAT avec une politique de sécurité
réseau très restrictive.

L’infrastructure suit un modèle de sécurité défensif :

- seuls les ports HTTPS (443) et HTTP (80 pour ACME) sont exposés
- aucun accès direct aux services internes
- firewall strict (UFW / iptables)
- limitation maximale des connexions entrantes

Une première approche consistait à déployer l’application
via SSH depuis GitHub Actions.

Cependant cette approche présentait plusieurs problèmes :

- ouverture nécessaire du port SSH
- dépendance au réseau entrant
- augmentation de la surface d’attaque
- complexité supplémentaire liée au NAT

Il était donc préférable d’adopter une approche compatible
avec une infrastructure **HTTPS-only**.

---

## Décision

Le déploiement utilise un modèle **pull-based**.

Le serveur ne reçoit aucune connexion entrante depuis
les systèmes CI.

Le processus fonctionne ainsi :

1. GitHub Actions build les images Docker
2. les images sont publiées dans GHCR
3. le serveur surveille les nouvelles versions
4. Watchtower met à jour automatiquement les containers

---

## Architecture de déploiement

Le système repose sur trois composants principaux :

### Code source

Le repository GitHub contient :

- le code
- les Dockerfiles
- les workflows CI/CD

---

### Registry

Les images Docker sont publiées dans :

GitHub Container Registry (GHCR)

Les images sont :

- versionnées
- immuables
- accessibles via authentification

---

### Serveur de production

Le serveur exécute :

- Docker
- docker-compose
- Watchtower

Le serveur :

- ne build jamais le code
- ne contient pas le code source
- consomme uniquement les images Docker publiées

---

## Fonctionnement de Watchtower

Watchtower surveille les containers Docker
ayant le label suivant :
``` yml
com.centurylinklabs.watchtower.enable=true
```

Toutes les 30 minutes :

1. Watchtower vérifie les nouvelles versions des images
2. si une image est mise à jour
3. le container est redéployé automatiquement

---

## Authentification

Les images étant privées sur GHCR,
le serveur doit être authentifié.

Solution retenue :

- création d’un Personal Access Token GitHub
- permission : `read:packages`
- authentification via :
- 
```
docker login ghcr.io
```

Les credentials sont stockés dans :

```
/root/.docker/config.json
```
---

## Conséquences

### Avantages

- aucune connexion entrante requise
- compatible avec une infrastructure HTTPS-only
- surface d’attaque réduite
- déploiement automatique simple
- rollback possible via version d’image

---

### Inconvénients

- moins de contrôle direct du moment du déploiement
- dépendance à Watchtower
- nécessité de gérer correctement les tags d’images

---

## Alternatives considérées

### Déploiement via SSH depuis CI

Cette approche nécessite :

- ouverture du port SSH
- gestion des clés
- accès direct au serveur depuis CI

Elle a été rejetée pour des raisons de sécurité.

---

### Déploiement manuel

Un déploiement manuel avec :
```
docker compose pull
docker compose up -d
```

reste possible mais ne permet pas
une automatisation complète.

---

## Justification

Le modèle pull-based avec Watchtower
s’aligne avec une architecture sécurisée
et minimise l’exposition du serveur.

Cette approche est cohérente avec une
infrastructure auto-hébergée derrière NAT
et un firewall strict.
