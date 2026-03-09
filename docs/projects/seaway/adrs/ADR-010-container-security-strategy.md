# ADR-010 — Container Security Strategy

## Statut

Accepté

---

## Contexte

Le projet Seaway est déployé dans un environnement conteneurisé
basé sur Docker et Docker Compose.

Dans un contexte de production, les conteneurs doivent être
considérés comme des composants exposés aux risques suivants :

- compromission d’un service applicatif
- élévation de privilèges
- accès non autorisé au système hôte
- exploitation de vulnérabilités dans les images

Il est donc nécessaire d’adopter une stratégie de sécurité
défensive pour limiter l’impact d’un incident potentiel.

---

## Décision

Les conteneurs du projet Seaway appliquent plusieurs
mesures de sécurité :

- exécution avec un utilisateur non-root
- système de fichiers en lecture seule
- utilisation de tmpfs pour les répertoires temporaires
- limitation des capacités du conteneur
- exposition minimale des ports
- séparation des services via le réseau Docker interne

Ces mesures réduisent les privilèges des conteneurs
et limitent les surfaces d’attaque.

---

## Utilisateur non-root

Les applications dans les conteneurs ne s’exécutent pas
avec l’utilisateur root.

Un utilisateur applicatif dédié est défini dans l’image Docker.

Exemple :
```
USER appuser
```

Cela empêche un attaquant potentiel d’obtenir
des privilèges élevés dans le conteneur.

---

## Filesystem en lecture seule

Les conteneurs applicatifs utilisent un système
de fichiers en lecture seule :
``` yml
read_only: true
```

Seuls certains emplacements nécessaires
(par exemple `/tmp`) restent accessibles en écriture.

---

## Utilisation de tmpfs

Les répertoires temporaires utilisent un
filesystem en mémoire :
``` 
tmpfs:

/tmp

```


Cela limite les écritures disque
et empêche la persistance de fichiers malveillants.

---

## Réseau interne Docker

Les services internes (Kafka, PostgreSQL)
ne sont pas exposés publiquement.

Ils communiquent uniquement via
le réseau Docker interne.

Ports exposés publiquement :

- 80 (ACME / redirection)
- 443 (HTTPS)

Les ports sensibles restent fermés :

- PostgreSQL
- Kafka
- Zookeeper

---

## Reverse Proxy

Nginx agit comme point d’entrée unique.

Responsabilités :

- terminaison TLS
- redirection HTTP → HTTPS
- proxy vers le backend
- ajout de headers de sécurité

Cela évite l’exposition directe
des services applicatifs.

---

## Firewall

Le serveur utilise UFW avec
une politique restrictive :
``` yml
deny incoming
allow outgoing
```

Ports autorisés :

- 22 (SSH)
- 80 (ACME)
- 443 (HTTPS)

Tous les autres ports sont bloqués.

---

## Conséquences

!!! tip "Avantages"

    - réduction des privilèges des conteneurs
    - limitation des surfaces d’attaque
    - isolation des services internes
    - compatibilité avec les bonnes pratiques Docker

---

!!! warning "Inconvénients"

    - configuration plus complexe
    - certains outils nécessitent des ajustements
    - nécessité de tester les permissions applicatives

---

## Alternatives considérées

### Conteneurs exécutés en root

Solution plus simple mais beaucoup
moins sécurisée.

Cette approche a été rejetée.

---

### Exposition directe des services

Exposer directement PostgreSQL ou Kafka
simplifierait certaines opérations
mais augmenterait fortement la surface d’attaque.

Cette option a été rejetée.

---

## Justification

La sécurité des conteneurs repose
sur le principe du **least privilege**.

Chaque composant dispose uniquement
des permissions strictement nécessaires.

Cette approche réduit l’impact potentiel
d’une compromission applicative
et s’aligne avec les bonnes pratiques
de déploiement conteneurisé.
