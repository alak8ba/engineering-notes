# JWT Authentication Pattern (SPA + REST API)

## Contexte

Les applications modernes utilisent souvent une architecture
séparée :

- frontend SPA (React, Vue, Angular)
- backend API REST

Dans ce modèle, le backend doit authentifier
les utilisateurs sans utiliser de sessions serveur.

Les mécanismes traditionnels basés sur les sessions
HTTP deviennent difficiles à gérer dans :

- les architectures distribuées
- les systèmes conteneurisés
- les environnements cloud

Une solution largement adoptée consiste
à utiliser **JWT (JSON Web Tokens)**.

---

# Principe

Un JWT est un token signé contenant
les informations nécessaires pour
identifier un utilisateur.

Exemple de contenu :
```json
{
"sub": "user-id",
"role": "ADMIN",
"exp": 1712345678
}
```

Le serveur signe ce token.

Le client l'utilise ensuite pour
authentifier les requêtes.

---

# Architecture typique

Architecture simplifiée :
```
     User
      |
      v
Frontend (React)
      |
      v
 Backend API
      |
      v
  Database
```

Le frontend communique uniquement
avec l'API.

L'API valide les tokens JWT.

---

# Access Token et Refresh Token

Une bonne pratique consiste à utiliser
deux types de tokens.

## Access Token

Le access token :

- contient l'identité de l'utilisateur
- contient les rôles
- a une durée de vie courte

Exemple :
```
5 à 15 minutes
```

Il est utilisé pour :

- authentifier les requêtes API

---

## Refresh Token

Le refresh token permet de
renouveler un access token expiré.

Il possède une durée de vie
plus longue.

Exemple :
```
7 à 30 jours
```

Le refresh token évite
de redemander les credentials.

---

# Flux d'authentification

## Login
``` java
POST /auth/login
```

Le serveur :

1. valide les credentials
2. génère access token + refresh token
3. renvoie les tokens

---

## Utilisation de l'API

Le client envoie l'access token
à chaque requête.

Exemple :
```
Authorization: Bearer <access_token>
```

Le serveur valide :

- la signature
- l'expiration
- les rôles

---

## Refresh

Lorsque l'access token expire :
``` java
POST /auth/refresh
```

Le serveur vérifie le refresh token
et génère un nouveau access token.

---

# Stockage des tokens

Plusieurs stratégies existent.

## Local Storage

Le token est stocké
dans le local storage.

Avantage :

- simplicité

Inconvénient :

- vulnérable aux attaques XSS

---

## Cookies HttpOnly

Une approche plus sécurisée consiste
à stocker les tokens dans des cookies
**HttpOnly**.

Avantages :

- inaccessible au JavaScript
- réduit les risques XSS

Les cookies peuvent être configurés avec :
```
HttpOnly
Secure
SameSite
```

---

# Sécurité

Plusieurs bonnes pratiques sont recommandées.

## Durée de vie courte

Les access tokens doivent expirer rapidement.

---

## Signature forte

Les tokens doivent être signés
avec une clé sécurisée.

---

## Rotation des refresh tokens

Dans certains systèmes,
le refresh token est remplacé
à chaque utilisation.

---

## Contrôle d'accès

Les rôles présents dans le JWT
permettent d'appliquer
des règles d'autorisation.

Exemple :
```
ROLE_ADMIN
ROLE_USER
```

---

# Avantages

JWT permet :

- une API stateless
- une bonne scalabilité
- une compatibilité avec les SPA
- une architecture simple

---

# Limites

JWT introduit certains défis :

- gestion de la révocation
- gestion des refresh tokens
- sécurisation du stockage

Une mauvaise implémentation
peut introduire des failles.

---

# Conclusion

JWT est aujourd'hui une solution
courante pour sécuriser les API
dans les architectures modernes.

Associé à :

- refresh tokens
- cookies HttpOnly
- contrôle RBAC

il permet de construire
une authentification robuste
pour les applications web modernes.
