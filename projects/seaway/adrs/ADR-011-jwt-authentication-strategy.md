# ADR-011 — JWT Authentication Strategy

## Statut

Accepté

---

## Contexte

Le système Seaway expose une API REST utilisée par
une interface frontend React.

Le système nécessite :

- une authentification sécurisée
- un contrôle des accès
- une gestion des rôles utilisateurs
- une protection contre les attaques courantes

Les utilisateurs doivent pouvoir se connecter,
maintenir une session sécurisée et accéder uniquement
aux ressources autorisées.

Le système doit également être compatible avec
une architecture moderne :

- frontend séparé
- API stateless
- déploiement conteneurisé

---

## Décision

Le projet adopte une stratégie d'authentification
basée sur **JWT (JSON Web Tokens)**.

Deux types de tokens sont utilisés :

- Access Token (court)
- Refresh Token (long)

Les tokens sont stockés dans des **cookies HttpOnly**
afin de limiter l'exposition aux attaques XSS.

---

## Architecture d'authentification

### Access Token

Le access token :

- contient l'identité de l'utilisateur
- contient ses rôles
- a une durée de vie courte

Il est utilisé pour :

- authentifier les requêtes API
- autoriser l'accès aux endpoints sécurisés

---

### Refresh Token

Le refresh token permet de :

- renouveler un access token expiré
- maintenir la session utilisateur

Le refresh token possède une durée
de vie plus longue.

---

## Flux d'authentification

### Login
``` java
POST /auth/login
```

Le backend :

- valide les credentials
- génère access token + refresh token
- place les tokens dans des cookies HttpOnly

---

### Récupération de l'utilisateur
``` java
GET /auth/me
```

Cet endpoint permet de récupérer
l'utilisateur authentifié.

---

### Refresh token

Si un access token expire :
``` java
POST /auth/refresh
```

Le refresh token est utilisé pour
générer un nouveau access token.

---

## Sécurité backend

Spring Security est configuré en mode stateless.

Les mécanismes suivants sont utilisés :

- filtre JWT basé sur `OncePerRequestFilter`
- validation du token
- extraction de l'utilisateur
- injection dans le `SecurityContext`

---

## Gestion des mots de passe

Les mots de passe sont :

- hashés avec BCrypt
- jamais stockés en clair

---

## Contrôle d'accès

Le système utilise un modèle RBAC.

Rôles actuels :

- ADMIN
- USER

Les endpoints sont protégés
via Spring Security.

---

## Stockage des tokens

Les tokens sont stockés dans des cookies :

- HttpOnly
- Secure (en production)
- SameSite

Cela permet de limiter :

- l'accès JavaScript aux tokens
- les attaques XSS

---

## Sécurité supplémentaire

Plusieurs mécanismes complètent la sécurité :

- validation des entrées
- optimistic locking sur les entités
- filtrage CORS
- headers de sécurité via Nginx
- séparation des rôles

---

## Conséquences

### Avantages

- API stateless
- compatible SPA
- bonne sécurité
- gestion simple des sessions

---

### Inconvénients

- gestion du refresh token
- complexité légèrement supérieure
- gestion de l'expiration des tokens

---

## Alternatives considérées

### Sessions serveur

Les sessions serveur auraient introduit :

- un état côté serveur
- une complexité de scaling

Cette option a été écartée.

---

### OAuth2 / OpenID Connect

Ces solutions sont plus complètes
mais également plus complexes.

Pour une première version du système,
JWT interne a été privilégié.

---

## Justification

JWT permet :

- une authentification stateless
- une bonne compatibilité avec les SPA
- une architecture simple et robuste

Cette solution s'aligne également
avec les recommandations modernes
pour les API REST sécurisées.


