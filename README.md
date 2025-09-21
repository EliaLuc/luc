# Projet Pharmacie

Ce projet est une application de gestion de pharmacie développée en PHP.

## Structure du projet

```
C:/wamp/www/pharmacie/
│
├── config/
│   └── database.php          # Configuration de la base de données
│
├── controllers/
│   ├── AdminController.php    # Logique pour l'admin
│   ├── PharmacienController.php # Logique pour le pharmacien
│   └── AuthController.php     # Gestion de l'authentification
│
├── models/
│   ├── Utilisateur.php        # Modèle pour les utilisateurs
│   ├── Produit.php            # Modèle pour les produits
│   ├── Vente.php              # Modèle pour les ventes
│   ├── Alerte.php             # Modèle pour les alertes
│   └── Observation.php        # Modèle pour les observations
│
├── services/
│   ├── AlerteService.php      # Gestion des alertes
│   ├── VenteService.php       # Calculs et logique des ventes
│   └── StockService.php       # Gestion du stock
│
├── utils/
│   ├── pdf.php                # Génération de PDF
│   └── helpers.php            # Fonctions utilitaires
│
├── views/
│   ├── admin/
│   │   ├── dashboard.php      # Tableau de bord admin
│   │   ├── produits.php       # Gestion des produits
│   │   ├── ventes.php         # Consultation des ventes et bénéfices
│   │   └── alertes.php        # Gestion des alertes
│   ├── pharmacien/
│   │   ├── dashboard.php      # Tableau de bord pharmacien
│   │   ├── produits.php       # Gestion des produits
│   │   ├── ventes.php         # Réalisation des ventes (sans bénéfices)
│   │   └── alertes.php        # Alertes pour le pharmacien
│   └── auth/
│       ├── login.php          # Page de connexion
│       └── register.php       # Page d'inscription (si besoin)
│
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
│
├── index.php                  # Point d'entrée du projet
└── README.md                  # Documentation
```

## Installation

1.  **Cloner le dépôt :**
    ```bash
    git clone <URL_DU_DEPOT>
    cd pharmacie
    ```
    (Note: Si vous n'utilisez pas Git, vous pouvez simplement télécharger les fichiers et les placer dans votre répertoire `www` ou `htdocs` de votre serveur web).

2.  **Configuration de la base de données :**
    Ouvrez le fichier `config/database.php` et assurez-vous que les informations de connexion correspondent à votre configuration MySQL :
    ```php
    define('DB_HOST', 'localhost');
    define('DB_NAME', 'pharmacie'); // Nom de votre base de données
    define('DB_USER', 'root');     // Votre nom d'utilisateur MySQL
    define('DB_PASS', '');         // Votre mot de passe MySQL
    ```

3.  **Création de la base de données et des tables :**
    Importez le fichier `pharmacie.sql` (qui sera créé à l'étape suivante) dans votre gestionnaire de base de données (phpMyAdmin, MySQL Workbench, etc.).

4.  **Installation des dépendances (pour la génération de PDF) :**
    Ce projet utilise Dompdf pour la génération de PDF. Vous devez l'installer via Composer. Si vous n'avez pas Composer, téléchargez-le depuis [getcomposer.org](https://getcomposer.org/).
    ```bash
    composer require dompdf/dompdf
    ```

5.  **Accéder au projet :**
    Ouvrez votre navigateur web et accédez à l'URL de votre projet. Par exemple, si vous avez placé le dossier `pharmacie` dans `C:/wamp/www/`, l'URL sera `http://localhost/pharmacie/`.

## Utilisation

-   **Page de connexion :** Accédez à `http://localhost/pharmacie/auth/login` pour vous connecter.
-   **Page d'inscription :** Accédez à `http://localhost/pharmacie/auth/register` pour créer un nouveau compte (admin ou pharmacien).
-   **Tableau de bord Admin :** Après connexion en tant qu'administrateur, accédez à `http://localhost/pharmacie/admin/dashboard`.
-   **Tableau de bord Pharmacien :** Après connexion en tant que pharmacien, accédez à `http://localhost/pharmacie/pharmacien/dashboard`.

## Remarques

-   Ce projet est une base et nécessite des améliorations en termes de sécurité (validation des entrées, protection CSRF, etc.), de gestion des erreurs et de fonctionnalités.
-   Le routage est très basique et peut être amélioré avec un framework plus robuste.


