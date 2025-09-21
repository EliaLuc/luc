DROP DATABASE IF EXISTS pharmacie;
CREATE DATABASE pharmacie;
USE pharmacie;

CREATE TABLE `alertes` (
  `id` int(11) NOT NULL,
  `type_alerte` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `date_alerte` datetime NOT NULL,
  `statut` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `observations` (
  `id` int(11) NOT NULL,
  `utilisateur_id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `date_observation` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `produits` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `prix` decimal(10,2) NOT NULL,
  `quantite_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `utilisateurs` (
  `id` int(11) NOT NULL,
  `nom_utilisateur` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `ventes` (
  `id` int(11) NOT NULL,
  `produit_id` int(11) NOT NULL,
  `quantite` int(11) NOT NULL,
  `prix_total` decimal(10,2) NOT NULL,
  `date_vente` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `alertes`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `observations`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `produits`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`);



ALTER TABLE `ventes`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `alertes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;



ALTER TABLE `observations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `produits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `utilisateurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `ventes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;


