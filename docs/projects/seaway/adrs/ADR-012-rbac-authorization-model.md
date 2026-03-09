# ADR-012 — RBAC Authorization Model

## Statut

Accepté

---

## Contexte

Le système Seaway doit contrôler l'accès aux ressources
et aux opérations selon le rôle des utilisateurs.

La plateforme gère plusieurs types d'acteurs :

- administrateurs système
- utilisateurs opérationnels
- agents métier liés à des rôles spécifiques

Le système doit permettre :

- de restreindre certaines opérations
- de garantir la traçabilité des actions
- de protéger les fonctionnalités critiques
- de préparer une évolution vers un modèle SaaS multi-clients

---

## Décision

Le système adopte un modèle **RBAC (Role-Based Access Control)**.

Les permissions sont déterminées à partir du rôle technique
de l'utilisateur (`technical_role`).

Les rôles actuels sont :

- ADMIN
- USER

Chaque rôle détermine les actions autorisées
dans l'application.

---

## Structure des rôles

Les rôles sont stockés dans la table `users`.

Exemple :
```
users

id
email
password_hash
technical_role
actor_type
created_at
version
```

Le champ `technical_role` détermine les droits
d'accès applicatifs.

---

## Actor Type

Le champ `actor_type` représente la nature métier
de l'utilisateur.

Exemples possibles :

- AGENT_DE_COQUE
- OPERATEUR_PORTUAIRE
- SUPERVISEUR

Ce champ permet de distinguer les profils métiers
sans influencer directement les permissions techniques.

---

## Implémentation

Le contrôle d'accès est appliqué via **Spring Security**.

Les rôles sont extraits du JWT et injectés
dans le `SecurityContext`.

Les endpoints sont protégés via :

- annotations Spring Security
- configuration HTTP Security

Exemples :
``` java
hasRole("ADMIN")
hasRole("USER")
```

---

## Exemple d'utilisation

Certaines opérations sont réservées
aux administrateurs :

- création d'utilisateurs
- gestion des rôles
- accès aux interfaces d'administration

Les utilisateurs standards peuvent :

- consulter les séjours
- interagir avec les données métier
- utiliser les fonctionnalités opérationnelles

---

## Conséquences

!!! tip "Avantages"

    - modèle simple et compréhensible
    - intégration native avec Spring Security
    - séparation claire entre authentification et autorisation
    - évolutif vers des modèles plus complexes

---

!!! warning "Inconvénients"

    - granularité limitée
    - gestion des permissions moins fine
    - nécessite une évolution si les besoins deviennent plus complexes

---

## Alternatives considérées

### ACL (Access Control Lists)

Un modèle ACL aurait permis un contrôle
plus fin des permissions.

Cependant il introduit :

- une complexité supplémentaire
- une gestion plus difficile
- un coût d'implémentation plus élevé

Cette approche a été jugée disproportionnée
pour la version actuelle du système.

---

### ABAC (Attribute-Based Access Control)

Un modèle ABAC permettrait un contrôle
basé sur des attributs dynamiques.

Cependant cette approche est plus complexe
et nécessite une infrastructure de règles
plus avancée.

---

## Justification

RBAC constitue un compromis efficace
entre simplicité et sécurité.

Il permet de sécuriser les accès
tout en conservant une architecture
simple et maintenable.

Le modèle reste évolutif vers
des systèmes d'autorisation plus avancés
si les besoins métier évoluent.
