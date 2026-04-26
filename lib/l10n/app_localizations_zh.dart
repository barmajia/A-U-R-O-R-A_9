// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_title => 'Aurora 电商';

  @override
  String get app_title_desc => 'Aurora 电商平台';

  @override
  String get welcome_back => '欢迎回来！';

  @override
  String get welcome => '欢迎';

  @override
  String get login => '登录';

  @override
  String get signup => '注册';

  @override
  String get logout => '退出登录';

  @override
  String get register => '注册';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get forgot_password => '忘记密码？';

  @override
  String get reset_password => '重置密码';

  @override
  String get send_reset_link => '发送链接';

  @override
  String get back_to_login => '返回登录';

  @override
  String get or_continue_with => '或';

  @override
  String get login_subtitle => '登录以继续';

  @override
  String get continue_with_google => '继续使用 Google';

  @override
  String get restricted_account => '此应用仅限卖家账户使用。';

  @override
  String get password_complexity => '密码必须包含大写字母、小写字母和数字';

  @override
  String get dont_have_account => '没有账户？';

  @override
  String get already_have_account => '已有账户？';

  @override
  String get create_account => '创建账户';

  @override
  String get full_name => '全名';

  @override
  String get first_name => '名';

  @override
  String get second_name => '中间名';

  @override
  String get third_name => '第三名';

  @override
  String get fourth_name => '第四名';

  @override
  String get phone => '电话';

  @override
  String get location => '位置';

  @override
  String get currency => '货币';

  @override
  String get account_type => '账户类型';

  @override
  String get buyer => '买家';

  @override
  String get seller => '卖家';

  @override
  String get next => '下一步';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get save => '保存';

  @override
  String get save_changes => '保存更改';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get user => '用户';

  @override
  String get guest => '访客';

  @override
  String get login_success => '登录成功';

  @override
  String get login_failed => '登录失败';

  @override
  String get signup_success => '账户创建成功';

  @override
  String get signup_failed => '账户创建失败';

  @override
  String get logout_success => '退出成功';

  @override
  String get password_reset_sent => '重置链接已发送到您的邮箱';

  @override
  String get password_reset_failed => '发送重置链接失败';

  @override
  String get invalid_email => '请输入有效的邮箱';

  @override
  String get invalid_password => '密码至少需要6个字符';

  @override
  String get passwords_do_not_match => '密码不匹配';

  @override
  String get email_required => '邮箱是必需的';

  @override
  String get password_required => '密码是必需的';

  @override
  String get name_required => '名称是必需的';

  @override
  String get phone_required => '电话号码是必需的';

  @override
  String get valid_phone_number => '请输入有效的电话号码（8-15位数字）';

  @override
  String get signup_subtitle => '创建您的卖家账户';

  @override
  String get first => '第一';

  @override
  String get second => '第二';

  @override
  String get third => '第三';

  @override
  String get fourth => '第四';

  @override
  String get phone_number => '电话号码';

  @override
  String get enter_email => '请输入您的邮箱';

  @override
  String get enter_valid_email => '请输入有效的邮箱';

  @override
  String get enter_password => '请输入密码';

  @override
  String get password_min_length => '密码至少需要8个字符';

  @override
  String get password_uppercase => '密码必须包含至少一个大写字母';

  @override
  String get password_lowercase => '密码必须包含至少一个小写字母';

  @override
  String get password_number => '密码必须包含至少一个数字';

  @override
  String get confirm_password_label => '确认密码';

  @override
  String get enter_confirm_password => '请确认您的密码';

  @override
  String get passwords_not_match => '密码不匹配';

  @override
  String signup_failed_error(String error) {
    return '注册失败：$error';
  }

  @override
  String already_have_account_login(String login) {
    return '已有账户？$login';
  }

  @override
  String get location_required_signup => '注册需要位置信息';

  @override
  String get location_permission_denied => '位置权限被拒绝';

  @override
  String get get_current_location => '获取当前位置';

  @override
  String get select_location => '选择位置';

  @override
  String get continue_google => '继续使用 Google';

  @override
  String get creating_account => '正在创建账户...';

  @override
  String pending_orders_count(int count) {
    return '$count个待处理';
  }

  @override
  String get daily_revenue => '日收入';

  @override
  String get weekly_revenue => '周收入';

  @override
  String get monthly_revenue => '月收入';

  @override
  String get seller_dashboard => '卖家仪表板';

  @override
  String get recent_activity => '最近活动';

  @override
  String get quick_actions => '快捷操作';

  @override
  String get view_all => '查看全部';

  @override
  String get no_activity => '没有最近活动';

  @override
  String get sales => '销售';

  @override
  String get products => '产品';

  @override
  String get customers => '客户';

  @override
  String get orders => '订单';

  @override
  String get record_sale => '记录销售';

  @override
  String get add_product => '添加产品';

  @override
  String get manage_products => '管理产品';

  @override
  String get manage_customers => '管理客户';

  @override
  String get track_orders => '跟踪订单';

  @override
  String get no_customers => '暂无客户';

  @override
  String get no_products => '暂无产品';

  @override
  String get total_revenue => '总收入';

  @override
  String get pending_orders => '待处理订单';

  @override
  String get completed_orders => '已完成订单';

  @override
  String welcome_message(String name) {
    return '欢迎，$name！';
  }

  @override
  String get location_required => '位置是必需的';

  @override
  String get home => '首页';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get notification_settings => '通知设置';

  @override
  String get mark_all_read => '全部标记为已读';

  @override
  String get no_notifications => '暂无通知';

  @override
  String get delete_notification => '删除通知';

  @override
  String get delete_notification_confirm => '您确定要删除此通知吗？';

  @override
  String get notification_deleted => '通知已删除';

  @override
  String get my_profile => '我的资料';

  @override
  String get edit_profile => '编辑资料';

  @override
  String get profile_updated => '资料更新成功';

  @override
  String get profile_save_failed => '资料保存失败';

  @override
  String get profile_load_failed => '资料加载失败';

  @override
  String get first_name_placeholder => '请输入您的名字';

  @override
  String get second_name_placeholder => '请输入您的中间名';

  @override
  String get third_name_placeholder => '请输入您的第三名';

  @override
  String get fourth_name_placeholder => '请输入您的第四名';

  @override
  String get email_placeholder => '请输入您的邮箱';

  @override
  String get phone_placeholder => '请输入您的电话';

  @override
  String get location_placeholder => '请输入您的位置';

  @override
  String get product => '产品';

  @override
  String get all_products => '所有产品';

  @override
  String get my_products => '我的产品';

  @override
  String get edit_product => '编辑产品';

  @override
  String get delete_product => '删除产品';

  @override
  String get delete_product_confirm => '您确定要删除此产品吗？';

  @override
  String get product_name => '产品名称';

  @override
  String get product_description => '描述';

  @override
  String get product_price => '价格';

  @override
  String get product_category => '类别';

  @override
  String get product_brand => '品牌';

  @override
  String get product_stock => '库存';

  @override
  String get product_images => '图片';

  @override
  String get product_added => '产品添加成功';

  @override
  String get product_updated => '产品更新成功';

  @override
  String get product_deleted => '产品删除成功';

  @override
  String get product_save_failed => '产品保存失败';

  @override
  String get out_of_stock => '缺货';

  @override
  String get in_stock => '有货';

  @override
  String get search_products => '搜索产品...';

  @override
  String get filter => '筛选';

  @override
  String get sort => '排序';

  @override
  String get sort_by => '排序方式';

  @override
  String get price_low_to_high => '价格：从低到高';

  @override
  String get price_high_to_low => '价格：从高到低';

  @override
  String get name_a_to_z => '名称：A 到 Z';

  @override
  String get name_z_to_a => '名称：Z 到 A';

  @override
  String get categories => '类别';

  @override
  String get category => '类别';

  @override
  String get all_categories => '所有类别';

  @override
  String get electronics => '电子产品';

  @override
  String get clothing => '服装';

  @override
  String get home_garden => '家居园艺';

  @override
  String get sports => '运动';

  @override
  String get books => '书籍';

  @override
  String get toys => '玩具';

  @override
  String get health_beauty => '健康美容';

  @override
  String get automotive => '汽车用品';

  @override
  String get other => '其他';

  @override
  String get cart => '购物车';

  @override
  String get my_cart => '我的购物车';

  @override
  String get add_to_cart => '加入购物车';

  @override
  String get remove_from_cart => '从购物车移除';

  @override
  String get view_cart => '查看购物车';

  @override
  String get checkout => '结账';

  @override
  String get total => '总计';

  @override
  String get subtotal => '小计';

  @override
  String get tax => '税费';

  @override
  String get shipping => '配送';

  @override
  String get discount => '折扣';

  @override
  String get apply_discount => '应用折扣';

  @override
  String get promo_code => '促销码';

  @override
  String get empty_cart => '您的购物车是空的';

  @override
  String get continue_shopping => '继续购物';

  @override
  String get wishlist => '心愿单';

  @override
  String get my_wishlist => '我的心愿单';

  @override
  String get add_to_wishlist => '加入心愿单';

  @override
  String get remove_from_wishlist => '从心愿单移除';

  @override
  String get remove_item => '移除商品';

  @override
  String remove_from_wishlist_confirm(Object productName) {
    return '将\"$productName\"从心愿单移除？';
  }

  @override
  String get removed_from_wishlist => '已从心愿单移除';

  @override
  String get empty_wishlist => '您的心愿单是空的';

  @override
  String get browse_products => '浏览产品';

  @override
  String get my_orders => '我的订单';

  @override
  String get order => '订单';

  @override
  String get order_id => '订单号';

  @override
  String get order_date => '订单日期';

  @override
  String get order_status => '状态';

  @override
  String get order_total => '总计';

  @override
  String get order_details => '详情';

  @override
  String get order_placed => '订单提交成功';

  @override
  String get order_failed => '订单提交失败';

  @override
  String get pending => '待处理';

  @override
  String get confirmed => '已确认';

  @override
  String get processing => '处理中';

  @override
  String get shipped => '已发货';

  @override
  String get delivered => '已送达';

  @override
  String get cancelled => '已取消';

  @override
  String get refunded => '已退款';

  @override
  String get track_order => '跟踪订单';

  @override
  String get cancel_order => '取消订单';

  @override
  String get cancel_order_confirm => '您确定要取消此订单吗？';

  @override
  String get chat => '聊天';

  @override
  String get chats => '聊天';

  @override
  String get messages => '消息';

  @override
  String get message => '消息';

  @override
  String get type_message => '输入消息...';

  @override
  String get send => '发送';

  @override
  String get send_message => '发送消息';

  @override
  String get no_chats => '暂无聊天';

  @override
  String get no_messages => '暂无消息';

  @override
  String get start_chat => '开始聊天';

  @override
  String get chat_with => '与...聊天';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get typing => '正在输入...';

  @override
  String get seen => '已读';

  @override
  String get image_message => '图片';

  @override
  String get file_message => '文件';

  @override
  String get deal_proposal => '交易提议';

  @override
  String get view_deal => '查看交易';

  @override
  String get accept_deal => '接受';

  @override
  String get reject_deal => '拒绝';

  @override
  String get deal_accepted => '交易已接受';

  @override
  String get deal_rejected => '交易已拒绝';

  @override
  String get commission_rate => '佣金率';

  @override
  String get negotiate => '协商';

  @override
  String get analytics => '分析';

  @override
  String get revenue => '收入';

  @override
  String get views => '浏览量';

  @override
  String get today => '今天';

  @override
  String get this_week => '本周';

  @override
  String get this_month => '本月';

  @override
  String get this_year => '今年';

  @override
  String get total_sales => '总销售';

  @override
  String get total_orders => '总订单';

  @override
  String get total_products => '总产品';

  @override
  String get average_order_value => '平均订单金额';

  @override
  String get top_products => '热门产品';

  @override
  String get recent_sales => '最近销售';

  @override
  String get sales_chart => '销售图表';

  @override
  String get revenue_chart => '收入图表';

  @override
  String get become_seller => '成为卖家';

  @override
  String get seller_profile => '卖家资料';

  @override
  String get seller_info => '卖家信息';

  @override
  String get seller_verified => '已验证卖家';

  @override
  String get seller_not_verified => '未验证';

  @override
  String get is_verified => '已验证';

  @override
  String get verification_status => '验证状态';

  @override
  String get account_balance => '账户余额';

  @override
  String get withdraw => '提现';

  @override
  String get withdrawal_history => '提现记录';

  @override
  String get settings_general => '通用设置';

  @override
  String get settings_account => '账户设置';

  @override
  String get settings_privacy => '隐私设置';

  @override
  String get settings_security => '安全设置';

  @override
  String get settings_notifications => '通知设置';

  @override
  String get settings_language => '语言';

  @override
  String get settings_theme => '主题';

  @override
  String get dark_mode => '深色模式';

  @override
  String get light_mode => '浅色模式';

  @override
  String get system_theme => '系统主题';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get arabic => '阿拉伯语';

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
  String get change_language => '更改语言';

  @override
  String get change_password => '更改密码';

  @override
  String get current_password => '当前密码';

  @override
  String get new_password => '新密码';

  @override
  String get confirm_new_password => '确认新密码';

  @override
  String get password_changed => '密码更改成功';

  @override
  String get password_change_failed => '密码更改失败';

  @override
  String get biometric => '生物识别认证';

  @override
  String get enable_biometric => '启用生物识别';

  @override
  String get disable_biometric => '禁用生物识别';

  @override
  String get biometric_enabled => '生物识别已启用';

  @override
  String get biometric_disabled => '生物识别已禁用';

  @override
  String get search => '搜索';

  @override
  String get search_hint => '搜索...';

  @override
  String get no_results => '未找到结果';

  @override
  String get try_different_search => '尝试不同的搜索词';

  @override
  String get filters => '筛选';

  @override
  String get price_range => '价格范围';

  @override
  String get min_price => '最低价';

  @override
  String get max_price => '最高价';

  @override
  String get apply_filters => '应用筛选';

  @override
  String get clear_filters => '清除筛选';

  @override
  String get shipping_address => '收货地址';

  @override
  String get billing_address => '账单地址';

  @override
  String get address_line_1 => '地址行1';

  @override
  String get address_line_2 => '地址行2';

  @override
  String get city => '城市';

  @override
  String get state => '省份';

  @override
  String get country => '国家';

  @override
  String get postal_code => '邮政编码';

  @override
  String get zip_code => '邮政编码';

  @override
  String get select_country => '选择国家';

  @override
  String get select_city => '选择城市';

  @override
  String get payment_method => '支付方式';

  @override
  String get payment_methods => '支付方式';

  @override
  String get add_payment_method => '添加支付方式';

  @override
  String get credit_card => '信用卡';

  @override
  String get debit_card => '借记卡';

  @override
  String get cash_on_delivery => '货到付款';

  @override
  String get bank_transfer => '银行转账';

  @override
  String get wallet => '钱包';

  @override
  String get card_number => '卡号';

  @override
  String get card_holder => '持卡人姓名';

  @override
  String get expiry_date => '有效期';

  @override
  String get cvv => 'CVV';

  @override
  String get reviews => '评价';

  @override
  String get review => '评价';

  @override
  String get write_review => '写评价';

  @override
  String get rating => '评分';

  @override
  String get ratings => '评分';

  @override
  String get no_reviews => '暂无评价';

  @override
  String get add_review => '添加评价';

  @override
  String get review_title => '评价标题';

  @override
  String get review_comment => '您的评价';

  @override
  String get review_submitted => '评价提交成功';

  @override
  String get review_failed => '评价提交失败';

  @override
  String get help => '帮助';

  @override
  String get help_center => '帮助中心';

  @override
  String get faq => '常见问题';

  @override
  String get contact_us => '联系我们';

  @override
  String get about => '关于';

  @override
  String get about_us => '关于我们';

  @override
  String get terms_of_service => '服务条款';

  @override
  String get privacy_policy => '隐私政策';

  @override
  String get version => '版本';

  @override
  String get are_you_sure => '您确定吗？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get close => '关闭';

  @override
  String get done => '完成';

  @override
  String get finish => '结束';

  @override
  String get back => '返回';

  @override
  String get continue_btn => '继续';

  @override
  String get skip => '跳过';

  @override
  String get learn_more => '了解更多';

  @override
  String get see_more => '查看更多';

  @override
  String get see_less => '收起';

  @override
  String get image_pick_failed => '选择图片失败';

  @override
  String get camera => '相机';

  @override
  String get gallery => '相册';

  @override
  String get take_photo => '拍照';

  @override
  String get choose_from_gallery => '从相册选择';

  @override
  String get upload_image => '上传图片';

  @override
  String get remove_image => '移除图片';

  @override
  String get permission_required => '需要权限';

  @override
  String get permission_denied => '权限被拒绝';

  @override
  String get permission_location => '此功能需要位置权限';

  @override
  String get permission_camera => '需要相机权限';

  @override
  String get permission_storage => '需要存储权限';

  @override
  String get permission_notification => '需要通知权限';

  @override
  String get open_settings => '打开设置';

  @override
  String get connection_lost => '连接丢失';

  @override
  String get check_internet => '请检查您的网络连接';

  @override
  String get server_error => '服务器错误，请稍后重试';

  @override
  String get something_went_wrong => '出现问题';

  @override
  String get try_again => '重试';

  @override
  String get copied_to_clipboard => '已复制到剪贴板';

  @override
  String get share => '分享';

  @override
  String get copy => '复制';

  @override
  String get qr_code => '二维码';

  @override
  String get scan_qr => '扫描二维码';

  @override
  String get qr_product_info => '产品信息';

  @override
  String get nearby => '附近';

  @override
  String get nearby_sellers => '附近卖家';

  @override
  String get nearby_products => '附近产品';

  @override
  String get distance => '距离';

  @override
  String get km => '公里';

  @override
  String get m => '米';

  @override
  String get deals => '交易';

  @override
  String get my_deals => '我的交易';

  @override
  String get active_deals => '进行中的交易';

  @override
  String get completed_deals => '已完成的交易';

  @override
  String get deal_status => '交易状态';

  @override
  String get create_deal => '创建交易';

  @override
  String get update_deal => '更新交易';

  @override
  String get presence_online => '在线';

  @override
  String get presence_offline => '离线';

  @override
  String get presence_away => '离开';

  @override
  String get presence_busy => '忙碌';

  @override
  String get refresh => '刷新';

  @override
  String get pull_to_refresh => '下拉刷新';

  @override
  String get last_updated => '最后更新';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get not_available => '此设备不可用';

  @override
  String get not_enrolled => '未注册生物识别';

  @override
  String get browsing_history => '浏览历史';

  @override
  String get coming_soon => '即将推出';

  @override
  String get push_notifications => '推送通知';

  @override
  String get select_language => '选择语言';

  @override
  String language_changed(String lang) {
    return '语言已更改为 $lang';
  }

  @override
  String get low_stock_alert => '低库存警告';

  @override
  String only_left(Object count) {
    return '仅剩 $count 件';
  }

  @override
  String last_days(Object days) {
    return '最近 $days 天';
  }

  @override
  String get transactions => '交易';

  @override
  String get active_customers => '活跃';

  @override
  String get add_product_action => '添加产品';

  @override
  String get record_sale_action => '记录销售';

  @override
  String get view_customers_action => '查看客户';

  @override
  String get sales_report => '销售报告';

  @override
  String low_stock_product(String product, int count) {
    return '$product - 仅剩 $count 件';
  }

  @override
  String last_days_key(int days) {
    return '最近 $days 天';
  }

  @override
  String pending_count(int count) {
    return '$count 个待处理';
  }

  @override
  String only_count_left(int count) {
    return '仅剩 $count 件';
  }

  @override
  String get good_morning => '早上好';

  @override
  String get good_afternoon => '下午好';

  @override
  String get good_evening => '晚上好';

  @override
  String get manage_store => '管理店铺';

  @override
  String get quick_stats => '快速统计';
}
