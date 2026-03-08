# ADR-006 — Adoption d’un Read Model CQRS pour l’interface utilisateur

## Statut

Accepté

---

## Contexte

Le système Seaway expose une API utilisée par une interface
utilisateur React orientée dashboard.

Les besoins de lecture de l’UI diffèrent souvent du modèle
métier utilisé pour l’écriture :

- agrégation de plusieurs entités
- formats optimisés pour l’affichage
- performances de lecture

Utiliser directement les entités métier du write model
pour les requêtes UI aurait introduit plusieurs problèmes :

- requêtes complexes
- couplage entre UI et modèle métier
- difficultés d’évolution du domaine

---

## Décision

Le projet adopte une approche **CQRS légère** :

- le write model gère les opérations métier
- un read model dédié est utilisé pour la consultation

Le read model est alimenté par les événements Kafka
produits par le système.

---

## Architecture

### Write Model

Le write model :

- applique les règles métier
- valide les invariants
- publie des événements de domaine

Il représente la source de vérité du système.

---

### Read Model

Le read model :

- est optimisé pour les requêtes UI
- peut agréger plusieurs données
- est alimenté par les événements Kafka

Exemples :

- liste des séjours
- détails d’un séjour
- informations synthétiques pour le dashboard

---

## Flux de données

Le flux est le suivant :

1. une commande est exécutée dans le write model
2. un événement métier est publié
3. un consumer Kafka met à jour le read model
4. l’API REST expose le read model à l’interface utilisateur

---

## Conséquences

### Avantages

- API adaptée aux besoins de l’UI
- meilleure performance de lecture
- découplage entre modèle métier et affichage
- évolution plus simple du domaine

---

### Inconvénients

- duplication contrôlée de certaines données
- cohérence éventuelle entre write et read model
- complexité supplémentaire

---

## Alternatives considérées

### Utiliser directement le modèle métier

Cette approche simplifie l’architecture
mais entraîne souvent :

- des requêtes complexes
- un fort couplage entre domaine et UI

Elle a été écartée.

---

## Justification

L’utilisation d’un read model dédié permet
d’adapter les données aux besoins de l’interface
tout en préservant l’intégrité du domaine.

Cette approche s’intègre naturellement avec
l’architecture orientée événements déjà en place
dans le projet.
