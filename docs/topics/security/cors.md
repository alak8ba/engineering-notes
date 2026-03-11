# CORS — Cross-Origin Resource Sharing  
  
Statut : Draft    
Dernière mise à jour : 2026-03    
Catégorie : Sécurité Web  
  
---  
  
# Vue d’ensemble  
  
Dans les architectures web modernes, le **frontend** et le **backend** sont souvent séparés.  
  
Exemple :  
  
Frontend  
https://app.example.com  
  
API Backend  
https://api.example.com  
  
Ces services étant hébergés sur des domaines différents, les navigateurs appliquent des règles de sécurité qui empêchent la communication directe entre eux.  
  
Ce mécanisme s’appelle **CORS (Cross-Origin Resource Sharing)**.  
  
Comprendre CORS est essentiel lorsqu’on conçoit des API consommées par des applications web.  
  
---  
  
# Same-Origin Policy  
  
Avant de comprendre CORS, il faut comprendre la **Same-Origin Policy (SOP)**.  
  
La Same-Origin Policy est une règle de sécurité implémentée par les navigateurs qui limite les interactions entre ressources provenant d’origines différentes.  
  
Une **origine** est définie par :  
  
scheme + host + port  
  
Exemple :  
  
https://example.com:443  
  
Deux URLs ont la même origine uniquement si ces trois éléments sont identiques.  
  
| URL | Même origine |  
|-----|--------------|  
https://example.com/page | Oui |  
https://example.com/api | Oui |  
https://api.example.com | Non |  
https://google.com | Non |  
  
Dans cet exemple, `api.example.com` possède un host différent, donc l’origine est différente.  
  
---  
  
# Pourquoi cette règle existe  
  
La Same-Origin Policy protège les utilisateurs contre des attaques malveillantes.  
  
Exemple de scénario :  
  
1. Un utilisateur se connecte à son compte bancaire  
2. Il visite un site malveillant  
3. Ce site tente d'envoyer des requêtes vers l'API de la banque  
4. Le navigateur inclut automatiquement les cookies de session  
5. Des données sensibles pourraient être exposées  
  
Sans la Same-Origin Policy, un site pourrait lire librement les données provenant d'autres sites sur lesquels l'utilisateur est connecté.  
  
---  
  
# Qu'est-ce que CORS  
  
CORS signifie **Cross-Origin Resource Sharing**.  
  
Il s'agit d'un mécanisme permettant à un serveur d'autoriser explicitement certaines origines à accéder à ses ressources.  
  
Cela se fait via des **headers HTTP**.  
  
Le plus important est :  

Access-Control-Allow-Origin

  
Exemple :  

Access-Control-Allow-Origin: https://app.example.com

  
Ce header indique au navigateur que le serveur autorise les requêtes provenant de cette origine.  
  
Si l'origine n'est pas autorisée, le navigateur bloque l'accès à la réponse.  
  
---  
  
# Exemple de requête bloquée  
  
Dans la console du navigateur :  
  
```javascript  
await fetch("https://tea-api-vic-lo.herokuapp.com/tea")
```
Le navigateur peut renvoyer une **erreur CORS**.

Cela signifie que l’API ne permet pas aux requêtes provenant de l’origine actuelle d’accéder à la ressource.

Le navigateur bloque alors la réponse pour des raisons de sécurité.

---

# Implémentation dans Node.js (Express)

## Installation du middleware
```bash
npm install cors
```
---

## Import du package
```javascript
const cors = require("cors")
```
---

## Configuration des origines autorisées
```javascript
app.use(  
  cors({  
    origin: /(.*\.)?victoria-lo.github.io/,  
  })  
)
```
Cette configuration autorise toutes les requêtes provenant de sous-domaines de :
```
victoria-lo.github.io
```
Exemples :
```
victoria-lo.github.io  
app.victoria-lo.github.io
```
Ces origines pourront désormais accéder à l’API.

---

# Points importants à retenir

- Les navigateurs appliquent la **Same-Origin Policy**
    
- CORS permet d’autoriser explicitement certaines origines
    
- Cette autorisation se fait via des **headers HTTP**
    
- CORS est appliqué par le **navigateur**, pas par le serveur
    

---

# Sujets liés

- Headers HTTP
    
- CSRF (Cross-Site Request Forgery)
    
- Sécurité des API
    
- Modèle de sécurité des navigateurs