# Kafka Retry and Dead Letter Topic Pattern

## Contexte

Dans un système distribué basé sur Kafka, les consommateurs
peuvent rencontrer différents types d’erreurs lors du traitement
des messages :

- erreurs temporaires (base de données indisponible)
- erreurs de sérialisation
- erreurs métier
- erreurs d’infrastructure

Sans stratégie adaptée, un message en erreur peut bloquer
le traitement du topic et empêcher les messages suivants
d’être traités.

Il est donc nécessaire de mettre en place un mécanisme
de gestion des erreurs permettant :

- de réessayer le traitement
- d’éviter les boucles infinies
- d’isoler les messages invalides

---

# Principe du Retry

Lorsqu’un message échoue, le consommateur peut tenter
de le traiter à nouveau.

Le retry est généralement configuré avec :

- un nombre maximal de tentatives
- un délai entre les tentatives (backoff)

Exemple :
```less
3 tentatives
backoff : 1s → 5s → 10s
```

Le retry permet de résoudre les erreurs temporaires.

---

# Dead Letter Topic (DLT)

Si un message échoue après toutes les tentatives de retry,
il est envoyé dans un **Dead Letter Topic**.

Un Dead Letter Topic est un topic Kafka dédié
au stockage des messages en erreur.

Convention fréquente :
```bash
<topic>.DLT
```
Exemple :
```bash
seaway.events
seaway.events.DLT
```

Le message est alors isolé et n’empêche plus
le traitement des messages suivants.

---

# Flux de traitement

Flux typique :

1. le message arrive dans le topic principal
2. le consumer tente de traiter le message
3. en cas d’échec → retry
4. si tous les retries échouent → publication dans le DLT

---

# Implémentation avec Spring Kafka

Spring Kafka propose un mécanisme intégré
pour gérer les retries et les DLT.

Le composant principal est :
```bash
DefaultErrorHandler
```
Il peut être combiné avec :
```java
DeadLetterPublishingRecoverer
```
Exemple simplifié :
```java
DefaultErrorHandler errorHandler =
new DefaultErrorHandler(
new DeadLetterPublishingRecoverer(kafkaTemplate),
new FixedBackOff(2000L, 3)
);
```

Dans cet exemple :

- retry 3 fois
- délai de 2 secondes
- envoi dans le DLT si échec

---

!!! tip "Avantages du pattern"

    Ce pattern apporte plusieurs bénéfices :

    - amélioration de la résilience
    - isolation des messages invalides
    - continuité du traitement des topics
    - meilleure observabilité des erreurs

---

!!! warning "Limites"

    Le pattern ne résout pas certains problèmes :

    - erreurs métier persistantes
    - duplication possible des messages
    - nécessité de gérer l'idempotence

    C’est pourquoi il est généralement combiné avec un **consumer idempotent**.

---

# Bonnes pratiques

Plusieurs bonnes pratiques sont recommandées :

- limiter le nombre de retries
- utiliser un backoff progressif
- surveiller les messages présents dans les DLT
- prévoir un mécanisme d’analyse ou de replay
- rendre les consumers idempotents

---

# Conclusion

Le pattern Retry + Dead Letter Topic est un
élément fondamental des architectures
basées sur Kafka.

Il permet de construire des systèmes
résilients capables de gérer les erreurs
sans bloquer le flux de traitement.
