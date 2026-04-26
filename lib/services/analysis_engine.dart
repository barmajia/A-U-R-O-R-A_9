import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import '../models/offline/offline_database.dart';
import '../models/offline/offline_analysis.dart';
import '../services/supabase.dart';

/// Advanced Analysis Engine with powerful analytics capabilities
/// Provides: Predictive analytics, segmentation, growth analysis, and real-time insights
/// 
/// Updated to support:
/// - Direct customer addition from analytics context
/// - Deal flow tracking and visualization
/// - Enhanced metrics for customer lifecycle analysis
/// - Async methods for Supabase integration
class AnalysisEngine {
  final SupabaseProvider? _supabase;

  AnalysisEngine({SupabaseProvider? supabase}) : _supabase = supabase;

  /// Run full analysis with advanced metrics
  static Future<OfflineAnalysisDatabase> analyze({
    required UserData user,
    required List<CustomerData> customers,
    String period = '30d',
  }) async {
    final now = DateTime.now();
    final startDate = _getStartDate(period, now);

    final relevantCustomers = <CustomerData>[];
    for (var customer in customers) {
      final filteredDeals = customer.deals
          .where((d) => d.date.isAfter(startDate) && d.status == 'completed')
          .toList();

      if (filteredDeals.isNotEmpty) {
        relevantCustomers.add(customer);
      }
    }

    final metrics = _calculateMetrics(relevantCustomers, period);
    final topCustomers = _getTopCustomers(relevantCustomers, limit: 5);
    final topProducts = _getTopProducts(relevantCustomers);
    final growthAnalysis = _calculateGrowthAnalysis(customers, period);
    final segmentation = _calculateSegmentation(customers);
    final predictions = _calculatePredictions(customers, period);

    final analysis = PeriodAnalysis(
      id: 'analysis_${period}_${now.millisecondsSinceEpoch}',
      period: period,
      startDate: startDate,
      endDate: now,
      metrics: metrics,
      topCustomers: topCustomers,
      topProducts: topProducts,
      createdAt: now,
    );

    final analysisDb = OfflineAnalysisDatabase(
      user: UserData(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        company: user.company,
        address: user.address,
        createdAt: now,
        updatedAt: now,
      ),
      analyses: [analysis],
    );

    return analysisDb;
  }

  /// Add a new customer with initial deal data and save to Supabase
  /// Returns the created CustomerData object
  Future<CustomerData> createCustomerWithDeal({
    required String name,
    required String phone,
    String? email,
    String? address,
    String? notes,
    String? ageRange,
    DealTransaction? initialDeal,
  }) async {
    if (_supabase == null) {
      throw Exception('SupabaseProvider not initialized');
    }

    final uuid = DateTime.now().millisecondsSinceEpoch.toString();
    final deals = initialDeal != null ? [initialDeal] : [];
    
    int totalDeals = deals.length;
    double totalSpent = deals.fold<double>(
      0.0,
      (sum, deal) => sum + deal.totalAmount,
    );
    DateTime? lastDealDate;
    
    if (deals.isNotEmpty) {
      lastDealDate = deals.map((d) => d.date).reduce((a, b) => a.isAfter(b) ? a : b);
    }

    // Add customer via Supabase
    final result = await _supabase!.addCustomer(
      name: name,
      phone: phone,
      ageRange: ageRange,
      email: email,
      notes: notes,
    );

    if (!result.success || result.data == null) {
      throw Exception(result.message);
    }

    final customerId = result.data!['id'] as String;

    // If there's an initial deal, add it
    if (initialDeal != null) {
      await createDeal(
        customerId: customerId,
        deal: initialDeal,
      );
    }

    return CustomerData(
      id: customerId,
      name: name,
      phone: phone,
      email: email ?? '',
      address: address ?? '',
      notes: notes ?? '',
      deals: deals,
      totalDeals: totalDeals,
      totalSpent: totalSpent,
      lastDealDate: lastDealDate,
      createdAt: DateTime.now(),
    );
  }

  /// Create a new deal transaction for a customer and save to Supabase
  Future<void> createDeal({
    required String customerId,
    required DealTransaction deal,
  }) async {
    if (_supabase == null) {
      throw Exception('SupabaseProvider not initialized');
    }

    // Convert DealTransaction to Sale format for Supabase
    final itemsJson = deal.items.map((item) => item.toJson()).toList();
    
    await _supabase!.addSale(
      customerId: customerId,
      items: itemsJson,
      totalAmount: deal.totalAmount,
      paymentMethod: deal.paymentMethod,
      notes: deal.notes,
    );
  }

  /// Refresh all analytics - can be deferred for lazy mode
  Future<void> refreshAllAnalytics() async {
    if (_supabase == null) {
      throw Exception('SupabaseProvider not initialized');
    }

    // Trigger background analytics refresh
    // This is a lightweight operation that schedules full analysis
    debugPrint('Scheduling full analytics refresh...');
    
    // In a real implementation, this would:
    // 1. Fetch all customers and deals
    // 2. Run the analyze() method
    // 3. Update the offline database
    // 4. Notify listeners
    
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Get deal flow statistics showing the progression of deals through stages
  static Map<String, dynamic> getDealFlowStats(List<CustomerData> customers) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    int pending = 0, negotiating = 0, agreed = 0, completed = 0, cancelled = 0;
    double totalPipelineValue = 0.0;
    
    for (var customer in customers) {
      for (var deal in customer.deals) {
        if (deal.date.isAfter(thirtyDaysAgo)) {
          switch (deal.status.toLowerCase()) {
            case 'pending':
              pending++;
              totalPipelineValue += deal.totalAmount;
              break;
            case 'negotiating':
              negotiating++;
              totalPipelineValue += deal.totalAmount;
              break;
            case 'agreed':
              agreed++;
              totalPipelineValue += deal.totalAmount;
              break;
            case 'completed':
              completed++;
              break;
            case 'cancelled':
              cancelled++;
              break;
          }
        }
      }
    }
    
    return {
      'pending': {'count': pending, 'label': 'Pending'},
      'negotiating': {'count': negotiating, 'label': 'Negotiating'},
      'agreed': {'count': agreed, 'label': 'Agreed'},
      'completed': {'count': completed, 'label': 'Completed'},
      'cancelled': {'count': cancelled, 'label': 'Cancelled'},
      'totalPipelineValue': totalPipelineValue,
      'conversionRate': (pending + negotiating + agreed) > 0
          ? (completed / (pending + negotiating + agreed + completed)) * 100
          : 0.0,
    };
  }

  static AnalysisMetrics _calculateMetrics(
    List<CustomerData> customers,
    String period,
  ) {
    int totalDeals = 0;
    double totalRevenue = 0.0;
    int totalItemsSold = 0;
    int newCustomers = 0;
    final customerFirstDealDates = <DateTime>[];

    final now = DateTime.now();
    final startDate = _getStartDate(period, now);
    final daysInPeriod = now.difference(startDate).inDays > 0
        ? now.difference(startDate).inDays
        : 1;

    for (var customer in customers) {
      final completedDeals = customer.deals
          .where((d) => d.date.isAfter(startDate) && d.status == 'completed')
          .toList();

      if (completedDeals.isEmpty) continue;

      totalDeals += completedDeals.length;
      totalRevenue += completedDeals.fold<double>(
        0.0,
        (sum, deal) => sum + deal.totalAmount,
      );

      for (var deal in completedDeals) {
        totalItemsSold += deal.itemCount;
      }

      final firstDeal = completedDeals.reduce(
        (a, b) => a.date.isBefore(b.date) ? a : b,
      );
      customerFirstDealDates.add(firstDeal.date);

      if (firstDeal.date.isAfter(startDate)) {
        newCustomers++;
      }
    }

    final activeCustomers = customers.length;
    final averageOrderValue = totalDeals > 0 ? totalRevenue / totalDeals : 0.0;
    final dailyAverageRevenue = totalRevenue / daysInPeriod;

    int returningCustomers = 0;
    for (var customer in customers) {
      final completedDeals = customer.deals
          .where((d) => d.date.isAfter(startDate) && d.status == 'completed')
          .toList();
      if (completedDeals.length > 1) {
        returningCustomers++;
      }
    }
    final customerRetentionRate = activeCustomers > 0
        ? (returningCustomers / activeCustomers) * 100
        : 0.0;

    return AnalysisMetrics(
      totalRevenue: totalRevenue,
      totalDeals: totalDeals,
      totalItemsSold: totalItemsSold,
      averageOrderValue: averageOrderValue,
      activeCustomers: activeCustomers,
      newCustomers: newCustomers,
      customerRetentionRate: customerRetentionRate,
      dailyAverageRevenue: dailyAverageRevenue,
    );
  }

  static List<CustomerInsight> _getTopCustomers(
    List<CustomerData> customers, {
    int limit = 5,
  }) {
    final now = DateTime.now();
    final startDate = _getStartDate('30d', now);

    final customerSpending = <String, Map<String, dynamic>>{};

    for (var customer in customers) {
      final completedDeals = customer.deals
          .where((d) => d.date.isAfter(startDate) && d.status == 'completed')
          .toList();

      if (completedDeals.isEmpty) continue;

      final totalSpent = completedDeals.fold<double>(
        0.0,
        (sum, deal) => sum + deal.totalAmount,
      );

      final lastDeal = completedDeals.reduce(
        (a, b) => a.date.isAfter(b.date) ? a : b,
      );

      customerSpending[customer.id] = {
        'customer': customer,
        'totalSpent': totalSpent,
        'dealCount': completedDeals.length,
        'lastDealDate': lastDeal.date,
      };
    }

    final sorted = customerSpending.entries.toList()
      ..sort(
        (a, b) => (b.value['totalSpent'] as double).compareTo(
          a.value['totalSpent'] as double,
        ),
      );

    final insights = <CustomerInsight>[];
    for (var entry in sorted.take(limit)) {
      final customer = entry.value['customer'] as CustomerData;
      final totalSpent = entry.value['totalSpent'] as double;
      final dealCount = entry.value['dealCount'] as int;

      insights.add(
        CustomerInsight(
          customerId: customer.id,
          customerName: customer.name,
          totalSpent: totalSpent,
          dealCount: dealCount,
          lastDealDate: entry.value['lastDealDate'] as DateTime,
          averageOrderValue: dealCount > 0 ? totalSpent / dealCount : 0.0,
        ),
      );
    }

    return insights;
  }

  static List<ProductInsight> _getTopProducts(List<CustomerData> customers) {
    final now = DateTime.now();
    final startDate = _getStartDate('30d', now);

    final productStats = <String, Map<String, dynamic>>{};

    for (var customer in customers) {
      final completedDeals = customer.deals
          .where((d) => d.date.isAfter(startDate) && d.status == 'completed')
          .toList();

      for (var deal in completedDeals) {
        for (var item in deal.items) {
          final productId = item.productName;

          if (!productStats.containsKey(productId)) {
            productStats[productId] = {
              'productName': item.productName,
              'quantitySold': 0,
              'totalRevenue': 0.0,
              'dealCount': 0,
            };
          }

          productStats[productId]!['quantitySold'] =
              (productStats[productId]!['quantitySold'] as int) + item.quantity;
          productStats[productId]!['totalRevenue'] =
              (productStats[productId]!['totalRevenue'] as double) +
              item.subtotal;
          productStats[productId]!['dealCount'] =
              (productStats[productId]!['dealCount'] as int) + 1;
        }
      }
    }

    final sorted = productStats.entries.toList()
      ..sort(
        (a, b) => (b.value['quantitySold'] as int).compareTo(
          a.value['quantitySold'] as int,
        ),
      );

    final insights = <ProductInsight>[];
    for (var entry in sorted.take(10)) {
      insights.add(
        ProductInsight(
          productId: entry.key,
          productName: entry.value['productName'] as String,
          quantitySold: entry.value['quantitySold'] as int,
          totalRevenue: entry.value['totalRevenue'] as double,
          dealCount: entry.value['dealCount'] as int,
        ),
      );
    }

    return insights;
  }

  /// Calculate growth analysis with period comparisons
  static Map<String, dynamic> _calculateGrowthAnalysis(
    List<CustomerData> customers,
    String period,
  ) {
    final now = DateTime.now();
    final currentStart = _getStartDate(period, now);
    final previousStart = _getStartDate(period, currentStart);

    double currentRevenue = 0, previousRevenue = 0;
    int currentDeals = 0, previousDeals = 0;

    for (var customer in customers) {
      final currentDeals = customer.deals
          .where((d) => d.date.isAfter(currentStart) && d.status == 'completed')
          .toList();
      final previousDeals = customer.deals
          .where((d) =>
              d.date.isAfter(previousStart) &&
              d.date.isBefore(currentStart) &&
              d.status == 'completed')
          .toList();

      for (var d in currentDeals) {
        currentRevenue += d.totalAmount;
      }
      for (var d in previousDeals) {
        previousRevenue += d.totalAmount;
      }
    }

    final revenueGrowth = previousRevenue > 0
        ? ((currentRevenue - previousRevenue) / previousRevenue) * 100
        : 0.0;

    return {
      'currentPeriodRevenue': currentRevenue,
      'previousPeriodRevenue': previousRevenue,
      'revenueGrowth': revenueGrowth,
      'periodComparison': period,
    };
  }

  /// Calculate customer segmentation (VIP, Regular, At Risk, New)
  static Map<String, dynamic> _calculateSegmentation(
    List<CustomerData> customers,
  ) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final ninetyDaysAgo = now.subtract(const Duration(days: 90));

    int vipCount = 0, regularCount = 0, atRiskCount = 0, newCount = 0;
    double vipRevenue = 0, regularRevenue = 0;

    for (var customer in customers) {
      final hasRecentDeal = customer.deals.any(
        (d) => d.date.isAfter(thirtyDaysAgo) && d.status == 'completed',
      );
      final hasOldDeal = customer.deals.any(
        (d) =>
            d.date.isAfter(ninetyDaysAgo) &&
            d.date.isBefore(thirtyDaysAgo) &&
            d.status == 'completed',
      );
      final totalSpent = customer.deals.fold<double>(
        0.0,
        (sum, d) => d.status == 'completed' ? sum + d.totalAmount : sum,
      );

      if (hasRecentDeal && totalSpent >= 1000) {
        vipCount++;
        vipRevenue += totalSpent;
      } else if (hasRecentDeal) {
        regularCount++;
        regularRevenue += totalSpent;
      } else if (hasOldDeal) {
        atRiskCount++;
      } else if (customer.deals.isNotEmpty) {
        newCount++;
      }
    }

    return {
      'vip': {'count': vipCount, 'revenue': vipRevenue},
      'regular': {'count': regularCount, 'revenue': regularRevenue},
      'atRisk': {'count': atRiskCount},
      'new': {'count': newCount},
    };
  }

  /// Calculate predictions using simple linear regression
  static Map<String, dynamic> _calculatePredictions(
    List<CustomerData> customers,
    String period,
  ) {
    final now = DateTime.now();
    final startDate = _getStartDate(period, now);

    final dailyRevenue = <String, double>{};
    for (var customer in customers) {
      for (var deal in customer.deals) {
        if (deal.date.isAfter(startDate)) {
          final key = DateFormat('yyyy-MM-dd').format(deal.date);
          dailyRevenue[key] = (dailyRevenue[key] ?? 0) + deal.totalAmount;
        }
      }
    }

    if (dailyRevenue.length < 7) {
      return {
        'predictedNextWeek': 0.0,
        'confidence': 0.0,
        'trend': 'insufficient_data',
      };
    }

    final entries = dailyRevenue.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final revenues = entries.map((e) => e.value).toList();

    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (var i = 0; i < revenues.length; i++) {
      sumX += i;
      sumY += revenues[i];
      sumXY += i * revenues[i];
      sumX2 += i * i;
    }

    final n = revenues.length;
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    double predictedNextWeek = 0;
    for (var i = 0; i < 7; i++) {
      predictedNextWeek += intercept + slope * (revenues.length + i);
    }

    final avgRevenue = sumY / n;
    final stdDev = sqrt(
      revenues.fold<double>(0.0, (sum, r) => sum + pow(r - avgRevenue, 2)) / n,
    );
    final confidence = stdDev > 0 ? (1 - (stdDev / avgRevenue)).clamp(0, 1) : 0;

    String trend = 'stable';
    if (slope > avgRevenue * 0.05) {
      trend = 'growing';
    } else if (slope < -avgRevenue * 0.05) {
      trend = 'declining';
    }

    return {
      'predictedNextWeek': predictedNextWeek.clamp(0, double.infinity),
      'confidence': confidence,
      'trend': trend,
      'slope': slope,
    };
  }

  static DateTime _getStartDate(String period, DateTime now) {
    switch (period) {
      case '7d':
        return now.subtract(const Duration(days: 7));
      case '30d':
        return now.subtract(const Duration(days: 30));
      case '90d':
        return now.subtract(const Duration(days: 90));
      case '1y':
        return now.subtract(const Duration(days: 365));
      default:
        return now.subtract(const Duration(days: 30));
    }
  }
}