# Seaway — CI/CD Overview

!!! note  ""

	This documentation presents the architectural principles  and engineering practices used in the project.  
	  
	Operational details and internal infrastructure configurations are intentionally omitted.
## Objectif

Mettre en place une chaîne CI/CD réaliste et production-ready
autour d'un projet backend Java / frontend React.

Objectifs :

- automatiser les builds
- garantir la qualité du code
- produire des artefacts Docker immuables
- permettre un déploiement contrôlé

---

## Outil utilisé

GitHub Actions

Utilisé pour :

- exécuter la CI
- builder les images Docker
- publier les images dans GHCR
- créer les releases

---

## Architecture CI/CD

Le système repose sur trois espaces distincts :

1. Code source (GitHub)
2. Registry d’images (GHCR)
3. Serveur de production (Debian)

Principe fondamental :

La production ne build jamais le code.

Elle consomme uniquement des images Docker versionnées.

---

## CI — Continuous Integration

La CI est déclenchée sur :

- push
- pull request

Actions exécutées :

Backend :

- compilation
- tests unitaires
- tests d'intégration

Frontend :

- installation dépendances
- build

Images Docker :

- build images backend et frontend
- images utilisées uniquement pour validation CI

---

## Release

Lorsqu'une version est validée :

- création d'un tag Git
- build des images Docker finales
- publication dans GHCR

Les images sont :

- versionnées
- immuables

---

## Déploiement

Le déploiement suit un modèle pull-based.

Le serveur de production :

- récupère les nouvelles images
- redéploie automatiquement les containers

Watchtower est utilisé pour surveiller les nouvelles images
et déclencher les mises à jour.

---

## Principes clés

- séparation CI / Release / Deploy
- artefacts immuables
- rollback simple via tags
- déploiement jamais automatique par accident
