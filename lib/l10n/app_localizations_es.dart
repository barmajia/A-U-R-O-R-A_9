// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Aurora E-commerce';

  @override
  String get app_title_desc => 'Plataforma Aurora E-commerce';

  @override
  String get welcome_back => '¡Bienvenido de nuevo!';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get signup => 'Registrarse';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirm_password => 'Confirmar contraseña';

  @override
  String get forgot_password => '¿Olvidaste tu contraseña?';

  @override
  String get reset_password => 'Restablecer contraseña';

  @override
  String get send_reset_link => 'Enviar enlace';

  @override
  String get back_to_login => 'Volver a iniciar sesión';

  @override
  String get or_continue_with => 'O';

  @override
  String get login_subtitle => 'Inicia sesión para continuar';

  @override
  String get continue_with_google => 'Continuar con Google';

  @override
  String get restricted_account =>
      'Esta aplicación está restringida a cuentas de vendedores.';

  @override
  String get password_complexity =>
      'La contraseña debe contener mayúsculas, minúsculas y números';

  @override
  String get dont_have_account => '¿No tienes una cuenta?';

  @override
  String get already_have_account => '¿Ya tienes una cuenta?';

  @override
  String get create_account => 'Crear cuenta';

  @override
  String get full_name => 'Nombre completo';

  @override
  String get first_name => 'Nombre';

  @override
  String get second_name => 'Segundo nombre';

  @override
  String get third_name => 'Tercer nombre';

  @override
  String get fourth_name => 'Cuarto nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get location => 'Ubicación';

  @override
  String get currency => 'Moneda';

  @override
  String get account_type => 'Tipo de cuenta';

  @override
  String get buyer => 'Comprador';

  @override
  String get seller => 'Vendedor';

  @override
  String get next => 'Siguiente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get save_changes => 'Guardar cambios';

  @override
  String get loading => 'Cargando...';

  @override
  String get retry => 'Reintentar';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Info';

  @override
  String get user => 'Usuario';

  @override
  String get guest => 'Invitado';

  @override
  String get login_success => 'Inicio de sesión exitoso';

  @override
  String get login_failed => 'Error al iniciar sesión';

  @override
  String get signup_success => 'Cuenta creada exitosamente';

  @override
  String get signup_failed => 'Error al crear la cuenta';

  @override
  String get logout_success => 'Sesión cerrada exitosamente';

  @override
  String get password_reset_sent =>
      'Enlace de restablecimiento enviado a tu correo';

  @override
  String get password_reset_failed => 'Error al enviar el enlace';

  @override
  String get invalid_email => 'Por favor ingresa un correo válido';

  @override
  String get invalid_password =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get email_required => 'El correo es requerido';

  @override
  String get password_required => 'La contraseña es requerida';

  @override
  String get name_required => 'El nombre es requerido';

  @override
  String get phone_required => 'El número de teléfono es requerido';

  @override
  String get valid_phone_number =>
      'Por favor ingresa un número válido (8-15 dígitos)';

  @override
  String get signup_subtitle => 'Crea tu cuenta de vendedor';

  @override
  String get first => 'Primero';

  @override
  String get second => 'Segundo';

  @override
  String get third => 'Tercero';

  @override
  String get fourth => 'Cuarto';

  @override
  String get phone_number => 'Número de teléfono';

  @override
  String get enter_email => 'Ingresa tu correo';

  @override
  String get enter_valid_email => 'Ingresa un correo válido';

  @override
  String get enter_password => 'Ingresa una contraseña';

  @override
  String get password_min_length =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get password_uppercase =>
      'La contraseña debe contener al menos una mayúscula';

  @override
  String get password_lowercase =>
      'La contraseña debe contener al menos una minúscula';

  @override
  String get password_number =>
      'La contraseña debe contener al menos un número';

  @override
  String get confirm_password_label => 'Confirmar contraseña';

  @override
  String get enter_confirm_password => 'Confirma tu contraseña';

  @override
  String get passwords_not_match => 'Las contraseñas no coinciden';

  @override
  String signup_failed_error(String error) {
    return 'Error al registrarse: $error';
  }

  @override
  String already_have_account_login(String login) {
    return '¿Ya tienes una cuenta? $login';
  }

  @override
  String get location_required_signup =>
      'La ubicación es requerida para el registro';

  @override
  String get location_permission_denied => 'Permiso de ubicación denegado';

  @override
  String get get_current_location => 'Obtener ubicación actual';

  @override
  String get select_location => 'Seleccionar ubicación';

  @override
  String get continue_google => 'Continuar con Google';

  @override
  String get creating_account => 'Creando cuenta...';

  @override
  String pending_orders_count(int count) {
    return '$count pendiente(s)';
  }

  @override
  String get daily_revenue => 'Ingresos diarios';

  @override
  String get weekly_revenue => 'Ingresos semanales';

  @override
  String get monthly_revenue => 'Ingresos mensuales';

  @override
  String get seller_dashboard => 'Panel de vendedor';

  @override
  String get recent_activity => 'Actividad reciente';

  @override
  String get quick_actions => 'Acciones rápidas';

  @override
  String get view_all => 'Ver todo';

  @override
  String get no_activity => 'Sin actividad reciente';

  @override
  String get sales => 'Ventas';

  @override
  String get products => 'Productos';

  @override
  String get customers => 'Clientes';

  @override
  String get orders => 'Pedidos';

  @override
  String get record_sale => 'Registrar venta';

  @override
  String get add_product => 'Añadir producto';

  @override
  String get manage_products => 'Gestionar productos';

  @override
  String get manage_customers => 'Gestionar clientes';

  @override
  String get track_orders => 'Rastrear pedidos';

  @override
  String get no_customers => 'Sin clientes aún';

  @override
  String get no_products => 'Sin productos aún';

  @override
  String get total_revenue => 'Ingresos totales';

  @override
  String get pending_orders => 'Pedidos pendientes';

  @override
  String get completed_orders => 'Pedidos completados';

  @override
  String welcome_message(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get location_required => 'La ubicación es requerida';

  @override
  String get home => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notification_settings => 'Configuración de notificaciones';

  @override
  String get mark_all_read => 'Marcar todo como leído';

  @override
  String get no_notifications => 'Sin notificaciones aún';

  @override
  String get delete_notification => 'Eliminar notificación';

  @override
  String get delete_notification_confirm =>
      '¿Estás seguro de que quieres eliminar esta notificación?';

  @override
  String get notification_deleted => 'Notificación eliminada';

  @override
  String get my_profile => 'Mi perfil';

  @override
  String get edit_profile => 'Editar perfil';

  @override
  String get profile_updated => 'Perfil actualizado exitosamente';

  @override
  String get profile_save_failed => 'Error al guardar el perfil';

  @override
  String get profile_load_failed => 'Error al cargar el perfil';

  @override
  String get first_name_placeholder => 'Ingresa tu nombre';

  @override
  String get second_name_placeholder => 'Ingresa tu segundo nombre';

  @override
  String get third_name_placeholder => 'Ingresa tu tercer nombre';

  @override
  String get fourth_name_placeholder => 'Ingresa tu cuarto nombre';

  @override
  String get email_placeholder => 'Ingresa tu correo';

  @override
  String get phone_placeholder => 'Ingresa tu teléfono';

  @override
  String get location_placeholder => 'Ingresa tu ubicación';

  @override
  String get product => 'Producto';

  @override
  String get all_products => 'Todos los productos';

  @override
  String get my_products => 'Mis productos';

  @override
  String get edit_product => 'Editar producto';

  @override
  String get delete_product => 'Eliminar producto';

  @override
  String get delete_product_confirm =>
      '¿Estás seguro de que quieres eliminar este producto?';

  @override
  String get product_name => 'Nombre del producto';

  @override
  String get product_description => 'Descripción';

  @override
  String get product_price => 'Precio';

  @override
  String get product_category => 'Categoría';

  @override
  String get product_brand => 'Marca';

  @override
  String get product_stock => 'Stock';

  @override
  String get product_images => 'Imágenes';

  @override
  String get product_added => 'Producto añadido exitosamente';

  @override
  String get product_updated => 'Producto actualizado exitosamente';

  @override
  String get product_deleted => 'Producto eliminado exitosamente';

  @override
  String get product_save_failed => 'Error al guardar el producto';

  @override
  String get out_of_stock => 'Agotado';

  @override
  String get in_stock => 'En stock';

  @override
  String get search_products => 'Buscar productos...';

  @override
  String get filter => 'Filtrar';

  @override
  String get sort => 'Ordenar';

  @override
  String get sort_by => 'Ordenar por';

  @override
  String get price_low_to_high => 'Precio: Menor a Mayor';

  @override
  String get price_high_to_low => 'Precio: Mayor a Menor';

  @override
  String get name_a_to_z => 'Nombre: A a Z';

  @override
  String get name_z_to_a => 'Nombre: Z a A';

  @override
  String get categories => 'Categorías';

  @override
  String get category => 'Categoría';

  @override
  String get all_categories => 'Todas las categorías';

  @override
  String get electronics => 'Electrónica';

  @override
  String get clothing => 'Ropa';

  @override
  String get home_garden => 'Hogar y Jardín';

  @override
  String get sports => 'Deportes';

  @override
  String get books => 'Libros';

  @override
  String get toys => 'Juguetes';

  @override
  String get health_beauty => 'Salud y Belleza';

  @override
  String get automotive => 'Automotriz';

  @override
  String get other => 'Otro';

  @override
  String get cart => 'Carrito';

  @override
  String get my_cart => 'Mi carrito';

  @override
  String get add_to_cart => 'Añadir al carrito';

  @override
  String get remove_from_cart => 'Eliminar del carrito';

  @override
  String get view_cart => 'Ver carrito';

  @override
  String get checkout => 'Pagar';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Impuesto';

  @override
  String get shipping => 'Envío';

  @override
  String get discount => 'Descuento';

  @override
  String get apply_discount => 'Aplicar descuento';

  @override
  String get promo_code => 'Código promocional';

  @override
  String get empty_cart => 'Tu carrito está vacío';

  @override
  String get continue_shopping => 'Continuar comprando';

  @override
  String get wishlist => 'Lista de deseos';

  @override
  String get my_wishlist => 'Mi lista';

  @override
  String get add_to_wishlist => 'Añadir a la lista';

  @override
  String get remove_from_wishlist => 'Eliminar de la lista';

  @override
  String get remove_item => 'Eliminar artículo';

  @override
  String remove_from_wishlist_confirm(Object productName) {
    return '¿Eliminar \"$productName\" de tu lista?';
  }

  @override
  String get removed_from_wishlist => 'Eliminado de la lista';

  @override
  String get empty_wishlist => 'Tu lista está vacía';

  @override
  String get browse_products => 'Ver productos';

  @override
  String get my_orders => 'Mis pedidos';

  @override
  String get order => 'Pedido';

  @override
  String get order_id => 'ID de pedido';

  @override
  String get order_date => 'Fecha del pedido';

  @override
  String get order_status => 'Estado';

  @override
  String get order_total => 'Total';

  @override
  String get order_details => 'Detalles';

  @override
  String get order_placed => 'Pedido realizado exitosamente';

  @override
  String get order_failed => 'Error al realizar el pedido';

  @override
  String get pending => 'Pendiente';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get processing => 'Procesando';

  @override
  String get shipped => 'Enviado';

  @override
  String get delivered => 'Entregado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get refunded => 'Reembolsado';

  @override
  String get track_order => 'Rastrear pedido';

  @override
  String get cancel_order => 'Cancelar pedido';

  @override
  String get cancel_order_confirm =>
      '¿Estás seguro de que quieres cancelar este pedido?';

  @override
  String get chat => 'Chat';

  @override
  String get chats => 'Chats';

  @override
  String get messages => 'Mensajes';

  @override
  String get message => 'Mensaje';

  @override
  String get type_message => 'Escribe un mensaje...';

  @override
  String get send => 'Enviar';

  @override
  String get send_message => 'Enviar mensaje';

  @override
  String get no_chats => 'Sin chats aún';

  @override
  String get no_messages => 'Sin mensajes aún';

  @override
  String get start_chat => 'Iniciar chat';

  @override
  String get chat_with => 'Chatear con';

  @override
  String get online => 'En línea';

  @override
  String get offline => 'Desconectado';

  @override
  String get typing => 'Escribiendo...';

  @override
  String get seen => 'Visto';

  @override
  String get image_message => 'Imagen';

  @override
  String get file_message => 'Archivo';

  @override
  String get deal_proposal => 'Propuesta de negocio';

  @override
  String get view_deal => 'Ver negocio';

  @override
  String get accept_deal => 'Aceptar';

  @override
  String get reject_deal => 'Rechazar';

  @override
  String get deal_accepted => 'Negocio aceptado';

  @override
  String get deal_rejected => 'Negocio rechazado';

  @override
  String get commission_rate => 'Tasa de comisión';

  @override
  String get negotiate => 'Negociar';

  @override
  String get analytics => 'Analítica';

  @override
  String get revenue => 'Ingresos';

  @override
  String get views => 'Vistas';

  @override
  String get today => 'Hoy';

  @override
  String get this_week => 'Esta semana';

  @override
  String get this_month => 'Este mes';

  @override
  String get this_year => 'Este año';

  @override
  String get total_sales => 'Ventas totales';

  @override
  String get total_orders => 'Pedidos totales';

  @override
  String get total_products => 'Productos totales';

  @override
  String get average_order_value => 'Valor promedio';

  @override
  String get top_products => 'Productos populares';

  @override
  String get recent_sales => 'Ventas recientes';

  @override
  String get sales_chart => 'Gráfico de ventas';

  @override
  String get revenue_chart => 'Gráfico de ingresos';

  @override
  String get become_seller => 'Convertirse en vendedor';

  @override
  String get seller_profile => 'Perfil de vendedor';

  @override
  String get seller_info => 'Información del vendedor';

  @override
  String get seller_verified => 'Vendedor verificado';

  @override
  String get seller_not_verified => 'No verificado';

  @override
  String get is_verified => 'Verificado';

  @override
  String get verification_status => 'Estado de verificación';

  @override
  String get account_balance => 'Saldo de la cuenta';

  @override
  String get withdraw => 'Retirar';

  @override
  String get withdrawal_history => 'Historial de retiros';

  @override
  String get settings_general => 'Configuración general';

  @override
  String get settings_account => 'Configuración de cuenta';

  @override
  String get settings_privacy => 'Configuración de privacidad';

  @override
  String get settings_security => 'Configuración de seguridad';

  @override
  String get settings_notifications => 'Configuración de notificaciones';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get dark_mode => 'Modo oscuro';

  @override
  String get light_mode => 'Modo claro';

  @override
  String get system_theme => 'Tema del sistema';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get arabic => 'Árabe';

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
  String get change_language => 'Cambiar idioma';

  @override
  String get change_password => 'Cambiar contraseña';

  @override
  String get current_password => 'Contraseña actual';

  @override
  String get new_password => 'Nueva contraseña';

  @override
  String get confirm_new_password => 'Confirmar nueva contraseña';

  @override
  String get password_changed => 'Contraseña cambiada exitosamente';

  @override
  String get password_change_failed => 'Error al cambiar la contraseña';

  @override
  String get biometric => 'Autenticación biométrica';

  @override
  String get enable_biometric => 'Activar biométrica';

  @override
  String get disable_biometric => 'Desactivar biométrica';

  @override
  String get biometric_enabled => 'Biométrica activada';

  @override
  String get biometric_disabled => 'Biométrica desactivada';

  @override
  String get search => 'Buscar';

  @override
  String get search_hint => 'Buscar...';

  @override
  String get no_results => 'Sin resultados';

  @override
  String get try_different_search => 'Prueba con otro término';

  @override
  String get filters => 'Filtros';

  @override
  String get price_range => 'Rango de precio';

  @override
  String get min_price => 'Precio mínimo';

  @override
  String get max_price => 'Precio máximo';

  @override
  String get apply_filters => 'Aplicar filtros';

  @override
  String get clear_filters => 'Limpiar filtros';

  @override
  String get shipping_address => 'Dirección de envío';

  @override
  String get billing_address => 'Dirección de facturación';

  @override
  String get address_line_1 => 'Dirección línea 1';

  @override
  String get address_line_2 => 'Dirección línea 2';

  @override
  String get city => 'Ciudad';

  @override
  String get state => 'Región';

  @override
  String get country => 'País';

  @override
  String get postal_code => 'Código postal';

  @override
  String get zip_code => 'Código postal';

  @override
  String get select_country => 'Seleccionar país';

  @override
  String get select_city => 'Seleccionar ciudad';

  @override
  String get payment_method => 'Método de pago';

  @override
  String get payment_methods => 'Métodos de pago';

  @override
  String get add_payment_method => 'Añadir método de pago';

  @override
  String get credit_card => 'Tarjeta de crédito';

  @override
  String get debit_card => 'Tarjeta de débito';

  @override
  String get cash_on_delivery => 'Contra entrega';

  @override
  String get bank_transfer => 'Transferencia bancaria';

  @override
  String get wallet => 'Billetera';

  @override
  String get card_number => 'Número de tarjeta';

  @override
  String get card_holder => 'Nombre del titular';

  @override
  String get expiry_date => 'Fecha de vencimiento';

  @override
  String get cvv => 'CVV';

  @override
  String get reviews => 'Reseñas';

  @override
  String get review => 'Reseña';

  @override
  String get write_review => 'Escribir una reseña';

  @override
  String get rating => 'Calificación';

  @override
  String get ratings => 'Calificaciones';

  @override
  String get no_reviews => 'Sin reseñas aún';

  @override
  String get add_review => 'Añadir reseña';

  @override
  String get review_title => 'Título de la reseña';

  @override
  String get review_comment => 'Tu reseña';

  @override
  String get review_submitted => 'Reseña enviada exitosamente';

  @override
  String get review_failed => 'Error al enviar la reseña';

  @override
  String get help => 'Ayuda';

  @override
  String get help_center => 'Centro de ayuda';

  @override
  String get faq => 'FAQ';

  @override
  String get contact_us => 'Contáctanos';

  @override
  String get about => 'Acerca de';

  @override
  String get about_us => 'Acerca de nosotros';

  @override
  String get terms_of_service => 'Términos de servicio';

  @override
  String get privacy_policy => 'Política de privacidad';

  @override
  String get version => 'Versión';

  @override
  String get are_you_sure => '¿Estás seguro?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Cerrar';

  @override
  String get done => 'Hecho';

  @override
  String get finish => 'Terminar';

  @override
  String get back => 'Volver';

  @override
  String get continue_btn => 'Continuar';

  @override
  String get skip => 'Omitir';

  @override
  String get learn_more => 'Saber más';

  @override
  String get see_more => 'Ver más';

  @override
  String get see_less => 'Ver menos';

  @override
  String get image_pick_failed => 'Error al seleccionar imagen';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get take_photo => 'Tomar foto';

  @override
  String get choose_from_gallery => 'Elegir de la galería';

  @override
  String get upload_image => 'Subir imagen';

  @override
  String get remove_image => 'Eliminar imagen';

  @override
  String get permission_required => 'Permiso requerido';

  @override
  String get permission_denied => 'Permiso denegado';

  @override
  String get permission_location => 'Se requiere permiso de ubicación';

  @override
  String get permission_camera => 'Se requiere permiso de cámara';

  @override
  String get permission_storage => 'Se requiere permiso de almacenamiento';

  @override
  String get permission_notification => 'Se requiere permiso de notificación';

  @override
  String get open_settings => 'Abrir configuración';

  @override
  String get connection_lost => 'Conexión perdida';

  @override
  String get check_internet => 'Por favor verifica tu conexión';

  @override
  String get server_error => 'Error del servidor, intenta más tarde';

  @override
  String get something_went_wrong => 'Algo salió mal';

  @override
  String get try_again => 'Intentar de nuevo';

  @override
  String get copied_to_clipboard => 'Copiado al portapapeles';

  @override
  String get share => 'Compartir';

  @override
  String get copy => 'Copiar';

  @override
  String get qr_code => 'Código QR';

  @override
  String get scan_qr => 'Escanear código QR';

  @override
  String get qr_product_info => 'Información del producto';

  @override
  String get nearby => 'Cerca';

  @override
  String get nearby_sellers => 'Vendedores cercanos';

  @override
  String get nearby_products => 'Productos cercanos';

  @override
  String get distance => 'Distancia';

  @override
  String get km => 'km';

  @override
  String get m => 'm';

  @override
  String get deals => 'Negocios';

  @override
  String get my_deals => 'Mis negocios';

  @override
  String get active_deals => 'Negocios activos';

  @override
  String get completed_deals => 'Negocios completados';

  @override
  String get deal_status => 'Estado del negocio';

  @override
  String get create_deal => 'Crear negocio';

  @override
  String get update_deal => 'Actualizar negocio';

  @override
  String get presence_online => 'En línea';

  @override
  String get presence_offline => 'Desconectado';

  @override
  String get presence_away => 'Ausente';

  @override
  String get presence_busy => 'Ocupado';

  @override
  String get refresh => 'Actualizar';

  @override
  String get pull_to_refresh => 'Desliza para actualizar';

  @override
  String get last_updated => 'Última actualización';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get not_available => 'No disponible en este dispositivo';

  @override
  String get not_enrolled => 'Sin biométricos registrados';

  @override
  String get browsing_history => 'Historial de navegación';

  @override
  String get coming_soon => 'Próximamente';

  @override
  String get push_notifications => 'Notificaciones push';

  @override
  String get select_language => 'Seleccionar idioma';

  @override
  String language_changed(String lang) {
    return 'Idioma cambiado a $lang';
  }

  @override
  String get low_stock_alert => 'Alerta de stock bajo';

  @override
  String only_left(Object count) {
    return 'Solo $count restantes';
  }

  @override
  String last_days(Object days) {
    return 'Últimos $days días';
  }

  @override
  String get transactions => 'transacciones';

  @override
  String get active_customers => 'activos';

  @override
  String get add_product_action => 'Añadir producto';

  @override
  String get record_sale_action => 'Registrar venta';

  @override
  String get view_customers_action => 'Ver clientes';

  @override
  String get sales_report => 'Reporte de ventas';

  @override
  String low_stock_product(String product, int count) {
    return '$product - Solo $count restantes';
  }

  @override
  String last_days_key(int days) {
    return 'Últimos $days días';
  }

  @override
  String pending_count(int count) {
    return '$count pendiente(s)';
  }

  @override
  String only_count_left(int count) {
    return 'Solo $count restantes';
  }

  @override
  String get good_morning => 'Buenos días';

  @override
  String get good_afternoon => 'Buenas tardes';

  @override
  String get good_evening => 'Buenas noches';

  @override
  String get manage_store => 'Gestionar tienda';

  @override
  String get quick_stats => 'Estadísticas rápidas';
}
