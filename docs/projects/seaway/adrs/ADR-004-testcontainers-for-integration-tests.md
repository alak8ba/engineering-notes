# ADR-004 — Adoption de Testcontainers pour les tests d’intégration

## Statut

Accepté

---

## Contexte

Le projet Seaway utilise PostgreSQL comme base de données principale.

Les premières tentatives de tests d'intégration ont utilisé H2
comme base de données embarquée.

Cependant, plusieurs incompatibilités sont apparues :

- types PostgreSQL spécifiques (JSONB)
- différences de dialecte SQL
- comportements différents sur certaines requêtes

Ces différences rendaient les tests peu fiables et pouvaient
masquer des problèmes apparaissant uniquement en production.

Il était donc nécessaire d'utiliser une base de données
identique à celle utilisée en production.

---

## Décision

Les tests d’intégration utilisent désormais Testcontainers
afin de démarrer une instance PostgreSQL réelle
dans un container Docker.

Chaque suite de tests démarre automatiquement
une base PostgreSQL isolée.

---

## Fonctionnement

Lors du lancement des tests :

1. Testcontainers démarre un container PostgreSQL
2. Spring Boot se connecte à cette base
3. les migrations ou scripts d’initialisation sont appliqués
4. les tests d’intégration s’exécutent

Les containers sont arrêtés automatiquement
à la fin de l’exécution des tests.

---

## Exemple simplifié

Classe de base pour les tests d’intégration :
``` java
@Testcontainers
@SpringBootTest
@ActiveProfiles("it")
public abstract class AbstractIT {

@Container
static PostgreSQLContainer<?> postgres =
    new PostgreSQLContainer<>("postgres:15");

}

```

Toutes les classes de tests d’intégration héritent
de cette classe.

---

## Conséquences

!!! tip "Avantages"

    - environnement proche de la production
    - suppression des incompatibilités H2 / PostgreSQL
    - meilleure fiabilité des tests
    - isolation complète des tests

---

!!! warning "Inconvénients"

    - dépendance à Docker
    - démarrage plus lent que des tests unitaires
    - complexité légèrement supérieure

---

## Alternatives considérées

### H2 en mode PostgreSQL

Même avec ce mode, plusieurs différences
restaient présentes.

Cette option a été écartée.

---

### Base PostgreSQL partagée

Une base de données partagée pour les tests
aurait introduit :

- des conflits entre tests
- une dépendance à l’environnement

Cette option a également été écartée.

---

## Justification

Testcontainers permet d'exécuter les tests
dans un environnement reproductible,
proche de la production et entièrement automatisé.

Cela améliore la confiance dans les tests
et réduit les écarts entre développement
et production.
