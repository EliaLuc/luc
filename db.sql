DROP DATABASE IF EXISTS pharmacie_db;
CREATE DATABASE pharmacie_db CHARACTER SET utf8 COLLATE utf8_general_ci;
USE pharmacie_db;

-- Table des utilisateurs
CREATE TABLE utilisateurs (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom_complet VARCHAR(100) NOT NULL,
    login VARCHAR(50) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'pharmacien') NOT NULL,
    photo VARCHAR(255) DEFAULT 'avatar_defaut.png',
    statut ENUM('actif', 'inactif') NOT NULL DEFAULT 'actif',
    date_creation DATETIME NOT NULL,
    derniere_connexion DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table des produits
CREATE TABLE produits (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designation VARCHAR(100) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    fournisseur VARCHAR(100) NOT NULL,
    code_barre VARCHAR(50) UNIQUE,
    quantite INT(11) NOT NULL DEFAULT 0 COMMENT 'Quantité en plaquettes',
    prix_achat DECIMAL(10,2) NOT NULL COMMENT 'Prix d''achat par plaquette en FC',
    prix_vente DECIMAL(10,2) NOT NULL COMMENT 'Prix de vente par plaquette en FC',
    date_ajout DATE NOT NULL,
    date_expiration DATE NOT NULL,
    stock_minimal INT(11) NOT NULL DEFAULT 10 COMMENT 'Seuil d''alerte en plaquettes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table des ventes
CREATE TABLE ventes (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    produit_id INT(11) NOT NULL,
    utilisateur_id INT(11) NOT NULL,
    quantite INT(11) NOT NULL COMMENT 'Nombre de plaquettes vendues',
    prix_unitaire DECIMAL(10,2) NOT NULL COMMENT 'Prix de vente unitaire en FC',
    prix_achat_unitaire DECIMAL(10,2) NOT NULL COMMENT 'Prix d''achat unitaire en FC',
    montant_total DECIMAL(10,2) NOT NULL COMMENT 'Montant total de la vente en FC',
    benefice DECIMAL(10,2) NOT NULL COMMENT 'Bénéfice en FC (visible admin uniquement)',
    mode_paiement ENUM('especes', 'carte', 'assurance') NOT NULL DEFAULT 'especes',
    remise DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT 'Montant de la remise en FC',
    date_vente DATETIME NOT NULL,
    FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table des alertes
CREATE TABLE alertes (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    produit_id INT(11) NOT NULL,
    type_alerte ENUM('stock', 'expiration') NOT NULL,
    message TEXT NOT NULL,
    niveau_urgence ENUM('faible', 'moyen', 'eleve') NOT NULL DEFAULT 'moyen',
    date_alerte DATETIME NOT NULL,
    vue TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table des observations
CREATE TABLE observations (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    produit_id INT(11) NOT NULL,
    type_observation ENUM('reapprovisionnement', 'perte', 'ajustement') NOT NULL,
    quantite INT(11) NOT NULL,
    date_observation DATETIME NOT NULL,
    utilisateur_id INT(11) NOT NULL,
    commentaire TEXT,
    FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Déclencheur pour calcul automatique des bénéfices et du montant total
DELIMITER $$
CREATE TRIGGER calcul_vente BEFORE INSERT ON ventes
FOR EACH ROW
BEGIN
    SET NEW.montant_total = (NEW.quantite * NEW.prix_unitaire) - NEW.remise;
    SET NEW.benefice = (NEW.prix_unitaire - NEW.prix_achat_unitaire) * NEW.quantite;
    SET NEW.date_vente = NOW();
END$$
DELIMITER ;

-- Insertion des données de test pour les utilisateurs
INSERT INTO utilisateurs (nom_complet, login, mot_de_passe, email, role, date_creation) VALUES
('Admin Principal', 'admin', MD5('admin123'), 'admin@pharmacie.cd', 'admin', NOW()),
('Pharmacien Dupont', 'pharma', MD5('pharma123'), 'pharma@pharmacie.cd', 'pharmacien', NOW()),
('Dr. Marie Kabasele', 'marie', MD5('marie123'), 'marie@pharmacie.cd', 'pharmacien', NOW());

-- Insertion des données de test pour les produits
INSERT INTO produits (designation, categorie, fournisseur, code_barre, quantite, prix_achat, prix_vente, date_ajout, date_expiration, stock_minimal) VALUES
('Paracétamol 500mg', 'Antidouleur', 'Fournisseur A', 'PAR500001', 50, 200, 500, '2023-01-01', '2024-12-31', 10),
('Ibuprofène 200mg', 'Antidouleur', 'Fournisseur B', 'IBU200001', 30, 300, 700, '2023-01-01', '2025-06-30', 5),
('Amoxicilline 500mg', 'Antibiotique', 'Fournisseur C', 'AMO500001', 20, 500, 1200, '2023-02-15', '2024-08-15', 8),
('Vitamine C 1000mg', 'Complément alimentaire', 'Fournisseur D', 'VIT1000001', 40, 400, 900, '2023-03-10', '2024-10-10', 12),
('Doliprane 1000mg', 'Antidouleur', 'Fournisseur A', 'DOL1000001', 15, 250, 600, '2023-04-05', '2024-09-20', 5);

-- Insertion des données de test pour les ventes
INSERT INTO ventes (produit_id, utilisateur_id, quantite, prix_unitaire, prix_achat_unitaire, mode_paiement, remise) VALUES
(1, 2, 2, 500, 200, 'especes', 0),
(2, 2, 1, 700, 300, 'carte', 0),
(3, 3, 3, 1200, 500, 'assurance', 100),
(4, 2, 2, 900, 400, 'especes', 50),
(5, 3, 1, 600, 250, 'especes', 0);

-- Insertion des données de test pour les alertes
INSERT INTO alertes (produit_id, type_alerte, message, niveau_urgence, date_alerte) VALUES
(5, 'stock', 'Stock faible pour Doliprane 1000mg. Quantité actuelle: 15. Stock minimal: 5.', 'moyen', NOW()),
(3, 'expiration', 'L\'Amoxicilline 500mg expire bientôt, le 2024-08-15.', 'faible', NOW());

-- Création des index pour améliorer les performances
CREATE INDEX idx_ventes_date ON ventes(date_vente);
CREATE INDEX idx_produits_categorie ON produits(categorie);
CREATE INDEX idx_alertes_vue ON alertes(vue);
CREATE INDEX idx_utilisateurs_role ON utilisateurs(role);
