# ADR-009 — API Streaming Strategy (SSE vs WebSocket vs Polling)

## Statut

Accepté

---

## Contexte

Le projet Seaway inclut une interface utilisateur React orientée
dashboard permettant de visualiser l'état du système et les
événements liés aux séjours.

Une question s'est posée concernant la mise à jour de l'interface
en temps réel :

comment informer l'interface utilisateur des nouveaux événements
produits par le backend ?

Plusieurs approches étaient possibles :

- polling HTTP classique
- Server-Sent Events (SSE)
- WebSockets

Le choix devait prendre en compte :

- la complexité d'implémentation
- les besoins réels du produit
- la fiabilité
- la maintenabilité

---

## Décision

Le projet adopte une stratégie pragmatique :

- API REST pour les opérations standard
- polling côté frontend pour la consultation régulière
- SSE expérimenté côté backend mais non utilisé en production

Les mises à jour temps réel complètes ont été considérées
comme non essentielles dans la première version du système.

---

## Polling HTTP

Le polling consiste à interroger périodiquement l'API REST
afin de récupérer l'état actuel du système.

Exemple :
``` java
GET /api/sejours
```

Le frontend rafraîchit les données à intervalle régulier.

---

### Avantages

- simplicité d'implémentation
- robustesse
- aucune connexion longue durée
- facile à maintenir

---

### Inconvénients

- latence entre les mises à jour
- requêtes supplémentaires

Dans le contexte du projet, ces inconvénients
sont considérés comme acceptables.

---

## Server-Sent Events (SSE)

SSE permet au serveur d'envoyer des événements
vers le client via une connexion HTTP persistante.

Un prototype SSE a été implémenté côté backend.

Exemple :
``` java
/api/events
```

Cependant l'intégration côté frontend a été
temporairement abandonnée pour plusieurs raisons :

- complexité supplémentaire
- gestion du reconnect
- faible valeur immédiate pour l'interface

---

## WebSockets

WebSockets permettent une communication
bidirectionnelle entre client et serveur.

Cette approche a été considérée mais écartée
pour la première version du système.

Elle aurait introduit :

- complexité réseau
- gestion de connexions persistantes
- infrastructure supplémentaire

---

## Conséquences

### Avantages

- architecture simple
- API REST classique facile à maintenir
- complexité technique limitée

---

### Inconvénients

- absence de temps réel strict
- latence dépendante de l'intervalle de polling

---

## Alternatives considérées

### SSE complet

Cette solution reste envisageable
dans une évolution future du projet.

---

### WebSockets

Approche puissante mais disproportionnée
pour les besoins actuels du système.

---

## Justification

Dans une première phase du projet,
la simplicité et la robustesse ont été privilégiées.

Le polling HTTP répond aux besoins fonctionnels
tout en conservant une architecture facile
à comprendre et à maintenir.

L'architecture reste ouverte à l'introduction
d'un mécanisme de streaming plus avancé
si les besoins évoluent.
