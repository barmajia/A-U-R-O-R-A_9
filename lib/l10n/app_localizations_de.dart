// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app_title => 'Aurora E-commerce';

  @override
  String get app_title_desc => 'Aurora E-commerce Plattform';

  @override
  String get welcome_back => 'Willkommen zurück!';

  @override
  String get welcome => 'Willkommen';

  @override
  String get login => 'Anmelden';

  @override
  String get signup => 'Registrieren';

  @override
  String get logout => 'Abmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirm_password => 'Passwort bestätigen';

  @override
  String get forgot_password => 'Passwort vergessen?';

  @override
  String get reset_password => 'Passwort zurücksetzen';

  @override
  String get send_reset_link => 'Link senden';

  @override
  String get back_to_login => 'Zurück zur Anmeldung';

  @override
  String get or_continue_with => 'ODER';

  @override
  String get login_subtitle => 'Anmelden um fortzufahren';

  @override
  String get continue_with_google => 'Mit Google fortfahren';

  @override
  String get restricted_account =>
      'Diese App ist auf Verkäuferkonten beschränkt.';

  @override
  String get password_complexity =>
      'Passwort muss Großbuchstaben, Kleinbuchstaben und Zahlen enthalten';

  @override
  String get dont_have_account => 'Kein Konto?';

  @override
  String get already_have_account => 'Bereits ein Konto?';

  @override
  String get create_account => 'Konto erstellen';

  @override
  String get full_name => 'Vollständiger Name';

  @override
  String get first_name => 'Vorname';

  @override
  String get second_name => 'Zweiter Name';

  @override
  String get third_name => 'Dritter Name';

  @override
  String get fourth_name => 'Vierter Name';

  @override
  String get phone => 'Telefon';

  @override
  String get location => 'Standort';

  @override
  String get currency => 'Währung';

  @override
  String get account_type => 'Kontotyp';

  @override
  String get buyer => 'Käufer';

  @override
  String get seller => 'Verkäufer';

  @override
  String get next => 'Weiter';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get save_changes => 'Änderungen speichern';

  @override
  String get loading => 'Laden...';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get info => 'Info';

  @override
  String get user => 'Benutzer';

  @override
  String get guest => 'Gast';

  @override
  String get login_success => 'Anmeldung erfolgreich';

  @override
  String get login_failed => 'Anmeldung fehlgeschlagen';

  @override
  String get signup_success => 'Konto erfolgreich erstellt';

  @override
  String get signup_failed => 'Konto konnte nicht erstellt werden';

  @override
  String get logout_success => 'Erfolgreich abgemeldet';

  @override
  String get password_reset_sent =>
      'Zurücksetzungslink an Ihre E-Mail gesendet';

  @override
  String get password_reset_failed => 'Link konnte nicht gesendet werden';

  @override
  String get invalid_email => 'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get invalid_password => 'Passwort muss mindestens 6 Zeichen haben';

  @override
  String get passwords_do_not_match => 'Passwörter stimmen nicht überein';

  @override
  String get email_required => 'E-Mail ist erforderlich';

  @override
  String get password_required => 'Passwort ist erforderlich';

  @override
  String get name_required => 'Name ist erforderlich';

  @override
  String get phone_required => 'Telefonnummer ist erforderlich';

  @override
  String get valid_phone_number =>
      'Bitte geben Sie eine gültige Nummer ein (8-15 Ziffern)';

  @override
  String get signup_subtitle => 'Erstellen Sie Ihr Verkäuferkonto';

  @override
  String get first => 'Erste';

  @override
  String get second => 'Zweite';

  @override
  String get third => 'Dritte';

  @override
  String get fourth => 'Vierte';

  @override
  String get phone_number => 'Telefonnummer';

  @override
  String get enter_email => 'E-Mail eingeben';

  @override
  String get enter_valid_email => 'Gültige E-Mail eingeben';

  @override
  String get enter_password => 'Passwort eingeben';

  @override
  String get password_min_length => 'Passwort muss mindestens 8 Zeichen haben';

  @override
  String get password_uppercase =>
      'Passwort muss mindestens einen Großbuchstaben enthalten';

  @override
  String get password_lowercase =>
      'Passwort muss mindestens einen Kleinbuchstaben enthalten';

  @override
  String get password_number => 'Passwort muss mindestens eine Zahl enthalten';

  @override
  String get confirm_password_label => 'Passwort bestätigen';

  @override
  String get enter_confirm_password => 'Passwort bestätigen';

  @override
  String get passwords_not_match => 'Passwörter stimmen nicht überein';

  @override
  String signup_failed_error(String error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String already_have_account_login(String login) {
    return 'Bereits ein Konto? $login';
  }

  @override
  String get location_required_signup =>
      'Standort ist für Registrierung erforderlich';

  @override
  String get location_permission_denied => 'Standortberechtigung verweigert';

  @override
  String get get_current_location => 'Aktuellen Standort abrufen';

  @override
  String get select_location => 'Standort auswählen';

  @override
  String get continue_google => 'Mit Google fortfahren';

  @override
  String get creating_account => 'Konto wird erstellt...';

  @override
  String pending_orders_count(int count) {
    return '$count ausstehend';
  }

  @override
  String get daily_revenue => 'Tagesumsatz';

  @override
  String get weekly_revenue => 'Wochenumsatz';

  @override
  String get monthly_revenue => 'Monatsumsatz';

  @override
  String get seller_dashboard => 'Verkäufer-Dashboard';

  @override
  String get recent_activity => 'Letzte Aktivität';

  @override
  String get quick_actions => 'Schnellaktionen';

  @override
  String get view_all => 'Alle anzeigen';

  @override
  String get no_activity => 'Keine aktuelle Aktivität';

  @override
  String get sales => 'Verkäufe';

  @override
  String get products => 'Produkte';

  @override
  String get customers => 'Kunden';

  @override
  String get orders => 'Bestellungen';

  @override
  String get record_sale => 'Verkauf erfassen';

  @override
  String get add_product => 'Produkt hinzufügen';

  @override
  String get manage_products => 'Produkte verwalten';

  @override
  String get manage_customers => 'Kunden verwalten';

  @override
  String get track_orders => 'Bestellungen verfolgen';

  @override
  String get no_customers => 'Noch keine Kunden';

  @override
  String get no_products => 'Noch keine Produkte';

  @override
  String get total_revenue => 'Gesamtumsatz';

  @override
  String get pending_orders => 'Ausstehende Bestellungen';

  @override
  String get completed_orders => 'Abgeschlossene Bestellungen';

  @override
  String welcome_message(String name) {
    return 'Willkommen, $name!';
  }

  @override
  String get location_required => 'Standort ist erforderlich';

  @override
  String get home => 'Startseite';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notification_settings => 'Benachrichtigungseinstellungen';

  @override
  String get mark_all_read => 'Alle als gelesen markieren';

  @override
  String get no_notifications => 'Noch keine Benachrichtigungen';

  @override
  String get delete_notification => 'Benachrichtigung löschen';

  @override
  String get delete_notification_confirm =>
      'Möchten Sie diese Benachrichtigung wirklich löschen?';

  @override
  String get notification_deleted => 'Benachrichtigung gelöscht';

  @override
  String get my_profile => 'Mein Profil';

  @override
  String get edit_profile => 'Profil bearbeiten';

  @override
  String get profile_updated => 'Profil erfolgreich aktualisiert';

  @override
  String get profile_save_failed => 'Profil konnte nicht gespeichert werden';

  @override
  String get profile_load_failed => 'Profil konnte nicht geladen werden';

  @override
  String get first_name_placeholder => 'Vorname eingeben';

  @override
  String get second_name_placeholder => 'Zweiten Namen eingeben';

  @override
  String get third_name_placeholder => 'Dritten Namen eingeben';

  @override
  String get fourth_name_placeholder => 'Vierten Namen eingeben';

  @override
  String get email_placeholder => 'E-Mail eingeben';

  @override
  String get phone_placeholder => 'Telefonnummer eingeben';

  @override
  String get location_placeholder => 'Standort eingeben';

  @override
  String get product => 'Produkt';

  @override
  String get all_products => 'Alle Produkte';

  @override
  String get my_products => 'Meine Produkte';

  @override
  String get edit_product => 'Produkt bearbeiten';

  @override
  String get delete_product => 'Produkt löschen';

  @override
  String get delete_product_confirm =>
      'Möchten Sie dieses Produkt wirklich löschen?';

  @override
  String get product_name => 'Produktname';

  @override
  String get product_description => 'Beschreibung';

  @override
  String get product_price => 'Preis';

  @override
  String get product_category => 'Kategorie';

  @override
  String get product_brand => 'Marke';

  @override
  String get product_stock => 'Bestand';

  @override
  String get product_images => 'Bilder';

  @override
  String get product_added => 'Produkt erfolgreich hinzugefügt';

  @override
  String get product_updated => 'Produkt erfolgreich aktualisiert';

  @override
  String get product_deleted => 'Produkt erfolgreich gelöscht';

  @override
  String get product_save_failed => 'Produkt konnte nicht gespeichert werden';

  @override
  String get out_of_stock => 'Nicht vorrätig';

  @override
  String get in_stock => 'Auf Lager';

  @override
  String get search_products => 'Produkte suchen...';

  @override
  String get filter => 'Filtern';

  @override
  String get sort => 'Sortieren';

  @override
  String get sort_by => 'Sortieren nach';

  @override
  String get price_low_to_high => 'Preis: Niedrig bis Hoch';

  @override
  String get price_high_to_low => 'Preis: Hoch bis Niedrig';

  @override
  String get name_a_to_z => 'Name: A bis Z';

  @override
  String get name_z_to_a => 'Name: Z bis A';

  @override
  String get categories => 'Kategorien';

  @override
  String get category => 'Kategorie';

  @override
  String get all_categories => 'Alle Kategorien';

  @override
  String get electronics => 'Elektronik';

  @override
  String get clothing => 'Kleidung';

  @override
  String get home_garden => 'Haus & Garten';

  @override
  String get sports => 'Sport';

  @override
  String get books => 'Bücher';

  @override
  String get toys => 'Spielzeug';

  @override
  String get health_beauty => 'Gesundheit & Schönheit';

  @override
  String get automotive => 'Automobil';

  @override
  String get other => 'Sonstiges';

  @override
  String get cart => 'Warenkorb';

  @override
  String get my_cart => 'Mein Warenkorb';

  @override
  String get add_to_cart => 'In den Warenkorb';

  @override
  String get remove_from_cart => 'Aus dem Warenkorb entfernen';

  @override
  String get view_cart => 'Warenkorb anzeigen';

  @override
  String get checkout => 'Zur Kasse';

  @override
  String get total => 'Gesamt';

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get tax => 'Steuer';

  @override
  String get shipping => 'Versand';

  @override
  String get discount => 'Rabatt';

  @override
  String get apply_discount => 'Rabatt anwenden';

  @override
  String get promo_code => 'Aktionscode';

  @override
  String get empty_cart => 'Ihr Warenkorb ist leer';

  @override
  String get continue_shopping => 'Weiter einkaufen';

  @override
  String get wishlist => 'Wunschliste';

  @override
  String get my_wishlist => 'Meine Wunschliste';

  @override
  String get add_to_wishlist => 'Zur Wunschliste hinzufügen';

  @override
  String get remove_from_wishlist => 'Von Wunschliste entfernen';

  @override
  String get remove_item => 'Artikel entfernen';

  @override
  String remove_from_wishlist_confirm(Object productName) {
    return '\"$productName\" von der Wunschliste entfernen?';
  }

  @override
  String get removed_from_wishlist => 'Von Wunschliste entfernt';

  @override
  String get empty_wishlist => 'Ihre Wunschliste ist leer';

  @override
  String get browse_products => 'Produkte durchsuchen';

  @override
  String get my_orders => 'Meine Bestellungen';

  @override
  String get order => 'Bestellung';

  @override
  String get order_id => 'Bestell-ID';

  @override
  String get order_date => 'Bestelldatum';

  @override
  String get order_status => 'Status';

  @override
  String get order_total => 'Gesamt';

  @override
  String get order_details => 'Details';

  @override
  String get order_placed => 'Bestellung erfolgreich aufgegeben';

  @override
  String get order_failed => 'Bestellung konnte nicht aufgegeben werden';

  @override
  String get pending => 'Ausstehend';

  @override
  String get confirmed => 'Bestätigt';

  @override
  String get processing => 'In Bearbeitung';

  @override
  String get shipped => 'Versendet';

  @override
  String get delivered => 'Zugestellt';

  @override
  String get cancelled => 'Storniert';

  @override
  String get refunded => 'Erstattet';

  @override
  String get track_order => 'Bestellung verfolgen';

  @override
  String get cancel_order => 'Bestellung stornieren';

  @override
  String get cancel_order_confirm =>
      'Möchten Sie diese Bestellung wirklich stornieren?';

  @override
  String get chat => 'Chat';

  @override
  String get chats => 'Chats';

  @override
  String get messages => 'Nachrichten';

  @override
  String get message => 'Nachricht';

  @override
  String get type_message => 'Nachricht eingeben...';

  @override
  String get send => 'Senden';

  @override
  String get send_message => 'Nachricht senden';

  @override
  String get no_chats => 'Noch keine Chats';

  @override
  String get no_messages => 'Noch keine Nachrichten';

  @override
  String get start_chat => 'Chat starten';

  @override
  String get chat_with => 'Chat mit';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get typing => 'Tippt...';

  @override
  String get seen => 'Gelesen';

  @override
  String get image_message => 'Bild';

  @override
  String get file_message => 'Datei';

  @override
  String get deal_proposal => 'Angebot';

  @override
  String get view_deal => 'Angebot anzeigen';

  @override
  String get accept_deal => 'Annehmen';

  @override
  String get reject_deal => 'Ablehnen';

  @override
  String get deal_accepted => 'Angebot angenommen';

  @override
  String get deal_rejected => 'Angebot abgelehnt';

  @override
  String get commission_rate => 'Provisionssatz';

  @override
  String get negotiate => 'Verhandeln';

  @override
  String get analytics => 'Analytik';

  @override
  String get revenue => 'Umsatz';

  @override
  String get views => 'Aufrufe';

  @override
  String get today => 'Heute';

  @override
  String get this_week => 'Diese Woche';

  @override
  String get this_month => 'Dieser Monat';

  @override
  String get this_year => 'Dieses Jahr';

  @override
  String get total_sales => 'Gesamtverkäufe';

  @override
  String get total_orders => 'Gesamtbestellungen';

  @override
  String get total_products => 'Gesamtprodukte';

  @override
  String get average_order_value => 'Durchschnittlicher Bestellwert';

  @override
  String get top_products => 'Beliebte Produkte';

  @override
  String get recent_sales => 'Letzte Verkäufe';

  @override
  String get sales_chart => 'Verkaufsdiagramm';

  @override
  String get revenue_chart => 'Umsatzdiagramm';

  @override
  String get become_seller => 'Verkäufer werden';

  @override
  String get seller_profile => 'Verkäuferprofil';

  @override
  String get seller_info => 'Verkäuferinformationen';

  @override
  String get seller_verified => 'Verifizierter Verkäufer';

  @override
  String get seller_not_verified => 'Nicht verifiziert';

  @override
  String get is_verified => 'Verifiziert';

  @override
  String get verification_status => 'Verifizierungsstatus';

  @override
  String get account_balance => 'Kontostand';

  @override
  String get withdraw => 'Auszahlen';

  @override
  String get withdrawal_history => 'Auszahlungsverlauf';

  @override
  String get settings_general => 'Allgemeine Einstellungen';

  @override
  String get settings_account => 'Kontoeinstellungen';

  @override
  String get settings_privacy => 'Datenschutzeinstellungen';

  @override
  String get settings_security => 'Sicherheitseinstellungen';

  @override
  String get settings_notifications => 'Benachrichtigungseinstellungen';

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_theme => 'Thema';

  @override
  String get dark_mode => 'Dunkler Modus';

  @override
  String get light_mode => 'Heller Modus';

  @override
  String get system_theme => 'Systemthema';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get arabic => 'Arabisch';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get turkish => 'Turkish';

  @override
  String get german => 'German';

  @override
  String get chinese => 'Chinese';

  @override
  String get change_language => 'Sprache ändern';

  @override
  String get change_password => 'Passwort ändern';

  @override
  String get current_password => 'Aktuelles Passwort';

  @override
  String get new_password => 'Neues Passwort';

  @override
  String get confirm_new_password => 'Neues Passwort bestätigen';

  @override
  String get password_changed => 'Passwort erfolgreich geändert';

  @override
  String get password_change_failed => 'Passwort konnte nicht geändert werden';

  @override
  String get biometric => 'Biometrische Authentifizierung';

  @override
  String get enable_biometric => 'Biometrie aktivieren';

  @override
  String get disable_biometric => 'Biometrie deaktivieren';

  @override
  String get biometric_enabled => 'Biometrie aktiviert';

  @override
  String get biometric_disabled => 'Biometrie deaktiviert';

  @override
  String get search => 'Suchen';

  @override
  String get search_hint => 'Suchen...';

  @override
  String get no_results => 'Keine Ergebnisse gefunden';

  @override
  String get try_different_search => 'Versuchen Sie einen anderen Suchbegriff';

  @override
  String get filters => 'Filter';

  @override
  String get price_range => 'Preisbereich';

  @override
  String get min_price => 'Min. Preis';

  @override
  String get max_price => 'Max. Preis';

  @override
  String get apply_filters => 'Filter anwenden';

  @override
  String get clear_filters => 'Filter löschen';

  @override
  String get shipping_address => 'Lieferadresse';

  @override
  String get billing_address => 'Rechnungsadresse';

  @override
  String get address_line_1 => 'Adresszeile 1';

  @override
  String get address_line_2 => 'Adresszeile 2';

  @override
  String get city => 'Stadt';

  @override
  String get state => 'Region';

  @override
  String get country => 'Land';

  @override
  String get postal_code => 'Postleitzahl';

  @override
  String get zip_code => 'PLZ';

  @override
  String get select_country => 'Land auswählen';

  @override
  String get select_city => 'Stadt auswählen';

  @override
  String get payment_method => 'Zahlungsmethode';

  @override
  String get payment_methods => 'Zahlungsmethoden';

  @override
  String get add_payment_method => 'Zahlungsmethode hinzufügen';

  @override
  String get credit_card => 'Kreditkarte';

  @override
  String get debit_card => 'Debitkarte';

  @override
  String get cash_on_delivery => 'Nachnahme';

  @override
  String get bank_transfer => 'Banküberweisung';

  @override
  String get wallet => 'Geldbörse';

  @override
  String get card_number => 'Kartennummer';

  @override
  String get card_holder => 'Karteninhaber';

  @override
  String get expiry_date => 'Ablaufdatum';

  @override
  String get cvv => 'CVV';

  @override
  String get reviews => 'Bewertungen';

  @override
  String get review => 'Bewertung';

  @override
  String get write_review => 'Bewertung schreiben';

  @override
  String get rating => 'Bewertung';

  @override
  String get ratings => 'Bewertungen';

  @override
  String get no_reviews => 'Noch keine Bewertungen';

  @override
  String get add_review => 'Bewertung hinzufügen';

  @override
  String get review_title => 'Titel der Bewertung';

  @override
  String get review_comment => 'Ihre Bewertung';

  @override
  String get review_submitted => 'Bewertung erfolgreich eingereicht';

  @override
  String get review_failed => 'Bewertung konnte nicht eingereicht werden';

  @override
  String get help => 'Hilfe';

  @override
  String get help_center => 'Hilfecenter';

  @override
  String get faq => 'FAQ';

  @override
  String get contact_us => 'Kontakt';

  @override
  String get about => 'Über';

  @override
  String get about_us => 'Über uns';

  @override
  String get terms_of_service => 'Nutzungsbedingungen';

  @override
  String get privacy_policy => 'Datenschutzrichtlinie';

  @override
  String get version => 'Version';

  @override
  String get are_you_sure => 'Sind Sie sicher?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Schließen';

  @override
  String get done => 'Fertig';

  @override
  String get finish => 'Beenden';

  @override
  String get back => 'Zurück';

  @override
  String get continue_btn => 'Fortfahren';

  @override
  String get skip => 'Überspringen';

  @override
  String get learn_more => 'Mehr erfahren';

  @override
  String get see_more => 'Mehr anzeigen';

  @override
  String get see_less => 'Weniger anzeigen';

  @override
  String get image_pick_failed => 'Bild konnte nicht ausgewählt werden';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String get take_photo => 'Foto aufnehmen';

  @override
  String get choose_from_gallery => 'Aus Galerie wählen';

  @override
  String get upload_image => 'Bild hochladen';

  @override
  String get remove_image => 'Bild entfernen';

  @override
  String get permission_required => 'Berechtigung erforderlich';

  @override
  String get permission_denied => 'Berechtigung verweigert';

  @override
  String get permission_location =>
      'Standortberechtigung für diese Funktion erforderlich';

  @override
  String get permission_camera => 'Kameraberechtigung erforderlich';

  @override
  String get permission_storage => 'Speicherberechtigung erforderlich';

  @override
  String get permission_notification =>
      'Benachrichtigungsberechtigung erforderlich';

  @override
  String get open_settings => 'Einstellungen öffnen';

  @override
  String get connection_lost => 'Verbindung verloren';

  @override
  String get check_internet => 'Bitte überprüfen Sie Ihre Internetverbindung';

  @override
  String get server_error => 'Serverfehler, bitte später erneut versuchen';

  @override
  String get something_went_wrong => 'Etwas ist schief gelaufen';

  @override
  String get try_again => 'Erneut versuchen';

  @override
  String get copied_to_clipboard => 'In Zwischenablage kopiert';

  @override
  String get share => 'Teilen';

  @override
  String get copy => 'Kopieren';

  @override
  String get qr_code => 'QR-Code';

  @override
  String get scan_qr => 'QR-Code scannen';

  @override
  String get qr_product_info => 'Produktinformationen';

  @override
  String get nearby => 'In der Nähe';

  @override
  String get nearby_sellers => 'Verkäufer in der Nähe';

  @override
  String get nearby_products => 'Produkte in der Nähe';

  @override
  String get distance => 'Entfernung';

  @override
  String get km => 'km';

  @override
  String get m => 'm';

  @override
  String get deals => 'Geschäfte';

  @override
  String get my_deals => 'Meine Geschäfte';

  @override
  String get active_deals => 'Aktive Geschäfte';

  @override
  String get completed_deals => 'Abgeschlossene Geschäfte';

  @override
  String get deal_status => 'Geschäftsstatus';

  @override
  String get create_deal => 'Geschäft erstellen';

  @override
  String get update_deal => 'Geschäft aktualisieren';

  @override
  String get presence_online => 'Online';

  @override
  String get presence_offline => 'Offline';

  @override
  String get presence_away => 'Abwesend';

  @override
  String get presence_busy => 'Beschäftigt';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get pull_to_refresh => 'Zum Aktualisieren ziehen';

  @override
  String get last_updated => 'Zuletzt aktualisiert';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get not_available => 'Auf diesem Gerät nicht verfügbar';

  @override
  String get not_enrolled => 'Keine Biometrie registriert';

  @override
  String get browsing_history => 'Browserverlauf';

  @override
  String get coming_soon => 'Demnächst';

  @override
  String get push_notifications => 'Push-Benachrichtigungen';

  @override
  String get select_language => 'Sprache auswählen';

  @override
  String language_changed(String lang) {
    return 'Sprache auf $lang geändert';
  }

  @override
  String get low_stock_alert => 'Niedriger Bestand Warnung';

  @override
  String only_left(Object count) {
    return 'Nur noch $count';
  }

  @override
  String last_days(Object days) {
    return 'Letzte $days Tage';
  }

  @override
  String get transactions => 'Transaktionen';

  @override
  String get active_customers => 'aktiv';

  @override
  String get add_product_action => 'Produkt hinzufügen';

  @override
  String get record_sale_action => 'Verkauf erfassen';

  @override
  String get view_customers_action => 'Kunden anzeigen';

  @override
  String get sales_report => 'Verkaufsbericht';

  @override
  String low_stock_product(String product, int count) {
    return '$product - Nur noch $count';
  }

  @override
  String last_days_key(int days) {
    return 'Letzte $days Tage';
  }

  @override
  String pending_count(int count) {
    return '$count ausstehend';
  }

  @override
  String only_count_left(int count) {
    return 'Nur noch $count';
  }

  @override
  String get good_morning => 'Guten Morgen';

  @override
  String get good_afternoon => 'Guten Tag';

  @override
  String get good_evening => 'Guten Abend';

  @override
  String get manage_store => 'Shop verwalten';

  @override
  String get quick_stats => 'Schnellstatistiken';
}
