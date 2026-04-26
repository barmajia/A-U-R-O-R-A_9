/// Seller Analytics Data Model
/// Represents complete seller data snapshot for JSON export and analysis
///
/// This model collects:
/// - Seller profile information
/// - All customers linked to seller
/// - All sales transactions
/// - Computed KPIs and analytics
/// - Addresses and location data

import 'customer.dart';
import 'sale.dart';
import 'seller.dart';

class SellerAnalyticsData {
  final String sellerId;
  final DateTime generatedAt;

  // Seller Profile
  final SellerProfile sellerProfile;

  // Collections
  final List<CustomerData> customers;
  final List<SaleData> sales;
  final List<AddressData> addresses;

  // Computed KPIs
  final AnalyticsKPIs kpis;

  // Metadata
  final Map<String, dynamic> metadata;

  SellerAnalyticsData({
    required this.sellerId,
    required this.generatedAt,
    required this.sellerProfile,
    required this.customers,
    required this.sales,
    required this.addresses,
    required this.kpis,
    this.metadata = const {},
  });

  /// Create from database data
  factory SellerAnalyticsData.fromData({
    required Seller seller,
    required List<Customer> customerList,
    required List<Sale> saleList,
    required List<AddressData> addressList,
    Map<String, dynamic>? extraMetadata,
  }) {
    final now = DateTime.now();

    // Convert customers to CustomerData
    final customers = customerList
        .map((c) => CustomerData.fromCustomer(c))
        .toList();

    // Convert sales to SaleData
    final sales = saleList.map((s) => SaleData.fromSale(s)).toList();

    // Calculate KPIs
    final kpis = AnalyticsKPIs.calculate(customers: customers, sales: sales);

    // Build seller profile
    final sellerProfile = SellerProfile.fromSeller(seller);

    return SellerAnalyticsData(
      sellerId: seller.id.toString(),
      generatedAt: now,
      sellerProfile: sellerProfile,
      customers: customers,
      sales: sales,
      addresses: addressList,
      kpis: kpis,
      metadata: extraMetadata ?? {},
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'seller_id': sellerId,
      'generated_at': generatedAt.toIso8601String(),
      'seller_profile': sellerProfile.toJson(),
      'customers': customers.map((c) => c.toJson()).toList(),
      'sales': sales.map((s) => s.toJson()).toList(),
      'addresses': addresses.map((a) => a.toJson()).toList(),
      'kpis': kpis.toJson(),
      'metadata': metadata,
    };
  }

  /// Create from JSON map
  factory SellerAnalyticsData.fromJson(Map<String, dynamic> json) {
    return SellerAnalyticsData(
      sellerId: json['seller_id'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      sellerProfile: SellerProfile.fromJson(
        json['seller_profile'] as Map<String, dynamic>,
      ),
      customers: (json['customers'] as List)
          .map((c) => CustomerData.fromJson(c as Map<String, dynamic>))
          .toList(),
      sales: (json['sales'] as List)
          .map((s) => SaleData.fromJson(s as Map<String, dynamic>))
          .toList(),
      addresses: (json['addresses'] as List)
          .map((a) => AddressData.fromJson(a as Map<String, dynamic>))
          .toList(),
      kpis: AnalyticsKPIs.fromJson(json['kpis'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Get filename for this seller data
  String get filename => '$sellerId/$sellerId.json';

  @override
  String toString() =>
      'SellerAnalyticsData(sellerId: $sellerId, customers: ${customers.length}, sales: ${sales.length})';
}

/// Seller Profile Data
class SellerProfile {
  final int id;
  final String email;
  final String fullName;
  final String location;
  final String currency;
  final String phoneNumber;
  final int age;
  final double? latitude;
  final double? longitude;

  SellerProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.location,
    required this.currency,
    required this.phoneNumber,
    required this.age,
    this.latitude,
    this.longitude,
  });
  //yousef

  factory SellerProfile.fromSeller(Seller seller) {
    return SellerProfile(
      id: seller.id ?? 0,
      email: seller.email,
      fullName: seller.fullName,
      location: seller.location,
      currency: seller.currency,
      phoneNumber: seller.phone,
      age: 0,
      latitude: seller.latitude,
      longitude: seller.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'location': location,
      'currency': currency,
      'phone_number': phoneNumber,
      'age': age,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      location: json['location'] as String,
      currency: json['currency'] as String,
      phoneNumber: json['phone_number'] as String,
      age: json['age'] as int,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

/// Customer Data for export
class CustomerData {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? ageRange;
  final String? notes;
  final int totalOrders;
  final double totalSpent;
  final DateTime? lastPurchaseDate;
  final String customerStatus;
  final double averageOrderValue;
  final bool isActive;
  final DateTime? createdAt;

  CustomerData({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.ageRange,
    this.notes,
    required this.totalOrders,
    required this.totalSpent,
    this.lastPurchaseDate,
    required this.customerStatus,
    required this.averageOrderValue,
    required this.isActive,
    this.createdAt,
  });

  /// Get status for display (used in UI)
  String get status => customerStatus;

  /// Get initials for avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Get last order date
  DateTime? get lastOrderDate => lastPurchaseDate;

  factory CustomerData.fromCustomer(Customer customer) {
    return CustomerData(
      id: customer.id ?? '',
      name: customer.name,
      phone: customer.phone,
      email: customer.email,
      ageRange: customer.ageRange,
      notes: customer.notes,
      totalOrders: customer.totalOrders,
      totalSpent: customer.totalSpent,
      lastPurchaseDate: customer.lastPurchaseDate,
      customerStatus: customer.customerStatus,
      averageOrderValue: customer.averageOrderValue,
      isActive: customer.isActive,
      createdAt: customer.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'age_range': ageRange,
      'notes': notes,
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'last_purchase_date': lastPurchaseDate?.toIso8601String(),
      'customer_status': customerStatus,
      'average_order_value': averageOrderValue,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      ageRange: json['age_range'] as String?,
      notes: json['notes'] as String?,
      totalOrders: json['total_orders'] as int? ?? 0,
      totalSpent:
          double.tryParse(json['total_spent']?.toString() ?? '0') ?? 0.0,
      lastPurchaseDate: json['last_purchase_date'] != null
          ? DateTime.parse(json['last_purchase_date'] as String)
          : null,
      customerStatus: json['customer_status'] as String? ?? 'New',
      averageOrderValue:
          double.tryParse(json['average_order_value']?.toString() ?? '0') ??
          0.0,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

/// Sale Data for export
class SaleData {
  final String id;
  final String? customerId;
  final String? customerName;
  final String? productId;
  final String? productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final double discount;
  final double netTotal;
  final String? paymentMethod;
  final String paymentStatus;
  final DateTime saleDate;

  SaleData({
    required this.id,
    this.customerId,
    this.customerName,
    this.productId,
    this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.discount = 0.0,
    required this.netTotal,
    this.paymentMethod,
    required this.paymentStatus,
    required this.saleDate,
  });

  factory SaleData.fromSale(Sale sale) {
    String? productName;
    if (sale.product != null) {
      final productMap = sale.product as Map<String, dynamic>?;
      productName = productMap?['name'] as String?;
    }
    return SaleData(
      id: sale.id ?? '',
      customerId: sale.customerId,
      customerName: sale.customer?.name,
      productId: sale.productId,
      productName: productName,
      quantity: sale.quantity,
      unitPrice: sale.unitPrice,
      totalPrice: sale.totalPrice,
      discount: sale.discount,
      netTotal: sale.netTotal,
      paymentMethod: sale.paymentMethod,
      paymentStatus: sale.paymentStatus,
      saleDate: sale.saleDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'discount': discount,
      'net_total': netTotal,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'sale_date': saleDate.toIso8601String(),
    };
  }

  factory SaleData.fromJson(Map<String, dynamic> json) {
    return SaleData(
      id: json['id'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      netTotal: double.tryParse(json['net_total']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String? ?? 'completed',
      saleDate: DateTime.parse(json['sale_date'] as String),
    );
  }
}

/// Address Data
class AddressData {
  final String id;
  final String type; // home, work, other
  final String fullAddress;
  final String? city;
  final String? region;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final DateTime? createdAt;

  AddressData({
    required this.id,
    required this.type,
    required this.fullAddress,
    this.city,
    this.region,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'full_address': fullAddress,
      'city': city,
      'region': region,
      'country': country,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json['id'] as String,
      type: json['type'] as String,
      fullAddress: json['full_address'] as String,
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

/// Analytics KPIs
class AnalyticsKPIs {
  // Revenue Metrics
  final double totalRevenue;
  final double totalRevenueThisPeriod;
  final double averageOrderValue;
  final double averageDailyRevenue;

  // Sales Metrics
  final int totalSales;
  final int totalSalesThisPeriod;
  final int totalItemsSold;
  final double conversionRate;

  // Customer Metrics
  final int totalCustomers;
  final int activeCustomers;
  final int newCustomersThisPeriod;
  final double customerRetentionRate;
  final double customerLifetimeValue;

  // Period Info
  final String period;
  final int periodDays;
  final DateTime calculatedAt;

  AnalyticsKPIs({
    required this.totalRevenue,
    required this.totalRevenueThisPeriod,
    required this.averageOrderValue,
    required this.averageDailyRevenue,
    required this.totalSales,
    required this.totalSalesThisPeriod,
    required this.totalItemsSold,
    required this.conversionRate,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.newCustomersThisPeriod,
    required this.customerRetentionRate,
    required this.customerLifetimeValue,
    required this.period,
    required this.periodDays,
    required this.calculatedAt,
  });

  /// Calculate KPIs from data
  factory AnalyticsKPIs.calculate({
    required List<CustomerData> customers,
    required List<SaleData> sales,
    String period = '30d',
  }) {
    final now = DateTime.now();
    final days = int.tryParse(period.replaceAll('d', '')) ?? 30;
    final startDate = now.subtract(Duration(days: days));

    // Filter sales by period
    final periodSales = sales
        .where((s) => s.saleDate.isAfter(startDate))
        .toList();

    // Revenue calculations
    final totalRevenue = sales.fold<double>(0, (sum, s) => sum + s.netTotal);
    final totalRevenueThisPeriod = periodSales.fold<double>(
      0,
      (sum, s) => sum + s.netTotal,
    );
    final averageOrderValue = sales.isNotEmpty
        ? totalRevenue / sales.length
        : 0.0;
    final averageDailyRevenue = days > 0 ? totalRevenueThisPeriod / days : 0.0;

    // Sales calculations
    final totalSales = sales.length;
    final totalSalesThisPeriod = periodSales.length;
    final totalItemsSold = sales.fold<int>(0, (sum, s) => sum + s.quantity);
    final conversionRate = 0.0; // Would need visitor data

    // Customer calculations
    final totalCustomers = customers.length;
    final activeCustomers = customers.where((c) => c.isActive).length;
    final newCustomersThisPeriod = customers
        .where(
          (c) =>
              c.lastPurchaseDate != null &&
              c.lastPurchaseDate!.isAfter(startDate),
        )
        .length;

    // Retention rate (simplified)
    final customerRetentionRate = totalCustomers > 0
        ? (activeCustomers / totalCustomers) * 100
        : 0.0;

    // Customer lifetime value
    final customerLifetimeValue = totalCustomers > 0
        ? totalRevenue / totalCustomers
        : 0.0;

    return AnalyticsKPIs(
      totalRevenue: totalRevenue,
      totalRevenueThisPeriod: totalRevenueThisPeriod,
      averageOrderValue: averageOrderValue,
      averageDailyRevenue: averageDailyRevenue,
      totalSales: totalSales,
      totalSalesThisPeriod: totalSalesThisPeriod,
      totalItemsSold: totalItemsSold,
      conversionRate: conversionRate,
      totalCustomers: totalCustomers,
      activeCustomers: activeCustomers,
      newCustomersThisPeriod: newCustomersThisPeriod,
      customerRetentionRate: customerRetentionRate,
      customerLifetimeValue: customerLifetimeValue,
      period: period,
      periodDays: days,
      calculatedAt: now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': {
        'total_revenue': totalRevenue,
        'total_revenue_this_period': totalRevenueThisPeriod,
        'average_order_value': averageOrderValue,
        'average_daily_revenue': averageDailyRevenue,
      },
      'sales': {
        'total_sales': totalSales,
        'total_sales_this_period': totalSalesThisPeriod,
        'total_items_sold': totalItemsSold,
        'conversion_rate': conversionRate,
      },
      'customers': {
        'total_customers': totalCustomers,
        'active_customers': activeCustomers,
        'new_customers_this_period': newCustomersThisPeriod,
        'customer_retention_rate': customerRetentionRate,
        'customer_lifetime_value': customerLifetimeValue,
      },
      'period': {
        'period': period,
        'period_days': periodDays,
        'calculated_at': calculatedAt.toIso8601String(),
      },
    };
  }

  factory AnalyticsKPIs.fromJson(Map<String, dynamic> json) {
    final revenue = json['revenue'] as Map<String, dynamic>;
    final sales = json['sales'] as Map<String, dynamic>;
    final customers = json['customers'] as Map<String, dynamic>;
    final period = json['period'] as Map<String, dynamic>;

    return AnalyticsKPIs(
      totalRevenue:
          double.tryParse(revenue['total_revenue']?.toString() ?? '0') ?? 0.0,
      totalRevenueThisPeriod:
          double.tryParse(
            revenue['total_revenue_this_period']?.toString() ?? '0',
          ) ??
          0.0,
      averageOrderValue:
          double.tryParse(revenue['average_order_value']?.toString() ?? '0') ??
          0.0,
      averageDailyRevenue:
          double.tryParse(
            revenue['average_daily_revenue']?.toString() ?? '0',
          ) ??
          0.0,
      totalSales: sales['total_sales'] as int? ?? 0,
      totalSalesThisPeriod: sales['total_sales_this_period'] as int? ?? 0,
      totalItemsSold: sales['total_items_sold'] as int? ?? 0,
      conversionRate:
          double.tryParse(sales['conversion_rate']?.toString() ?? '0') ?? 0.0,
      totalCustomers: customers['total_customers'] as int? ?? 0,
      activeCustomers: customers['active_customers'] as int? ?? 0,
      newCustomersThisPeriod:
          customers['new_customers_this_period'] as int? ?? 0,
      customerRetentionRate:
          double.tryParse(
            customers['customer_retention_rate']?.toString() ?? '0',
          ) ??
          0.0,
      customerLifetimeValue:
          double.tryParse(
            customers['customer_lifetime_value']?.toString() ?? '0',
          ) ??
          0.0,
      period: period['period'] as String? ?? '30d',
      periodDays: period['period_days'] as int? ?? 30,
      calculatedAt: DateTime.parse(period['calculated_at'] as String),
    );
  }
}
