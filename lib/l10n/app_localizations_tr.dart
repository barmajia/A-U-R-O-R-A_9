// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_title => 'Aurora E-ticaret';

  @override
  String get app_title_desc => 'Aurora E-ticaret Platformu';

  @override
  String get welcome_back => 'Tekrar Hoş Geldiniz!';

  @override
  String get welcome => 'Hoş Geldiniz';

  @override
  String get login => 'Giriş Yap';

  @override
  String get signup => 'Kayıt Ol';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirm_password => 'Şifreyi Doğrula';

  @override
  String get forgot_password => 'Şifrenizi mi unuttunuz?';

  @override
  String get reset_password => 'Şifreyi Sıfırla';

  @override
  String get send_reset_link => 'Bağlantı Gönder';

  @override
  String get back_to_login => 'Girişe Dön';

  @override
  String get or_continue_with => 'VEYA';

  @override
  String get login_subtitle => 'Devam etmek için giriş yapın';

  @override
  String get continue_with_google => 'Google ile Devam Et';

  @override
  String get restricted_account =>
      'Bu uygulama sadece satıcı hesapları için geçerlidir.';

  @override
  String get password_complexity =>
      'Şifre büyük harf, küçük harf ve rakam içermelidir';

  @override
  String get dont_have_account => 'Hesabınız yok mu?';

  @override
  String get already_have_account => 'Zaten hesabınız var mı?';

  @override
  String get create_account => 'Hesap Oluştur';

  @override
  String get full_name => 'Tam İsim';

  @override
  String get first_name => 'İsim';

  @override
  String get second_name => 'İkinci İsim';

  @override
  String get third_name => 'Üçüncü İsim';

  @override
  String get fourth_name => 'Dördüncü İsim';

  @override
  String get phone => 'Telefon';

  @override
  String get location => 'Konum';

  @override
  String get currency => 'Para Birimi';

  @override
  String get account_type => 'Hesap Türü';

  @override
  String get buyer => 'Alıcı';

  @override
  String get seller => 'Satıcı';

  @override
  String get next => 'İleri';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get save_changes => 'Değişiklikleri Kaydet';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get warning => 'Uyarı';

  @override
  String get info => 'Bilgi';

  @override
  String get user => 'Kullanıcı';

  @override
  String get guest => 'Misafir';

  @override
  String get login_success => 'Giriş başarılı';

  @override
  String get login_failed => 'Giriş başarısız';

  @override
  String get signup_success => 'Hesap başarıyla oluşturuldu';

  @override
  String get signup_failed => 'Hesap oluşturulamadı';

  @override
  String get logout_success => 'Çıkış başarılı';

  @override
  String get password_reset_sent =>
      'Şifre sıfırlama bağlantısı e-postanıza gönderildi';

  @override
  String get password_reset_failed => 'Bağlantı gönderilemedi';

  @override
  String get invalid_email => 'Geçerli bir e-posta girin';

  @override
  String get invalid_password => 'Şifre en az 6 karakter olmalı';

  @override
  String get passwords_do_not_match => 'Şifreler uyuşmuyor';

  @override
  String get email_required => 'E-posta gereklidir';

  @override
  String get password_required => 'Şifre gereklidir';

  @override
  String get name_required => 'İsim gereklidir';

  @override
  String get phone_required => 'Telefon numarası gereklidir';

  @override
  String get valid_phone_number =>
      'Geçerli bir telefon numarası girin (8-15 rakam)';

  @override
  String get signup_subtitle => 'Satıcı hesabınızı oluşturun';

  @override
  String get first => 'Birinci';

  @override
  String get second => 'İkinci';

  @override
  String get third => 'Üçüncü';

  @override
  String get fourth => 'Dördüncü';

  @override
  String get phone_number => 'Telefon Numarası';

  @override
  String get enter_email => 'E-postanızı girin';

  @override
  String get enter_valid_email => 'Geçerli e-posta girin';

  @override
  String get enter_password => 'Şifre girin';

  @override
  String get password_min_length => 'Şifre en az 8 karakter olmalı';

  @override
  String get password_uppercase => 'Şifre en az bir büyük harf içermeli';

  @override
  String get password_lowercase => 'Şifre en az bir küçük harf içermeli';

  @override
  String get password_number => 'Şifre en az bir rakam içermeli';

  @override
  String get confirm_password_label => 'Şifreyi Doğrula';

  @override
  String get enter_confirm_password => 'Şifrenizi doğrulayın';

  @override
  String get passwords_not_match => 'Şifreler uyuşmuyor';

  @override
  String signup_failed_error(String error) {
    return 'Kayıt başarısız: $error';
  }

  @override
  String already_have_account_login(String login) {
    return 'Hesabınız var mı? $login';
  }

  @override
  String get location_required_signup => 'Kayıt için konum gereklidir';

  @override
  String get location_permission_denied => 'Konum izni reddedildi';

  @override
  String get get_current_location => 'Mevcut Konumu Al';

  @override
  String get select_location => 'Konum Seç';

  @override
  String get continue_google => 'Google ile Devam Et';

  @override
  String get creating_account => 'Hesap oluşturuluyor...';

  @override
  String pending_orders_count(int count) {
    return '$count bekliyor';
  }

  @override
  String get daily_revenue => 'Günlük gelir';

  @override
  String get weekly_revenue => 'Haftalık gelir';

  @override
  String get monthly_revenue => 'Aylık gelir';

  @override
  String get seller_dashboard => 'Satıcı Paneli';

  @override
  String get recent_activity => 'Son Etkinlik';

  @override
  String get quick_actions => 'Hızlı İşlemler';

  @override
  String get view_all => 'Tümünü Gör';

  @override
  String get no_activity => 'Son etkinlik yok';

  @override
  String get sales => 'Satışlar';

  @override
  String get products => 'Ürünler';

  @override
  String get customers => 'Müşteriler';

  @override
  String get orders => 'Siparişler';

  @override
  String get record_sale => 'Satış Kaydet';

  @override
  String get add_product => 'Ürün Ekle';

  @override
  String get manage_products => 'Ürünleri Yönet';

  @override
  String get manage_customers => 'Müşterileri Yönet';

  @override
  String get track_orders => 'Siparişleri Takip Et';

  @override
  String get no_customers => 'Henüz müşteri yok';

  @override
  String get no_products => 'Henüz ürün yok';

  @override
  String get total_revenue => 'Toplam Gelir';

  @override
  String get pending_orders => 'Bekleyen Siparişler';

  @override
  String get completed_orders => 'Tamamlanan Siparişler';

  @override
  String welcome_message(String name) {
    return 'Hoş Geldiniz, $name!';
  }

  @override
  String get location_required => 'Konum gereklidir';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notification_settings => 'Bildirim Ayarları';

  @override
  String get mark_all_read => 'Tümünü Okundu İşaretle';

  @override
  String get no_notifications => 'Henüz bildirim yok';

  @override
  String get delete_notification => 'Bildirimi Sil';

  @override
  String get delete_notification_confirm =>
      'Bu bildirimi silmek istediğinizden emin misiniz?';

  @override
  String get notification_deleted => 'Bildirim silindi';

  @override
  String get my_profile => 'Profilim';

  @override
  String get edit_profile => 'Profili Düzenle';

  @override
  String get profile_updated => 'Profil başarıyla güncellendi';

  @override
  String get profile_save_failed => 'Profil kaydedilemedi';

  @override
  String get profile_load_failed => 'Profil yüklenemedi';

  @override
  String get first_name_placeholder => 'İsminizi girin';

  @override
  String get second_name_placeholder => 'İkinci isminizi girin';

  @override
  String get third_name_placeholder => 'Üçüncü isminizi girin';

  @override
  String get fourth_name_placeholder => 'Dördüncü isminizi girin';

  @override
  String get email_placeholder => 'E-postanızı girin';

  @override
  String get phone_placeholder => 'Telefonunuzu girin';

  @override
  String get location_placeholder => 'Konumunuzu girin';

  @override
  String get product => 'Ürün';

  @override
  String get all_products => 'Tüm Ürünler';

  @override
  String get my_products => 'Ürünlerim';

  @override
  String get edit_product => 'Ürünü Düzenle';

  @override
  String get delete_product => 'Ürünü Sil';

  @override
  String get delete_product_confirm =>
      'Bu ürünü silmek istediğinizden emin misiniz?';

  @override
  String get product_name => 'Ürün Adı';

  @override
  String get product_description => 'Açıklama';

  @override
  String get product_price => 'Fiyat';

  @override
  String get product_category => 'Kategori';

  @override
  String get product_brand => 'Marka';

  @override
  String get product_stock => 'Stok';

  @override
  String get product_images => 'Görseller';

  @override
  String get product_added => 'Ürün başarıyla eklendi';

  @override
  String get product_updated => 'Ürün başarıyla güncellendi';

  @override
  String get product_deleted => 'Ürün başarıyla silindi';

  @override
  String get product_save_failed => 'Ürün kaydedilemedi';

  @override
  String get out_of_stock => 'Stokta Yok';

  @override
  String get in_stock => 'Stokta Var';

  @override
  String get search_products => 'Ürün ara...';

  @override
  String get filter => 'Filtrele';

  @override
  String get sort => 'Sırala';

  @override
  String get sort_by => 'Sırala';

  @override
  String get price_low_to_high => 'Fiyat: Düşükten Yükseğe';

  @override
  String get price_high_to_low => 'Fiyat: Yüksekten Düşüğe';

  @override
  String get name_a_to_z => 'İsim: A\'dan Z\'ye';

  @override
  String get name_z_to_a => 'İsim: Z\'den A\'ya';

  @override
  String get categories => 'Kategoriler';

  @override
  String get category => 'Kategori';

  @override
  String get all_categories => 'Tüm Kategoriler';

  @override
  String get electronics => 'Elektronik';

  @override
  String get clothing => 'Giyim';

  @override
  String get home_garden => 'Ev ve Bahçe';

  @override
  String get sports => 'Spor';

  @override
  String get books => 'Kitaplar';

  @override
  String get toys => 'Oyuncaklar';

  @override
  String get health_beauty => 'Sağlık ve Güzellik';

  @override
  String get automotive => 'Otomotiv';

  @override
  String get other => 'Diğer';

  @override
  String get cart => 'Sepet';

  @override
  String get my_cart => 'Sepetim';

  @override
  String get add_to_cart => 'Sepete Ekle';

  @override
  String get remove_from_cart => 'Sepetten Çıkar';

  @override
  String get view_cart => 'Sepeti Gör';

  @override
  String get checkout => 'Ödeme Yap';

  @override
  String get total => 'Toplam';

  @override
  String get subtotal => 'Ara Toplam';

  @override
  String get tax => 'Vergi';

  @override
  String get shipping => 'Kargo';

  @override
  String get discount => 'İndirim';

  @override
  String get apply_discount => 'İndirim Uygula';

  @override
  String get promo_code => 'Promo Kodu';

  @override
  String get empty_cart => 'Sepetiniz boş';

  @override
  String get continue_shopping => 'Alışverişe Devam Et';

  @override
  String get wishlist => 'İstek Listesi';

  @override
  String get my_wishlist => 'Listem';

  @override
  String get add_to_wishlist => 'Listeye Ekle';

  @override
  String get remove_from_wishlist => 'Listeden Çıkar';

  @override
  String get remove_item => 'Öğeyi Kaldır';

  @override
  String remove_from_wishlist_confirm(Object productName) {
    return '\"$productName\" listeden kaldırılsın mı?';
  }

  @override
  String get removed_from_wishlist => 'Listedten kaldırıldı';

  @override
  String get empty_wishlist => 'Listeniz boş';

  @override
  String get browse_products => 'Ürünlere Göz At';

  @override
  String get my_orders => 'Siparişlerim';

  @override
  String get order => 'Sipariş';

  @override
  String get order_id => 'Sipariş ID';

  @override
  String get order_date => 'Sipariş Tarihi';

  @override
  String get order_status => 'Durum';

  @override
  String get order_total => 'Toplam';

  @override
  String get order_details => 'Detaylar';

  @override
  String get order_placed => 'Sipariş başarıyla verildi';

  @override
  String get order_failed => 'Sipariş verilemedi';

  @override
  String get pending => 'Bekliyor';

  @override
  String get confirmed => 'Onaylandı';

  @override
  String get processing => 'İşleniyor';

  @override
  String get shipped => 'Gönderildi';

  @override
  String get delivered => 'Teslim Edildi';

  @override
  String get cancelled => 'İptal Edildi';

  @override
  String get refunded => 'İade Edildi';

  @override
  String get track_order => 'Siparişi Takip Et';

  @override
  String get cancel_order => 'Siparişi İptal Et';

  @override
  String get cancel_order_confirm =>
      'Bu siparişi iptal etmek istediğinizden emin misiniz?';

  @override
  String get chat => 'Sohbet';

  @override
  String get chats => 'Sohbetler';

  @override
  String get messages => 'Mesajlar';

  @override
  String get message => 'Mesaj';

  @override
  String get type_message => 'Mesaj yazın...';

  @override
  String get send => 'Gönder';

  @override
  String get send_message => 'Mesaj Gönder';

  @override
  String get no_chats => 'Henüz sohbet yok';

  @override
  String get no_messages => 'Henüz mesaj yok';

  @override
  String get start_chat => 'Sohbet Başlat';

  @override
  String get chat_with => 'Sohbet et';

  @override
  String get online => 'Çevrimiçi';

  @override
  String get offline => 'Çevrimdışı';

  @override
  String get typing => 'Yazıyor...';

  @override
  String get seen => 'Görüldü';

  @override
  String get image_message => 'Görsel';

  @override
  String get file_message => 'Dosya';

  @override
  String get deal_proposal => 'İş Teklifi';

  @override
  String get view_deal => 'İşi Gör';

  @override
  String get accept_deal => 'Kabul Et';

  @override
  String get reject_deal => 'Reddet';

  @override
  String get deal_accepted => 'İş kabul edildi';

  @override
  String get deal_rejected => 'İş reddedildi';

  @override
  String get commission_rate => 'Komisyon Oranı';

  @override
  String get negotiate => 'Müzakere Et';

  @override
  String get analytics => 'Analitik';

  @override
  String get revenue => 'Gelir';

  @override
  String get views => 'Görüntülemeler';

  @override
  String get today => 'Bugün';

  @override
  String get this_week => 'Bu Hafta';

  @override
  String get this_month => 'Bu Ay';

  @override
  String get this_year => 'Bu Yıl';

  @override
  String get total_sales => 'Toplam Satış';

  @override
  String get total_orders => 'Toplam Sipariş';

  @override
  String get total_products => 'Toplam Ürün';

  @override
  String get average_order_value => 'Ortalama Sipariş Değeri';

  @override
  String get top_products => 'Popüler Ürünler';

  @override
  String get recent_sales => 'Son Satışlar';

  @override
  String get sales_chart => 'Satış Grafiği';

  @override
  String get revenue_chart => 'Gelir Grafiği';

  @override
  String get become_seller => 'Satıcı Ol';

  @override
  String get seller_profile => 'Satıcı Profili';

  @override
  String get seller_info => 'Satıcı Bilgileri';

  @override
  String get seller_verified => 'Doğrulanmış Satıcı';

  @override
  String get seller_not_verified => 'Doğrulanmamış';

  @override
  String get is_verified => 'Doğrulanmış';

  @override
  String get verification_status => 'Doğrulama Durumu';

  @override
  String get account_balance => 'Hesap Bakiyesi';

  @override
  String get withdraw => 'Çek';

  @override
  String get withdrawal_history => 'Çekme Geçmişi';

  @override
  String get settings_general => 'Genel Ayarlar';

  @override
  String get settings_account => 'Hesap Ayarları';

  @override
  String get settings_privacy => 'Gizlilik Ayarları';

  @override
  String get settings_security => 'Güvenlik Ayarları';

  @override
  String get settings_notifications => 'Bildirim Ayarları';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_theme => 'Tema';

  @override
  String get dark_mode => 'Karanlık Mod';

  @override
  String get light_mode => 'Aydınlık Mod';

  @override
  String get system_theme => 'Sistem Teması';

  @override
  String get language => 'Dil';

  @override
  String get english => 'İngilizce';

  @override
  String get arabic => 'Arapça';

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
  String get change_language => 'Dili Değiştir';

  @override
  String get change_password => 'Şifreyi Değiştir';

  @override
  String get current_password => 'Mevcut Şifre';

  @override
  String get new_password => 'Yeni Şifre';

  @override
  String get confirm_new_password => 'Yeni Şifreyi Doğrula';

  @override
  String get password_changed => 'Şifre başarıyla değiştirildi';

  @override
  String get password_change_failed => 'Şifre değiştirilemedi';

  @override
  String get biometric => 'Biyometrik Kimlik Doğrulama';

  @override
  String get enable_biometric => 'Biyometriyi Aktif Et';

  @override
  String get disable_biometric => 'Biyometriyi Pasif Et';

  @override
  String get biometric_enabled => 'Biyometri etkinleştirildi';

  @override
  String get biometric_disabled => 'Biyometri devre dışı bırakıldı';

  @override
  String get search => 'Ara';

  @override
  String get search_hint => 'Ara...';

  @override
  String get no_results => 'Sonuç bulunamadı';

  @override
  String get try_different_search => 'Farklı bir arama terimi deneyin';

  @override
  String get filters => 'Filtreler';

  @override
  String get price_range => 'Fiyat Aralığı';

  @override
  String get min_price => 'Min Fiyat';

  @override
  String get max_price => 'Max Fiyat';

  @override
  String get apply_filters => 'Filtreleri Uygula';

  @override
  String get clear_filters => 'Filtreleri Temizle';

  @override
  String get shipping_address => 'Teslimat Adresi';

  @override
  String get billing_address => 'Fatura Adresi';

  @override
  String get address_line_1 => 'Adres Satırı 1';

  @override
  String get address_line_2 => 'Adres Satırı 2';

  @override
  String get city => 'Şehir';

  @override
  String get state => 'Bölge';

  @override
  String get country => 'Ülke';

  @override
  String get postal_code => 'Posta Kodu';

  @override
  String get zip_code => 'POSTA Kodu';

  @override
  String get select_country => 'Ülke Seç';

  @override
  String get select_city => 'Şehir Seç';

  @override
  String get payment_method => 'Ödeme Yöntemi';

  @override
  String get payment_methods => 'Ödeme Yöntemleri';

  @override
  String get add_payment_method => 'Ödeme Yöntemi Ekle';

  @override
  String get credit_card => 'Kredi Kartı';

  @override
  String get debit_card => 'Banka Kartı';

  @override
  String get cash_on_delivery => 'Kapıda Ödeme';

  @override
  String get bank_transfer => 'Banka Transferi';

  @override
  String get wallet => 'Cüzdan';

  @override
  String get card_number => 'Kart Numarası';

  @override
  String get card_holder => 'Kart Sahibi';

  @override
  String get expiry_date => 'Son Kullanma Tarihi';

  @override
  String get cvv => 'CVV';

  @override
  String get reviews => 'Değerlendirmeler';

  @override
  String get review => 'Değerlendirme';

  @override
  String get write_review => 'Değerlendirme Yaz';

  @override
  String get rating => 'Puan';

  @override
  String get ratings => 'Puanlar';

  @override
  String get no_reviews => 'Henüz değerlendirme yok';

  @override
  String get add_review => 'Değerlendirme Ekle';

  @override
  String get review_title => 'Değerlendirme Başlığı';

  @override
  String get review_comment => 'Değerlendirmeniz';

  @override
  String get review_submitted => 'Değerlendirme başarıyla gönderildi';

  @override
  String get review_failed => 'Değerlendirme gönderilemedi';

  @override
  String get help => 'Yardım';

  @override
  String get help_center => 'Yardım Merkezi';

  @override
  String get faq => 'SSS';

  @override
  String get contact_us => 'Bize Ulaşın';

  @override
  String get about => 'Hakkında';

  @override
  String get about_us => 'Hakkımızda';

  @override
  String get terms_of_service => 'Kullanım Şartları';

  @override
  String get privacy_policy => 'Gizlilik Politikası';

  @override
  String get version => 'Sürüm';

  @override
  String get are_you_sure => 'Emin misiniz?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get close => 'Kapat';

  @override
  String get done => 'Bitti';

  @override
  String get finish => 'Bitir';

  @override
  String get back => 'Geri';

  @override
  String get continue_btn => 'Devam Et';

  @override
  String get skip => 'Atla';

  @override
  String get learn_more => 'Daha Fazla Öğren';

  @override
  String get see_more => 'Daha Fazla';

  @override
  String get see_less => 'Daha Az';

  @override
  String get image_pick_failed => 'Görsel seçilemedi';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get take_photo => 'Fotoğraf Çek';

  @override
  String get choose_from_gallery => 'Galeriden Seç';

  @override
  String get upload_image => 'Görsel Yükle';

  @override
  String get remove_image => 'Görseli Kaldır';

  @override
  String get permission_required => 'İzin Gerekli';

  @override
  String get permission_denied => 'İzin reddedildi';

  @override
  String get permission_location => 'Bu özellik için konum izni gereklidir';

  @override
  String get permission_camera => 'Kamera izni gereklidir';

  @override
  String get permission_storage => 'Depolama izni gereklidir';

  @override
  String get permission_notification => 'Bildirim izni gereklidir';

  @override
  String get open_settings => 'Ayarları Aç';

  @override
  String get connection_lost => 'Bağlantı koptu';

  @override
  String get check_internet => 'Lütfen internet bağlantınızı kontrol edin';

  @override
  String get server_error => 'Sunucu hatası, daha sonra tekrar deneyin';

  @override
  String get something_went_wrong => 'Bir şeyler ters gitti';

  @override
  String get try_again => 'Tekrar Dene';

  @override
  String get copied_to_clipboard => 'Panoya kopyalandı';

  @override
  String get share => 'Paylaş';

  @override
  String get copy => 'Kopyala';

  @override
  String get qr_code => 'QR Kod';

  @override
  String get scan_qr => 'QR Kod Tara';

  @override
  String get qr_product_info => 'Ürün Bilgileri';

  @override
  String get nearby => 'Yakında';

  @override
  String get nearby_sellers => 'Yakındaki Satıcılar';

  @override
  String get nearby_products => 'Yakındaki Ürünler';

  @override
  String get distance => 'Mesafe';

  @override
  String get km => 'km';

  @override
  String get m => 'm';

  @override
  String get deals => 'İşler';

  @override
  String get my_deals => 'İşlerim';

  @override
  String get active_deals => 'Aktif İşler';

  @override
  String get completed_deals => 'Tamamlanan İşler';

  @override
  String get deal_status => 'İş Durumu';

  @override
  String get create_deal => 'İş Oluştur';

  @override
  String get update_deal => 'İşi Güncelle';

  @override
  String get presence_online => 'Çevrimiçi';

  @override
  String get presence_offline => 'Çevrimdışı';

  @override
  String get presence_away => 'Uzakta';

  @override
  String get presence_busy => 'Meşgul';

  @override
  String get refresh => 'Yenile';

  @override
  String get pull_to_refresh => 'Yenilemek için çekin';

  @override
  String get last_updated => 'Son güncelleme';

  @override
  String get enabled => 'Etkin';

  @override
  String get disabled => 'Devre dışı';

  @override
  String get not_available => 'Bu cihazda mevcut değil';

  @override
  String get not_enrolled => 'Biyometrik kayıtlı değil';

  @override
  String get browsing_history => 'Tarama Geçmişi';

  @override
  String get coming_soon => 'Yakında';

  @override
  String get push_notifications => 'Push Bildirimleri';

  @override
  String get select_language => 'Dil Seç';

  @override
  String language_changed(String lang) {
    return 'Dil $lang olarak değiştirildi';
  }

  @override
  String get low_stock_alert => 'Düşük Stok Uyarısı';

  @override
  String only_left(Object count) {
    return 'Sadece $count kaldı';
  }

  @override
  String last_days(Object days) {
    return 'Son $days gün';
  }

  @override
  String get transactions => 'işlem';

  @override
  String get active_customers => 'aktif';

  @override
  String get add_product_action => 'Ürün Ekle';

  @override
  String get record_sale_action => 'Satış Kaydet';

  @override
  String get view_customers_action => 'Müşterileri Gör';

  @override
  String get sales_report => 'Satış Raporu';

  @override
  String low_stock_product(String product, int count) {
    return '$product - Sadece $count kaldı';
  }

  @override
  String last_days_key(int days) {
    return 'Son $days gün';
  }

  @override
  String pending_count(int count) {
    return '$count bekliyor';
  }

  @override
  String only_count_left(int count) {
    return 'Sadece $count kaldı';
  }

  @override
  String get good_morning => 'Günaydın';

  @override
  String get good_afternoon => 'Tünaydın';

  @override
  String get good_evening => 'İyi akşamlar';

  @override
  String get manage_store => 'Mağazayı Yönet';

  @override
  String get quick_stats => 'Hızlı İstatistikler';
}
