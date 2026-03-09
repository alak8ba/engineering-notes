# Architecture Decision Records

!!! note ""
    
    This section documents the key architectural decisions
    taken during the development of the Seaway system.

    Operational infrastructure details are intentionally omitted.

Les *Architecture Decision Records (ADR)* constituent une méthode
de documentation légère permettant de conserver une trace des
choix techniques structurants réalisés au cours du projet.

Chaque ADR décrit :

- le **contexte** dans lequel une décision a été prise
- la **décision d’architecture** retenue
- les **alternatives envisagées**
- les **conséquences** de ce choix

Cette approche permet de préserver le raisonnement
architectural du système dans le temps.

---

## Pourquoi documenter les décisions d’architecture

Les systèmes logiciels évoluent continuellement et
les décisions d’architecture sont souvent influencées par
plusieurs contraintes :

- les exigences de **scalabilité**
- la **fiabilité opérationnelle**
- les **contraintes de sécurité**
- l’expertise de l’équipe
- l’infrastructure disponible

Documenter ces décisions permet aux ingénieurs de comprendre
**pourquoi le système a été conçu de cette manière**, et pas
uniquement **comment il fonctionne**.

---

## Périmètre

Les ADR présentés ici se concentrent sur les **principes
d’architecture** et les **pratiques d’ingénierie** utilisées
dans le projet.

Les détails opérationnels liés à l’infrastructure interne
ou aux environnements de production sont volontairement
omis.

---

## Principales décisions documentées

Les décisions d’architecture suivantes sont décrites
dans cette section :

- adoption d’une **architecture orientée événements**
- utilisation de **l’architecture hexagonale**
- stratégie de **gestion des retries avec Kafka**
- stratégie **CQRS pour les modèles de lecture**
- utilisation du **pattern Outbox**
- stratégie **d’idempotence des consommateurs**
- approche de **streaming API**
- stratégie de **sécurité des conteneurs**
- modèle d’**authentification et d’autorisation**

Chaque ADR décrit le problème rencontré, la solution retenue
et les conséquences de cette décision.

---

## Structure d’un ADR

Chaque Architecture Decision Record suit généralement
la structure suivante :

1. **Contexte**  
   Situation ou problème nécessitant une décision.

2. **Décision**  
   Choix d’architecture retenu.

3. **Conséquences**  
   Impacts positifs et négatifs de cette décision.

---

## Relation avec l’architecture du projet

Les ADR complètent la documentation d’architecture
présente dans la section **Architecture Overview** du
projet Seaway.

Ensemble, ces documents permettent de comprendre :

- l’**architecture globale du système**
- le **raisonnement technique ayant conduit aux choix réalisés**