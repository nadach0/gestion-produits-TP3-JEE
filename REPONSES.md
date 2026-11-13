## Q1 : Forward vs Redirect lors du login
- **Échec de connexion (`forward`)** : Le serveur transfère directement la requête courante à `login.jsp` sans repasser par le navigateur. Cela permet de conserver les attributs placés dans la requête (`request.setAttribute("erreur", ...)` et le login déjà saisi) et d'afficher immédiatement le message d'erreur.
- **Connexion réussie (`sendRedirect`)** : Le serveur demande au navigateur d'effectuer une nouvelle requête `GET` vers `/dashboard`. L'URL dans la barre d'adresse change pour refléter la nouvelle page, et un rafraîchissement (`F5`) rechargera le tableau de bord au lieu de renvoyer les identifiants du formulaire.

## Q2 : Appui sur F5 après ajout d'un produit (Pattern PRG)
- **(a) Avec un `forward` dans `doPost`** : L'URL reste `/produits` associée à la requête `POST`. Si l'utilisateur appuie sur `F5`, le navigateur renvoie la même requête `POST` avec les mêmes données, ce qui crée un **doublon** du produit (après un avertissement du navigateur).
- **(b) Avec un `redirect` dans `doPost`** : Le navigateur a effectué une requête `GET /produits` après la redirection. Appuyer sur `F5` ne fait que recharger la liste (`GET`) sans recréer le produit.
- Ce pattern s'appelle **PRG (Post-Redirect-Get)**.

## Q3 : Protection contre les failles XSS
- Avec `${produit.nom}`, le code `<script>alert('XSS')</script>` est inséré tel quel dans le HTML de la page : le navigateur l'interprète et exécute la fenêtre d'alerte JavaScript (faille **XSS - Cross-Site Scripting**).
- Avec `<c:out value="${produit.nom}" />`, la JSTL échappe automatiquement les caractères spéciaux HTML (`<` devient `&lt;`, `>` devient `&gt;`). Le code s'affiche comme du simple texte et n'est pas exécuté.
- **Conclusion** : Il faut toujours utiliser `<c:out>` (ou `fn:escapeXml`) pour afficher des données saisies par les utilisateurs.

## Q4 : Avantages des filtres (`Filter`)
- **Avantage** : Le contrôle d'accès est centralisé en un seul endroit (`AuthFilter`) au lieu d'être dupliqué dans chaque servlet protégée. Cela évite les oublis de sécurité et facilite la maintenance.
- **Deux autres usages classiques** :
  1. Forcer l'encodage des caractères (`UTF-8`) sur toutes les requêtes entrantes et réponses sortantes.
  2. Journaliser (logger) les requêtes HTTP (URL demandée, adresse IP, temps d'exécution) ou compresser les réponses (GZIP).
