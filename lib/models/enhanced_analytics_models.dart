import 'package:flutter/foundation.dart';

/// Data model for Chart Series used in visualizations
class ChartSeries {
  final String label;
  final double value;
  final DateTime? date;

  ChartSeries({required this.label, required this.value, this.date});
}

/// Aggregated KPI data for specific time periods
class PeriodKPIs {
  final double revenue;
  final int salesCount;
  final int newCustomers;
  final double averageOrderValue;

  PeriodKPIs({
    required this.revenue,
    required this.salesCount,
    required this.newCustomers,
    required this.averageOrderValue,
  });

  factory PeriodKPIs.empty() => PeriodKPIs(
        revenue: 0,
        salesCount: 0,
        newCustomers: 0,
        averageOrderValue: 0,
      );

  PeriodKPIs copyWith({
    double? revenue,
    int? salesCount,
    int? newCustomers,
    double? averageOrderValue,
  }) {
    return PeriodKPIs(
      revenue: revenue ?? this.revenue,
      salesCount: salesCount ?? this.salesCount,
      newCustomers: newCustomers ?? this.newCustomers,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
    );
  }
}

/// Enhanced Analytics Result containing time-series data and period breakdowns
class EnhancedAnalyticsResult {
  final Map<String, PeriodKPIs> periodBreakdown; // day, week, month, year
  final List<ChartSeries> revenueTrend;
  final List<ChartSeries> salesTrend;
  final Map<String, int> statusDistribution;
  final Map<String, double> categoryPerformance;

  EnhancedAnalyticsResult({
    required this.periodBreakdown,
    required this.revenueTrend,
    required this.salesTrend,
    required this.statusDistribution,
    required this.categoryPerformance,
  });

  factory EnhancedAnalyticsResult.empty() => EnhancedAnalyticsResult(
        periodBreakdown: {
          'day': PeriodKPIs.empty(),
          'week': PeriodKPIs.empty(),
          'month': PeriodKPIs.empty(),
          'year': PeriodKPIs.empty(),
        },
        revenueTrend: [],
        salesTrend: [],
        statusDistribution: {},
        categoryPerformance: {},
      );
}
