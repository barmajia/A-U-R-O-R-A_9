// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_title => 'Aurora E-commerce';

  @override
  String get app_title_desc => 'Plateforme Aurora E-commerce';

  @override
  String get welcome_back => 'Bon retour!';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get logout => 'Déconnexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirm_password => 'Confirmer le mot de passe';

  @override
  String get forgot_password => 'Mot de passe oublié?';

  @override
  String get reset_password => 'Réinitialiser le mot de passe';

  @override
  String get send_reset_link => 'Envoyer le lien';

  @override
  String get back_to_login => 'Retour à la connexion';

  @override
  String get or_continue_with => 'OU';

  @override
  String get login_subtitle => 'Connectez-vous pour continuer';

  @override
  String get continue_with_google => 'Continuer avec Google';

  @override
  String get restricted_account =>
      'Cette application est réservée aux comptes vendeurs.';

  @override
  String get password_complexity =>
      'Le mot de passe doit contenir majuscules, minuscules et chiffres';

  @override
  String get dont_have_account => 'Pas de compte?';

  @override
  String get already_have_account => 'Déjà un compte?';

  @override
  String get create_account => 'Créer un compte';

  @override
  String get full_name => 'Nom complet';

  @override
  String get first_name => 'Prénom';

  @override
  String get second_name => 'Deuxième nom';

  @override
  String get third_name => 'Troisième nom';

  @override
  String get fourth_name => 'Quatrième nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get location => 'Localisation';

  @override
  String get currency => 'Devise';

  @override
  String get account_type => 'Type de compte';

  @override
  String get buyer => 'Acheteur';

  @override
  String get seller => 'Vendeur';

  @override
  String get next => 'Suivant';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get loading => 'Chargement...';

  @override
  String get retry => 'Réessayer';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Info';

  @override
  String get user => 'Utilisateur';

  @override
  String get guest => 'Invité';

  @override
  String get login_success => 'Connexion réussie';

  @override
  String get login_failed => 'Échec de la connexion';

  @override
  String get signup_success => 'Compte créé avec succès';

  @override
  String get signup_failed => 'Échec de la création du compte';

  @override
  String get logout_success => 'Déconnexion réussie';

  @override
  String get password_reset_sent =>
      'Lien de réinitialisation envoyé à votre email';

  @override
  String get password_reset_failed => 'Échec de l\'envoi du lien';

  @override
  String get invalid_email => 'Veuillez entrer un email valide';

  @override
  String get invalid_password =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get email_required => 'L\'email est requis';

  @override
  String get password_required => 'Le mot de passe est requis';

  @override
  String get name_required => 'Le nom est requis';

  @override
  String get phone_required => 'Le numéro de téléphone est requis';

  @override
  String get valid_phone_number =>
      'Veuillez entrer un numéro valide (8-15 chiffres)';

  @override
  String get signup_subtitle => 'Créez votre compte vendeur';

  @override
  String get first => 'Premier';

  @override
  String get second => 'Deuxième';

  @override
  String get third => 'Troisième';

  @override
  String get fourth => 'Quatrième';

  @override
  String get phone_number => 'Numéro de téléphone';

  @override
  String get enter_email => 'Entrez votre email';

  @override
  String get enter_valid_email => 'Entrez un email valide';

  @override
  String get enter_password => 'Entrez un mot de passe';

  @override
  String get password_min_length =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get password_uppercase =>
      'Le mot de passe doit contenir au moins une majuscule';

  @override
  String get password_lowercase =>
      'Le mot de passe doit contenir au moins une minuscule';

  @override
  String get password_number =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get confirm_password_label => 'Confirmer le mot de passe';

  @override
  String get enter_confirm_password => 'Confirmez votre mot de passe';

  @override
  String get passwords_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String signup_failed_error(String error) {
    return 'Échec de l\'inscription: $error';
  }

  @override
  String already_have_account_login(String login) {
    return 'Déjà un compte? $login';
  }

  @override
  String get location_required_signup =>
      'La localisation est requise pour l\'inscription';

  @override
  String get location_permission_denied => 'Permission de localisation refusée';

  @override
  String get get_current_location => 'Obtenir la localisation actuelle';

  @override
  String get select_location => 'Sélectionner la localisation';

  @override
  String get continue_google => 'Continuer avec Google';

  @override
  String get creating_account => 'Création du compte...';

  @override
  String pending_orders_count(int count) {
    return '$count en attente';
  }

  @override
  String get daily_revenue => 'Revenu quotidien';

  @override
  String get weekly_revenue => 'Revenu hebdomadaire';

  @override
  String get monthly_revenue => 'Revenu mensuel';

  @override
  String get seller_dashboard => 'Tableau de bord';

  @override
  String get recent_activity => 'Activité récente';

  @override
  String get quick_actions => 'Actions rapides';

  @override
  String get view_all => 'Voir tout';

  @override
  String get no_activity => 'Aucune activité récente';

  @override
  String get sales => 'Ventes';

  @override
  String get products => 'Produits';

  @override
  String get customers => 'Clients';

  @override
  String get orders => 'Commandes';

  @override
  String get record_sale => 'Enregistrer une vente';

  @override
  String get add_product => 'Ajouter un produit';

  @override
  String get manage_products => 'Gérer les produits';

  @override
  String get manage_customers => 'Gérer les clients';

  @override
  String get track_orders => 'Suivre les commandes';

  @override
  String get no_customers => 'Pas encore de clients';

  @override
  String get no_products => 'Pas encore de produits';

  @override
  String get total_revenue => 'Revenu total';

  @override
  String get pending_orders => 'Commandes en attente';

  @override
  String get completed_orders => 'Commandes terminées';

  @override
  String welcome_message(String name) {
    return 'Bienvenue, $name!';
  }

  @override
  String get location_required => 'La localisation est requise';

  @override
  String get home => 'Accueil';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get notification_settings => 'Paramètres de notification';

  @override
  String get mark_all_read => 'Tout marquer comme lu';

  @override
  String get no_notifications => 'Pas encore de notifications';

  @override
  String get delete_notification => 'Supprimer la notification';

  @override
  String get delete_notification_confirm =>
      'Voulez-vous vraiment supprimer cette notification?';

  @override
  String get notification_deleted => 'Notification supprimée';

  @override
  String get my_profile => 'Mon profil';

  @override
  String get edit_profile => 'Modifier le profil';

  @override
  String get profile_updated => 'Profil mis à jour avec succès';

  @override
  String get profile_save_failed => 'Échec de l\'enregistrement du profil';

  @override
  String get profile_load_failed => 'Échec du chargement du profil';

  @override
  String get first_name_placeholder => 'Entrez votre prénom';

  @override
  String get second_name_placeholder => 'Entrez votre deuxième nom';

  @override
  String get third_name_placeholder => 'Entrez votre troisième nom';

  @override
  String get fourth_name_placeholder => 'Entrez votre quatrième nom';

  @override
  String get email_placeholder => 'Entrez votre email';

  @override
  String get phone_placeholder => 'Entrez votre numéro';

  @override
  String get location_placeholder => 'Entrez votre localisation';

  @override
  String get product => 'Produit';

  @override
  String get all_products => 'Tous les produits';

  @override
  String get my_products => 'Mes produits';

  @override
  String get edit_product => 'Modifier le produit';

  @override
  String get delete_product => 'Supprimer le produit';

  @override
  String get delete_product_confirm =>
      'Voulez-vous vraiment supprimer ce produit?';

  @override
  String get product_name => 'Nom du produit';

  @override
  String get product_description => 'Description';

  @override
  String get product_price => 'Prix';

  @override
  String get product_category => 'Catégorie';

  @override
  String get product_brand => 'Marque';

  @override
  String get product_stock => 'Stock';

  @override
  String get product_images => 'Images';

  @override
  String get product_added => 'Produit ajouté avec succès';

  @override
  String get product_updated => 'Produit mis à jour avec succès';

  @override
  String get product_deleted => 'Produit supprimé avec succès';

  @override
  String get product_save_failed => 'Échec de l\'enregistrement du produit';

  @override
  String get out_of_stock => 'Rupture de stock';

  @override
  String get in_stock => 'En stock';

  @override
  String get search_products => 'Rechercher des produits...';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get sort_by => 'Trier par';

  @override
  String get price_low_to_high => 'Prix: Croissant';

  @override
  String get price_high_to_low => 'Prix: Décroissant';

  @override
  String get name_a_to_z => 'Nom: A à Z';

  @override
  String get name_z_to_a => 'Nom: Z à A';

  @override
  String get categories => 'Catégories';

  @override
  String get category => 'Catégorie';

  @override
  String get all_categories => 'Toutes les catégories';

  @override
  String get electronics => 'Électronique';

  @override
  String get clothing => 'Vêtements';

  @override
  String get home_garden => 'Maison et Jardin';

  @override
  String get sports => 'Sports';

  @override
  String get books => 'Livres';

  @override
  String get toys => 'Jouets';

  @override
  String get health_beauty => 'Santé et Beauté';

  @override
  String get automotive => 'Automobile';

  @override
  String get other => 'Autre';

  @override
  String get cart => 'Panier';

  @override
  String get my_cart => 'Mon panier';

  @override
  String get add_to_cart => 'Ajouter au panier';

  @override
  String get remove_from_cart => 'Retirer du panier';

  @override
  String get view_cart => 'Voir le panier';

  @override
  String get checkout => 'Commander';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get tax => 'Taxe';

  @override
  String get shipping => 'Livraison';

  @override
  String get discount => 'Réduction';

  @override
  String get apply_discount => 'Appliquer la réduction';

  @override
  String get promo_code => 'Code promo';

  @override
  String get empty_cart => 'Votre panier est vide';

  @override
  String get continue_shopping => 'Continuer les achats';

  @override
  String get wishlist => 'Liste de souhaits';

  @override
  String get my_wishlist => 'Ma liste';

  @override
  String get add_to_wishlist => 'Ajouter à la liste';

  @override
  String get remove_from_wishlist => 'Retirer de la liste';

  @override
  String get remove_item => 'Retirer l\'article';

  @override
  String remove_from_wishlist_confirm(Object productName) {
    return 'Retirer \"$productName\" de votre liste?';
  }

  @override
  String get removed_from_wishlist => 'Retiré de la liste';

  @override
  String get empty_wishlist => 'Votre liste est vide';

  @override
  String get browse_products => 'Parcourir les produits';

  @override
  String get my_orders => 'Mes commandes';

  @override
  String get order => 'Commande';

  @override
  String get order_id => 'ID de commande';

  @override
  String get order_date => 'Date de commande';

  @override
  String get order_status => 'Statut';

  @override
  String get order_total => 'Total';

  @override
  String get order_details => 'Détails';

  @override
  String get order_placed => 'Commande passée avec succès';

  @override
  String get order_failed => 'Échec de la commande';

  @override
  String get pending => 'En attente';

  @override
  String get confirmed => 'Confirmé';

  @override
  String get processing => 'En cours';

  @override
  String get shipped => 'Expédié';

  @override
  String get delivered => 'Livré';

  @override
  String get cancelled => 'Annulé';

  @override
  String get refunded => 'Remboursé';

  @override
  String get track_order => 'Suivre la commande';

  @override
  String get cancel_order => 'Annuler la commande';

  @override
  String get cancel_order_confirm =>
      'Voulez-vous vraiment annuler cette commande?';

  @override
  String get chat => 'Discussion';

  @override
  String get chats => 'Discussions';

  @override
  String get messages => 'Messages';

  @override
  String get message => 'Message';

  @override
  String get type_message => 'Écrivez un message...';

  @override
  String get send => 'Envoyer';

  @override
  String get send_message => 'Envoyer le message';

  @override
  String get no_chats => 'Pas encore de discussions';

  @override
  String get no_messages => 'Pas encore de messages';

  @override
  String get start_chat => 'Commencer une discussion';

  @override
  String get chat_with => 'Discuter avec';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get typing => 'En train d\'écrire...';

  @override
  String get seen => 'Vu';

  @override
  String get image_message => 'Image';

  @override
  String get file_message => 'Fichier';

  @override
  String get deal_proposal => 'Proposition d\'affaire';

  @override
  String get view_deal => 'Voir l\'affaire';

  @override
  String get accept_deal => 'Accepter';

  @override
  String get reject_deal => 'Refuser';

  @override
  String get deal_accepted => 'Affaire acceptée';

  @override
  String get deal_rejected => 'Affaire refusée';

  @override
  String get commission_rate => 'Taux de commission';

  @override
  String get negotiate => 'Négocier';

  @override
  String get analytics => 'Analytique';

  @override
  String get revenue => 'Revenu';

  @override
  String get views => 'Vues';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get this_week => 'Cette semaine';

  @override
  String get this_month => 'Ce mois';

  @override
  String get this_year => 'Cette année';

  @override
  String get total_sales => 'Ventes totales';

  @override
  String get total_orders => 'Commandes totales';

  @override
  String get total_products => 'Produits totaux';

  @override
  String get average_order_value => 'Valeur moyenne';

  @override
  String get top_products => 'Produits populaires';

  @override
  String get recent_sales => 'Ventes récentes';

  @override
  String get sales_chart => 'Graphique des ventes';

  @override
  String get revenue_chart => 'Graphique des revenus';

  @override
  String get become_seller => 'Devenir vendeur';

  @override
  String get seller_profile => 'Profil vendeur';

  @override
  String get seller_info => 'Informations vendeur';

  @override
  String get seller_verified => 'Vendeur vérifié';

  @override
  String get seller_not_verified => 'Non vérifié';

  @override
  String get is_verified => 'Vérifié';

  @override
  String get verification_status => 'Statut de vérification';

  @override
  String get account_balance => 'Solde du compte';

  @override
  String get withdraw => 'Retirer';

  @override
  String get withdrawal_history => 'Historique des retraits';

  @override
  String get settings_general => 'Paramètres généraux';

  @override
  String get settings_account => 'Paramètres du compte';

  @override
  String get settings_privacy => 'Paramètres de confidentialité';

  @override
  String get settings_security => 'Paramètres de sécurité';

  @override
  String get settings_notifications => 'Paramètres de notification';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_theme => 'Thème';

  @override
  String get dark_mode => 'Mode sombre';

  @override
  String get light_mode => 'Mode clair';

  @override
  String get system_theme => 'Thème système';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get arabic => 'Arabe';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get turkish => 'Turc';

  @override
  String get german => 'Allemand';

  @override
  String get chinese => 'Chinois';

  @override
  String get change_language => 'Changer la langue';

  @override
  String get change_password => 'Changer le mot de passe';

  @override
  String get current_password => 'Mot de passe actuel';

  @override
  String get new_password => 'Nouveau mot de passe';

  @override
  String get confirm_new_password => 'Confirmer le nouveau mot de passe';

  @override
  String get password_changed => 'Mot de passe changé avec succès';

  @override
  String get password_change_failed => 'Échec du changement de mot de passe';

  @override
  String get biometric => 'Authentification biométrique';

  @override
  String get enable_biometric => 'Activer la biométrie';

  @override
  String get disable_biometric => 'Désactiver la biométrie';

  @override
  String get biometric_enabled => 'Biométrie activée';

  @override
  String get biometric_disabled => 'Biométrie désactivée';

  @override
  String get search => 'Rechercher';

  @override
  String get search_hint => 'Rechercher...';

  @override
  String get no_results => 'Aucun résultat trouvé';

  @override
  String get try_different_search => 'Essayez un autre terme';

  @override
  String get filters => 'Filtres';

  @override
  String get price_range => 'Fourchette de prix';

  @override
  String get min_price => 'Prix min';

  @override
  String get max_price => 'Prix max';

  @override
  String get apply_filters => 'Appliquer les filtres';

  @override
  String get clear_filters => 'Effacer les filtres';

  @override
  String get shipping_address => 'Adresse de livraison';

  @override
  String get billing_address => 'Adresse de facturation';

  @override
  String get address_line_1 => 'Adresse ligne 1';

  @override
  String get address_line_2 => 'Adresse ligne 2';

  @override
  String get city => 'Ville';

  @override
  String get state => 'Région';

  @override
  String get country => 'Pays';

  @override
  String get postal_code => 'Code postal';

  @override
  String get zip_code => 'Code postal';

  @override
  String get select_country => 'Sélectionner le pays';

  @override
  String get select_city => 'Sélectionner la ville';

  @override
  String get payment_method => 'Mode de paiement';

  @override
  String get payment_methods => 'Modes de paiement';

  @override
  String get add_payment_method => 'Ajouter un mode de paiement';

  @override
  String get credit_card => 'Carte de crédit';

  @override
  String get debit_card => 'Carte de débit';

  @override
  String get cash_on_delivery => 'Paiement à la livraison';

  @override
  String get bank_transfer => 'Virement bancaire';

  @override
  String get wallet => 'Portefeuille';

  @override
  String get card_number => 'Numéro de carte';

  @override
  String get card_holder => 'Nom du titulaire';

  @override
  String get expiry_date => 'Date d\'expiration';

  @override
  String get cvv => 'CVV';

  @override
  String get reviews => 'Avis';

  @override
  String get review => 'Avis';

  @override
  String get write_review => 'Écrire un avis';

  @override
  String get rating => 'Note';

  @override
  String get ratings => 'Notes';

  @override
  String get no_reviews => 'Pas encore d\'avis';

  @override
  String get add_review => 'Ajouter un avis';

  @override
  String get review_title => 'Titre de l\'avis';

  @override
  String get review_comment => 'Votre avis';

  @override
  String get review_submitted => 'Avis soumis avec succès';

  @override
  String get review_failed => 'Échec de la soumission';

  @override
  String get help => 'Aide';

  @override
  String get help_center => 'Centre d\'aide';

  @override
  String get faq => 'FAQ';

  @override
  String get contact_us => 'Nous contacter';

  @override
  String get about => 'À propos';

  @override
  String get about_us => 'À propos de nous';

  @override
  String get terms_of_service => 'Conditions d\'utilisation';

  @override
  String get privacy_policy => 'Politique de confidentialité';

  @override
  String get version => 'Version';

  @override
  String get are_you_sure => 'Êtes-vous sûr?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Fermer';

  @override
  String get done => 'Terminé';

  @override
  String get finish => 'Finir';

  @override
  String get back => 'Retour';

  @override
  String get continue_btn => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get learn_more => 'En savoir plus';

  @override
  String get see_more => 'Voir plus';

  @override
  String get see_less => 'Voir moins';

  @override
  String get image_pick_failed => 'Échec de la sélection d\'image';

  @override
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get take_photo => 'Prendre une photo';

  @override
  String get choose_from_gallery => 'Choisir dans la galerie';

  @override
  String get upload_image => 'Télécharger une image';

  @override
  String get remove_image => 'Supprimer l\'image';

  @override
  String get permission_required => 'Permission requise';

  @override
  String get permission_denied => 'Permission refusée';

  @override
  String get permission_location => 'La permission de localisation est requise';

  @override
  String get permission_camera => 'La permission de caméra est requise';

  @override
  String get permission_storage => 'La permission de stockage est requise';

  @override
  String get permission_notification =>
      'La permission de notification est requise';

  @override
  String get open_settings => 'Ouvrir les paramètres';

  @override
  String get connection_lost => 'Connexion perdue';

  @override
  String get check_internet => 'Vérifiez votre connexion internet';

  @override
  String get server_error => 'Erreur serveur, réessayez plus tard';

  @override
  String get something_went_wrong => 'Quelque chose s\'est mal passé';

  @override
  String get try_again => 'Réessayer';

  @override
  String get copied_to_clipboard => 'Copié dans le presse-papiers';

  @override
  String get share => 'Partager';

  @override
  String get copy => 'Copier';

  @override
  String get qr_code => 'Code QR';

  @override
  String get scan_qr => 'Scanner le code QR';

  @override
  String get qr_product_info => 'Informations sur le produit';

  @override
  String get nearby => 'À proximité';

  @override
  String get nearby_sellers => 'Vendeurs à proximité';

  @override
  String get nearby_products => 'Produits à proximité';

  @override
  String get distance => 'Distance';

  @override
  String get km => 'km';

  @override
  String get m => 'm';

  @override
  String get deals => 'Affaires';

  @override
  String get my_deals => 'Mes affaires';

  @override
  String get active_deals => 'Affaires actives';

  @override
  String get completed_deals => 'Affaires terminées';

  @override
  String get deal_status => 'Statut de l\'affaire';

  @override
  String get create_deal => 'Créer une affaire';

  @override
  String get update_deal => 'Mettre à jour l\'affaire';

  @override
  String get presence_online => 'En ligne';

  @override
  String get presence_offline => 'Hors ligne';

  @override
  String get presence_away => 'Absent';

  @override
  String get presence_busy => 'Occupé';

  @override
  String get refresh => 'Actualiser';

  @override
  String get pull_to_refresh => 'Tirez pour actualiser';

  @override
  String get last_updated => 'Dernière mise à jour';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get not_available => 'Non disponible sur cet appareil';

  @override
  String get not_enrolled => 'Pas de biométrie enregistrée';

  @override
  String get browsing_history => 'Historique de navigation';

  @override
  String get coming_soon => 'Bientôt disponible';

  @override
  String get push_notifications => 'Notifications push';

  @override
  String get select_language => 'Sélectionner la langue';

  @override
  String language_changed(String lang) {
    return 'Langue changée en $lang';
  }

  @override
  String get low_stock_alert => 'Alerte stock bas';

  @override
  String only_left(Object count) {
    return 'Il ne reste que $count';
  }

  @override
  String last_days(Object days) {
    return 'Les $days derniers jours';
  }

  @override
  String get transactions => 'transactions';

  @override
  String get active_customers => 'actifs';

  @override
  String get add_product_action => 'Ajouter un produit';

  @override
  String get record_sale_action => 'Enregistrer une vente';

  @override
  String get view_customers_action => 'Voir les clients';

  @override
  String get sales_report => 'Rapport de ventes';

  @override
  String low_stock_product(String product, int count) {
    return '$product - Il ne reste que $count';
  }

  @override
  String last_days_key(int days) {
    return 'Les $days derniers jours';
  }

  @override
  String pending_count(int count) {
    return '$count en attente';
  }

  @override
  String only_count_left(int count) {
    return 'Il ne reste que $count';
  }

  @override
  String get good_morning => 'Bonjour';

  @override
  String get good_afternoon => 'Bon après-midi';

  @override
  String get good_evening => 'Bonsoir';

  @override
  String get manage_store => 'Gérer la boutique';

  @override
  String get quick_stats => 'Statistiques rapides';
}
