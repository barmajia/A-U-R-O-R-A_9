import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.company = '',
    this.address = '',
    required this.createdAt,
    required this.updatedAt,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'company': company,
        'address': address,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        company: json['company'] as String? ?? '',
        address: json['address'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  factory UserData.empty() {
    final now = DateTime.now();
    return UserData(
      id: '',
      name: 'Unknown',
      email: '',
      phone: '',
      company: '',
      address: '',
      createdAt: now,
      updatedAt: now,
    );
  }
}

class DealItem {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  DealItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'subtotal': subtotal,
      };

  factory DealItem.fromJson(Map<String, dynamic> json) => DealItem(
        productName: json['productName'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        subtotal: (json['subtotal'] as num).toDouble(),
      );
}

class DealTransaction {
  final String id;
  final DateTime date;
  final double totalAmount;
  final int itemCount;
  final String paymentMethod;
  final String status;
  final String notes;
  final List<DealItem> items;

  DealTransaction({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.itemCount,
    required this.paymentMethod,
    required this.status,
    required this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'totalAmount': totalAmount,
        'itemCount': itemCount,
        'paymentMethod': paymentMethod,
        'status': status,
        'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory DealTransaction.fromJson(Map<String, dynamic> json) => DealTransaction(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        itemCount: json['itemCount'] as int,
        paymentMethod: json['paymentMethod'] as String,
        status: json['status'] as String,
        notes: json['notes'] as String,
        items: (json['items'] as List)
            .map((e) => DealItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class CustomerData {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String notes;
  final List<DealTransaction> deals;
  int totalDeals;
  double totalSpent;
  DateTime? lastDealDate;
  final DateTime createdAt;

  CustomerData({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.deals,
    this.totalDeals = 0,
    this.totalSpent = 0.0,
    this.lastDealDate,
    required this.createdAt,
  });

  CustomerData copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? notes,
    List<DealTransaction>? deals,
    int? totalDeals,
    double? totalSpent,
    DateTime? lastDealDate,
    DateTime? createdAt,
  }) {
    return CustomerData(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      deals: deals ?? this.deals,
      totalDeals: totalDeals ?? this.totalDeals,
      totalSpent: totalSpent ?? this.totalSpent,
      lastDealDate: lastDealDate ?? this.lastDealDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'notes': notes,
        'deals': deals.map((e) => e.toJson()).toList(),
        'totalDeals': totalDeals,
        'totalSpent': totalSpent,
        'lastDealDate': lastDealDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        notes: json['notes'] as String,
        deals: (json['deals'] as List)
            .map((e) => DealTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalDeals: json['totalDeals'] as int? ?? 0,
        totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
        lastDealDate: json['lastDealDate'] != null
            ? DateTime.parse(json['lastDealDate'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class OfflineDatabase {
  final UserData user;
  final List<CustomerData> customers;

  OfflineDatabase({
    required this.user,
    required this.customers,
  });

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'customers': customers.map((e) => e.toJson()).toList(),
      };

  factory OfflineDatabase.fromJson(Map<String, dynamic> json) => OfflineDatabase(
        user: UserData.fromJson(json['user'] as Map<String, dynamic>),
        customers: (json['customers'] as List)
            .map((e) => CustomerData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  String toJsonString() => jsonEncode(toJson());

  factory OfflineDatabase.fromJsonString(String jsonString) =>
      OfflineDatabase.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}