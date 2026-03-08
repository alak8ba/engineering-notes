# Hexagonal Architecture (Ports and Adapters)

## Contexte

Dans de nombreuses applications backend traditionnelles,
le code métier est souvent fortement couplé aux
frameworks et aux technologies utilisées :

- framework web
- base de données
- système de messaging
- infrastructure

Cette situation rend l'application difficile à :

- tester
- maintenir
- faire évoluer
- adapter à de nouvelles technologies

L'architecture hexagonale, également appelée
**Ports and Adapters**, vise à résoudre ce problème.

---

# Principe

L'idée principale est de **placer le domaine métier
au centre du système**.

Les technologies externes deviennent des
dépendances périphériques.

Schéma simplifié :
```
    +---------------------+
    |     Web Adapter     |
    +---------------------+
              |
              v
    +---------------------+
    |    Application      |
    |      (Use Cases)    |
    +---------------------+
              |
              v
    +---------------------+
    |       Domain        |
    +---------------------+
              ^
              |
    +---------------------+
    |  Persistence Adapter |
    +---------------------+
```

Le domaine ne dépend d'aucune technologie.

---

# Les composants principaux

## Domain

Le domaine contient :

- les entités
- les agrégats
- les règles métier
- les invariants

Le domaine doit rester indépendant
de toute technologie.

Il ne dépend pas :

- de Spring
- de JPA
- de Kafka
- de frameworks web

Exemple :
``` java
Sejour
Service
Schedule
```

---

## Application Layer

La couche application contient
les **cas d’usage du système**.

Elle orchestre :

- la logique métier
- les interactions entre composants
- les transactions

Exemples de use cases :
``` java
CreateSejour
UpdateSejour
ScheduleService
CancelService
```

Cette couche dépend du domaine
mais pas de l'infrastructure.

---

# Ports

Les ports définissent les **interfaces
entre le domaine et l'extérieur**.

Il existe deux types de ports.

---

## Ports entrants (driving ports)

Ils représentent les actions
qui peuvent être déclenchées
sur le système.

Exemple :
``` java
SejourRepository
EventPublisher
```

Ces ports sont implémentés
par les adapters.

---

# Adapters

Les adapters connectent
l'application aux technologies.

Exemples d'adapters :

- REST controller
- repository JPA
- Kafka publisher
- API externe

Ils traduisent les appels
entre les ports et
les systèmes externes.

---

# Organisation typique d'un projet

Une organisation fréquente
dans un projet Spring Boot :
```
domain/
model
events
exceptions

application/
usecase
ports

adapter/
in
rest
out
persistence
messaging

infrastructure/
configuration
```

Cette structure reflète
les responsabilités de chaque couche.

---

# Avantages

L'architecture hexagonale apporte
plusieurs bénéfices :

- isolation du domaine métier
- testabilité élevée
- découplage des technologies
- flexibilité d'évolution

Le domaine reste stable
même si les technologies changent.

---

# Tests facilités

L'isolation du domaine permet
de tester facilement :

- les règles métier
- les use cases

Sans dépendre :

- de la base de données
- de Kafka
- du framework web

Les adapters peuvent être
testés séparément.

---

# Limites

Cette architecture introduit :

- plus de classes
- plus d'abstractions
- une structure plus complexe

Elle peut sembler excessive
pour de très petits projets.

Cependant elle devient
très utile dès que le système
grandit.

---

# Conclusion

L'architecture hexagonale permet
de construire des applications
centrées sur le domaine métier.

En séparant clairement :

- domaine
- application
- infrastructure

elle améliore la maintenabilité,
la testabilité et l'évolutivité
des systèmes backend.

