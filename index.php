<?php
session_start();

// Inclusions des contrôleurs et modèles
require_once dirname(__FILE__) . '/config/database.php';
require_once dirname(__FILE__) . '/controllers/AuthController.php';
require_once dirname(__FILE__) . '/controllers/AdminController.php';
require_once dirname(__FILE__) . '/controllers/PharmacienController.php';
require_once dirname(__FILE__) . '/models/Produit.php';
require_once dirname(__FILE__) . '/models/Vente.php';
require_once dirname(__FILE__) . '/models/Alerte.php';
require_once dirname(__FILE__) . '/models/Utilisateur.php';

$auth = new AuthController();
$adminController = new AdminController();
$pharmacienController = new PharmacienController();

$route = isset($_GET['route']) ? $_GET['route'] : 'login';
$action = isset($_GET['action']) ? $_GET['action'] : 'dashboard';

try {
    switch ($route) {
        case 'login':
            if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                $login = isset($_POST['login']) ? $_POST['login'] : '';
                $mot_de_passe = isset($_POST['mot_de_passe']) ? $_POST['mot_de_passe'] : '';
                if ($auth->login($login, $mot_de_passe)) {
                    if ($_SESSION['role'] === 'admin') {
                        header('Location: index.php?route=admin&action=dashboard');
                    } elseif ($_SESSION['role'] === 'pharmacien') {
                        header('Location: index.php?route=pharmacien&action=dashboard');
                    }
                    exit;
                } else {
                    $erreur = "Login ou mot de passe incorrect.";
                    include 'views/auth/login.php';
                }
            } else {
                include 'views/auth/login.php';
            }
            break;

        case 'admin':
            if (!isset($_SESSION['role']) || $_SESSION['role'] != 'admin') {
                header('Location: index.php?route=acces-interdit');
                exit;
            }
            switch ($action) {
                case 'dashboard':
                    $adminController->afficherDashboard();
                    break;
                case 'ventes':
                    $adminController->afficherBenefices();
                    break;
                case 'produits':
                    $produits = Produit::listerProduits();
                    include 'views/admin/produits.php';
                    break;
                case 'ajouter_produit':
                    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                        $adminController->ajouterProduit($_POST);
                    } else {
                        header('Location: index.php?route=admin&action=produits');
                    }
                    break;
                case 'supprimer_produit':
                    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id'])) {
                        $adminController->supprimerProduit($_POST['id']);
                    } else {
                        header('Location: index.php?route=admin&action=produits');
                    }
                    break;
                case 'modifier_produit':
                    if (isset($_GET['id'])) {
                        $produit = Produit::trouverParId($_GET['id']);
                        if ($produit) {
                            include 'views/admin/modifier_produit.php';
                        } else {
                            throw new Exception("Produit non trouvé.");
                        }
                    } elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id'])) {
                        $adminController->modifierProduit($_POST['id'], $_POST);
                    } else {
                        header('Location: index.php?route=admin&action=produits');
                    }
                    break;
                case 'ajouter_pharmacien':
                    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                        $adminController->ajouterPharmacien($_POST);
                    } else {
                        include 'views/admin/ajouter_pharmacien.php';
                    }
                    break;
                case 'liste_pharmaciens':
                    $pharmaciens = Utilisateur::listerPharmaciens();
                    include 'views/admin/liste_pharmaciens.php';
                    break;
                case 'generer_pdf_benefices':
                    require_once 'controllers/PdfController.php';
                    PdfController::genererRapportBenefices();
                    break;
                    case 'generer_pdf_ventes':
                        require_once 'controllers/PdfController.php';
                        PdfController::genererRapportVentes();
                        break;

                default:
                    include 'views/admin/dashboard.php';
            }
            break;

        case 'pharmacien':
            if (!isset($_SESSION['role']) || $_SESSION['role'] != 'pharmacien') {
                header('Location: index.php?route=acces-interdit');
                exit;
            }
            switch ($action) {
                case 'dashboard':
                    include 'views/pharmacien/dashboard.php';
                    break;
                case 'produits':
                    $produits = Produit::listerProduits();
                    include 'views/pharmacien/produits.php';
                    break;
                case 'ventes':
                    $ventes = Vente::getVentesParUtilisateur($_SESSION['user_id']);
                    include 'views/pharmacien/ventes.php';
                    break;
                case 'generer_pdf_mes_ventes':
                    require_once 'controllers/PdfController.php';
                    PdfController::genererRapportVentes($_SESSION['user_id']);
                    break;

                case 'alertes':
                    $alertes = Alerte::listerAlertes();
                    include 'views/pharmacien/alertes.php';
                    break;
                case 'ventes-ajouter':
                    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                        $pharmacienController->enregistrerVente($_POST);
                    } else {
                        $produit_id = isset($_GET['produit_id']) ? $_GET['produit_id'] : null;
                        if ($produit_id) {
                            $produit = Produit::trouverParId($produit_id);
                            if ($produit) {
                                include 'views/pharmacien/ventes_ajouter.php';
                            } else {
                                throw new Exception("Produit non trouvé.");
                            }
                        } else {
                            header('Location: index.php?route=pharmacien&action=produits');
                            exit;
                        }
                    }
                    break;
                default:
                    include 'views/pharmacien/dashboard.php';
            }
            break;

        case 'acces-interdit':
            include 'views/auth/acces_interdit.php';
            break;

        case 'deconnexion':
            session_destroy();
            header('Location: index.php');
            exit;

        default:
            include 'views/auth/login.php';
    }
} catch (Exception $e) {
    die("Erreur : " . htmlspecialchars($e->getMessage()));
}
?>
