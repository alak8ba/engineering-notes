# Container Security Best Practices

## Contexte

Les conteneurs sont largement utilisés pour déployer
des applications modernes.

Bien que les conteneurs offrent une isolation
par rapport au système hôte, ils ne constituent
pas une frontière de sécurité complète.

Un conteneur mal configuré peut exposer
le système à plusieurs risques :

- élévation de privilèges
- accès au système hôte
- fuite de données
- exécution de code malveillant

Il est donc essentiel d’appliquer
des pratiques de sécurité adaptées.

---

# Principe

La sécurité des conteneurs repose
sur plusieurs principes fondamentaux :

- principe du moindre privilège
- isolation des services
- limitation de la surface d’attaque
- contrôle des accès réseau

---

# Utilisateur non-root

Les conteneurs ne doivent pas
s’exécuter avec l’utilisateur root.

Exemple dans un Dockerfile :
```Dockerfile
RUN useradd -u 10001 appuser
USER appuser
```
!!! tip "Avantages"

    - réduit les privilèges
    - limite l’impact d’une compromission

---

# Filesystem en lecture seule

Les conteneurs applicatifs peuvent être
configurés avec un filesystem en lecture seule.

Exemple :
```Dockerfile
read_only: true
```
Seules certaines zones doivent rester
accessibles en écriture.

---

# Répertoires temporaires en mémoire

Les répertoires temporaires peuvent être
montés en mémoire avec **tmpfs**.

Exemple :
```Dockerfile
tmpfs:
/tmp
```

!!! tip "Avantages"

    - empêche la persistance de fichiers
    - améliore les performances

---

# Isolation réseau

Les services internes ne doivent pas
être exposés directement sur Internet.

Exemple de services internes :

- bases de données
- brokers de messages
- services de cache

Ces services doivent être accessibles
uniquement via le réseau interne Docker.

---

# Limitation des ports exposés

Seuls les ports nécessaires doivent
être exposés.

Exemple typique :
```bash
443 → HTTPS
80 → redirection HTTP
```

Les ports internes doivent rester fermés.

---

# Gestion des secrets

Les informations sensibles ne doivent
pas être intégrées dans les images Docker.

Exemples de secrets :

- mots de passe
- clés API
- tokens

Ils doivent être injectés via :

- variables d’environnement
- secret managers
- fichiers de configuration sécurisés

---

# Images minimales

Les images Docker doivent être
les plus petites possible.

Objectifs :

- réduire la surface d’attaque
- limiter les dépendances inutiles

Exemples :

- images `alpine`
- images JRE minimalistes

---

# Mise à jour des images

Les images doivent être mises à jour
régulièrement afin de corriger
les vulnérabilités.

Cela implique :

- rebuild périodique des images
- surveillance des dépendances

---

# Monitoring et logs

Les conteneurs doivent être surveillés :

- logs d’application
- métriques
- healthchecks

Cela permet de détecter
des comportements anormaux.

---

!!! tip "Avantages"

    Ces pratiques permettent :

    - une meilleure isolation
    - une réduction des risques
    - une architecture plus sécurisée

---

!!! warning "Limites"
    
    La sécurité des conteneurs doit être complétée par d’autres mécanismes :
    
    - firewall
    - reverse proxy
    - authentification
    - monitoring
    
    La sécurité doit être
    multi-couches.

---

# Conclusion

Les conteneurs simplifient le déploiement
des applications, mais ils doivent être
configurés correctement.

En appliquant ces bonnes pratiques,
il est possible de construire
une infrastructure conteneurisée
plus sûre et plus robuste.
