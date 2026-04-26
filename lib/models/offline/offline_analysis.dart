import 'offline_database.dart';

class AnalysisMetrics {
  final double totalRevenue;
  final int totalDeals;
  final int totalItemsSold;
  final double averageOrderValue;
  final int activeCustomers;
  final int newCustomers;
  final double customerRetentionRate;
  final double dailyAverageRevenue;

  AnalysisMetrics({
    required this.totalRevenue,
    required this.totalDeals,
    required this.totalItemsSold,
    required this.averageOrderValue,
    required this.activeCustomers,
    required this.newCustomers,
    required this.customerRetentionRate,
    required this.dailyAverageRevenue,
  });

  Map<String, dynamic> toJson() => {
        'totalRevenue': totalRevenue,
        'totalDeals': totalDeals,
        'totalItemsSold': totalItemsSold,
        'averageOrderValue': averageOrderValue,
        'activeCustomers': activeCustomers,
        'newCustomers': newCustomers,
        'customerRetentionRate': customerRetentionRate,
        'dailyAverageRevenue': dailyAverageRevenue,
      };

  factory AnalysisMetrics.fromJson(Map<String, dynamic> json) => AnalysisMetrics(
        totalRevenue: (json['totalRevenue'] as num).toDouble(),
        totalDeals: json['totalDeals'] as int,
        totalItemsSold: json['totalItemsSold'] as int,
        averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
        activeCustomers: json['activeCustomers'] as int,
        newCustomers: json['newCustomers'] as int,
        customerRetentionRate: (json['customerRetentionRate'] as num).toDouble(),
        dailyAverageRevenue: (json['dailyAverageRevenue'] as num).toDouble(),
      );
}

class CustomerInsight {
  final String customerId;
  final String customerName;
  final double totalSpent;
  final int dealCount;
  final DateTime lastDealDate;
  final double averageOrderValue;

  CustomerInsight({
    required this.customerId,
    required this.customerName,
    required this.totalSpent,
    required this.dealCount,
    required this.lastDealDate,
    required this.averageOrderValue,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'customerName': customerName,
        'totalSpent': totalSpent,
        'dealCount': dealCount,
        'lastDealDate': lastDealDate.toIso8601String(),
        'averageOrderValue': averageOrderValue,
      };

  factory CustomerInsight.fromJson(Map<String, dynamic> json) => CustomerInsight(
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        totalSpent: (json['totalSpent'] as num).toDouble(),
        dealCount: json['dealCount'] as int,
        lastDealDate: DateTime.parse(json['lastDealDate'] as String),
        averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      );
}

class ProductInsight {
  final String productId;
  final String productName;
  final int quantitySold;
  final double totalRevenue;
  final int dealCount;

  ProductInsight({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.totalRevenue,
    required this.dealCount,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'quantitySold': quantitySold,
        'totalRevenue': totalRevenue,
        'dealCount': dealCount,
      };

  factory ProductInsight.fromJson(Map<String, dynamic> json) => ProductInsight(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        quantitySold: json['quantitySold'] as int,
        totalRevenue: (json['totalRevenue'] as num).toDouble(),
        dealCount: json['dealCount'] as int,
      );
}

class PeriodAnalysis {
  final String id;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final AnalysisMetrics metrics;
  final List<CustomerInsight> topCustomers;
  final List<ProductInsight> topProducts;
  final DateTime createdAt;

  PeriodAnalysis({
    required this.id,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.metrics,
    required this.topCustomers,
    required this.topProducts,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'period': period,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'metrics': metrics.toJson(),
        'topCustomers': topCustomers.map((e) => e.toJson()).toList(),
        'topProducts': topProducts.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory PeriodAnalysis.fromJson(Map<String, dynamic> json) => PeriodAnalysis(
        id: json['id'] as String,
        period: json['period'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        metrics: AnalysisMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
        topCustomers: (json['topCustomers'] as List)
            .map((e) => CustomerInsight.fromJson(e as Map<String, dynamic>))
            .toList(),
        topProducts: (json['topProducts'] as List)
            .map((e) => ProductInsight.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class OfflineAnalysisDatabase {
  final UserData user;
  final List<PeriodAnalysis> analyses;

  OfflineAnalysisDatabase({
    required this.user,
    required this.analyses,
  });

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'analyses': analyses.map((e) => e.toJson()).toList(),
      };

  factory OfflineAnalysisDatabase.fromJson(Map<String, dynamic> json) =>
      OfflineAnalysisDatabase(
        user: UserData.fromJson(json['user'] as Map<String, dynamic>),
        analyses: (json['analyses'] as List)
            .map((e) => PeriodAnalysis.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static OfflineAnalysisDatabase empty(UserData user) =>
      OfflineAnalysisDatabase(user: user, analyses: []);
}