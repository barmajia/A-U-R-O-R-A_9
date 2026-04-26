import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/services/seller_analytics_service.dart';
import 'package:aurora/services/analysis_engine.dart';
import 'package:aurora/models/seller_analytics_data.dart';
import 'package:aurora/models/offline/offline_analysis.dart';
import 'package:aurora/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, dynamic> _kpis = {};
  SellerAnalyticsData? _analyticsData;
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedPeriod = '30d';
  bool _isUploading = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadKPIs();
  }

  Future<void> _loadKPIs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      
      // Load basic KPIs
      final kpis = await supabaseProvider.getSellerKPIs(
        period: _selectedPeriod,
      );

      // Load full analytics data using new service with local DB access
      final analyticsService = SellerAnalyticsService(
        supabaseProvider,
        sellerDb: supabaseProvider.sellerDb,
      );
      final analyticsData = await analyticsService.collectSellerData(
        period: _selectedPeriod,
      );

      setState(() {
        _kpis = kpis;
        _analyticsData = analyticsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load analytics: $e';
        _isLoading = false;
      });
    }
  }

  /// Upload seller data JSON to Supabase bucket
  Future<void> _uploadToSupabase() async {
    if (_analyticsData == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analyticsService = SellerAnalyticsService(supabaseProvider);

      await analyticsService.uploadToSupabase(_analyticsData!, bucketName: 'seller');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data uploaded successfully to ${_analyticsData!.filename}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// Download seller data from Supabase
  Future<void> _downloadFromSupabase() async {
    final supabaseProvider = context.read<SupabaseProvider>();
    final sellerId = supabaseProvider.currentUser?.id;
    
    if (sellerId == null) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final analyticsService = SellerAnalyticsService(supabaseProvider);
      final data = await analyticsService.downloadFromSupabase(sellerId, bucketName: 'seller');

      if (data != null && mounted) {
        setState(() {
          _analyticsData = data;
          _kpis = data.kpis.toJson();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data downloaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data found in storage'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  /// Save to local file
  Future<void> _saveToLocalFile() async {
    if (_analyticsData == null) return;

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analyticsService = SellerAnalyticsService(supabaseProvider);

      final file = await analyticsService.saveToFile(_analyticsData!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to: ${file.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(currentPage: 'analytics'),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _errorMessage != null
          ? _buildErrorState(colorScheme)
          : RefreshIndicator(
              onRefresh: _loadKPIs,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPeriodSelector(colorScheme),
                  const SizedBox(height: 24),
                  _buildKPICards(colorScheme),
                  const SizedBox(height: 24),
                  _buildRevenueChart(colorScheme),
                  const SizedBox(height: 24),
                  _buildCustomerSpendingChart(colorScheme),
                  const SizedBox(height: 24),
                  _buildTopCustomersCard(colorScheme),
                  const SizedBox(height: 24),
                  _buildInsightsCard(colorScheme),
                  const SizedBox(height: 24),
                  _buildDeepInsightsCard(colorScheme, isDark),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        'Analytics',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      actions: [
        IconButton(
          icon: _isDownloading 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
              : const Icon(Icons.cloud_download_outlined),
          onPressed: _isDownloading ? null : _downloadFromSupabase,
          tooltip: 'Download from Cloud',
        ),
        IconButton(
          icon: _isUploading 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
              : const Icon(Icons.cloud_upload_outlined),
          onPressed: _isUploading ? null : _uploadToSupabase,
          tooltip: 'Upload to Cloud',
        ),
        IconButton(
          icon: const Icon(Icons.save_alt_outlined),
          onPressed: _analyticsData != null ? _saveToLocalFile : null,
          tooltip: 'Save to Device',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadKPIs,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(ColorScheme colorScheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildPeriodChip('7d'),
          _buildPeriodChip('30d'),
          _buildPeriodChip('90d'),
          _buildPeriodChip('1y'),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final isSelected = _selectedPeriod == period;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPeriod = period);
          _loadKPIs();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              period,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[700]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKPICards(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                title: 'Revenue',
                value: '\$${(_kpis['total_revenue'] ?? 0).toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: Colors.green,
                subtitle: _getPeriodSubtitle(),
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKPICard(
                title: 'Sales',
                value: '${_kpis['total_sales'] ?? 0}',
                icon: Icons.shopping_cart,
                color: Colors.blue,
                subtitle: 'transactions',
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                title: 'Items Sold',
                value: '${_kpis['total_items_sold'] ?? 0}',
                icon: Icons.inventory_2,
                color: Colors.orange,
                subtitle: 'products',
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKPICard(
                title: 'Avg Order',
                value:
                    '\$${(_kpis['average_order_value'] ?? 0).toStringAsFixed(1)}',
                icon: Icons.receipt_long,
                color: Colors.purple,
                subtitle: 'per sale',
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                title: 'Customers',
                value: '${_kpis['total_customers'] ?? 0}',
                icon: Icons.people,
                color: Colors.teal,
                subtitle: 'total',
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKPICard(
                title: 'Active',
                value: '${_kpis['unique_customers_in_period'] ?? 0}',
                icon: Icons.people_outline,
                color: Colors.pink,
                subtitle: 'this period',
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodSubtitle() {
    final days = _kpis['period_days'] ?? 30;
    return 'last $days days';
  }

  Widget _buildRevenueChart(ColorScheme colorScheme) {
    if (_analyticsData?.sales.isEmpty ?? true) {
      return _buildEmptyChart('Revenue Trend', 'No sales data', colorScheme);
    }

    final sales = _analyticsData!.sales;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final dailyRevenue = <String, double>{};
    for (var sale in sales) {
      if (sale.saleDate.isAfter(thirtyDaysAgo)) {
        final key = DateFormat('MM/dd').format(sale.saleDate);
        dailyRevenue[key] = (dailyRevenue[key] ?? 0) + sale.netTotal;
      }
    }

    if (dailyRevenue.isEmpty) {
      return _buildEmptyChart('Revenue Trend', 'No recent sales', colorScheme);
    }

    final entries = dailyRevenue.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Revenue Trend (30 Days)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) => Text(
                          '\$${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: entries.length > 7 ? (entries.length / 5).ceil().toDouble() : 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < entries.length) {
                            return Text(
                              entries[idx].key,
                              style: TextStyle(fontSize: 9, color: colorScheme.onSurface.withOpacity(0.5)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: entries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSpendingChart(ColorScheme colorScheme) {
    if (_analyticsData?.customers.isEmpty ?? true) {
      return _buildEmptyChart('Customer Spending', 'No customer data', colorScheme);
    }

    final customers = _analyticsData!.customers;
    customers.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    final top5 = customers.take(5).toList();

    if (top5.isEmpty) {
      return _buildEmptyChart('Customer Spending', 'No spending data', colorScheme);
    }

    final colors = [Colors.amber, Colors.blue, Colors.purple, Colors.orange, Colors.teal];

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Top 5 Customers by Spending',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: top5.first.totalSpent * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(0)}',
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) => Text(
                          '\$${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < top5.length) {
                            final name = top5[idx].name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                name.length > 10 ? '${name.substring(0, 10)}...' : name,
                                style: TextStyle(fontSize: 9, color: colorScheme.onSurface.withOpacity(0.6)),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  barGroups: top5.asMap().entries.map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.totalSpent,
                        color: colors[e.key % colors.length],
                        width: 24,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChart(String title, String message, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepInsightsCard(ColorScheme colorScheme, bool isDark) {
    final insights = <Map<String, dynamic>>[];

    if (_analyticsData != null) {
      final kpis = _analyticsData!.kpis;
      final sales = _analyticsData!.sales;
      final customers = _analyticsData!.customers;

      if (sales.isNotEmpty) {
        double totalRevenue = 0, maxSale = 0, minSale = double.infinity;
        for (var s in sales) {
          totalRevenue += s.netTotal;
          if (s.netTotal > maxSale) maxSale = s.netTotal;
          if (s.netTotal < minSale) minSale = s.netTotal;
        }
        insights.add({
          'icon': Icons.attach_money,
          'title': 'Total Revenue',
          'value': '\$${totalRevenue.toStringAsFixed(2)}',
          'color': Colors.green,
        });
        insights.add({
          'icon': Icons.arrow_upward,
          'title': 'Highest Sale',
          'value': '\$${maxSale.toStringAsFixed(2)}',
          'color': Colors.amber,
        });
        if (minSale != double.infinity) {
          insights.add({
            'icon': Icons.arrow_downward,
            'title': 'Lowest Sale',
            'value': '\$${minSale.toStringAsFixed(2)}',
            'color': Colors.red,
          });
        }
      }

      if (customers.isNotEmpty) {
        int active = 0, atRisk = 0, churned = 0;
        for (var c in customers) {
          switch (c.customerStatus) {
            case 'Active':
              active++;
              break;
            case 'At Risk':
              atRisk++;
              break;
            case 'Churned':
              churned++;
              break;
          }
        }
        insights.add({
          'icon': Icons.check_circle,
          'title': 'Active Customers',
          'value': '$active',
          'color': Colors.green,
        });
        if (atRisk > 0) {
          insights.add({
            'icon': Icons.warning,
            'title': 'At Risk',
            'value': '$atRisk',
            'color': Colors.orange,
          });
        }
        if (churned > 0) {
          insights.add({
            'icon': Icons.cancel,
            'title': 'Churned',
            'value': '$churned',
            'color': Colors.red,
          });
        }
      }

      final avgOrder = kpis.averageOrderValue;
      final avgDaily = kpis.averageDailyRevenue;
      if (avgOrder > 0) {
        insights.add({
          'icon': Icons.receipt,
          'title': 'Avg Order Value',
          'value': '\$${avgOrder.toStringAsFixed(2)}',
          'color': Colors.blue,
        });
      }
      if (avgDaily > 0) {
        insights.add({
          'icon': Icons.today,
          'title': 'Avg Daily Revenue',
          'value': '\$${avgDaily.toStringAsFixed(2)}',
          'color': Colors.purple,
        });
      }
    }

    if (insights.isEmpty) {
      insights.add({
        'icon': Icons.info_outline,
        'title': 'No Insights Yet',
        'value': 'Start selling',
        'color': Colors.grey,
      });
    }

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Deep Insights',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: insights.map((insight) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (insight['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(insight['icon'] as IconData, color: insight['color'] as Color, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        insight['value'].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        insight['title'].toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCustomersCard(ColorScheme colorScheme) {
    final topCustomers = List<Map<String, dynamic>>.from(
      _kpis['top_customers'] ?? [],
    );

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Top Customers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (topCustomers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No customer data yet',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topCustomers.length,
                separatorBuilder: (context, index) =>
                    Divider(color: colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final customer = topCustomers[index];
                  final totalSpent =
                      double.tryParse(
                        customer['total_spent']?.toString() ?? '0',
                      ) ??
                      0;
                  return Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                              ? Colors.grey
                              : index == 2
                              ? Colors.brown
                              : colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: index < 3
                                  ? Colors.white
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer #${customer['id'].toString().substring(0, 8)}...',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${customer['total_orders'] ?? 0} orders',
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${totalSpent.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard(ColorScheme colorScheme) {
    final avgOrderValue = _kpis['average_order_value'] ?? 0;
    final totalCustomers = _kpis['total_customers'] ?? 0;
    final uniqueCustomers = _kpis['unique_customers_in_period'] ?? 0;

    final insights = <Map<String, dynamic>>[];

    // Add insights from basic KPIs
    if (avgOrderValue > 0) {
      insights.add({
        'icon': Icons.trending_up,
        'title': 'Average Order Value',
        'description': '\$${avgOrderValue.toStringAsFixed(2)} per transaction',
        'color': Colors.green,
      });
    }

    if (totalCustomers > 0) {
      final activePercentage = ((uniqueCustomers / totalCustomers) * 100)
          .toInt();
      insights.add({
        'icon': Icons.people,
        'title': 'Customer Activity',
        'description': '$activePercentage% of customers active this period',
        'color': Colors.blue,
      });
    }

    // Add advanced insights from analytics data
    if (_analyticsData != null) {
      final kpis = _analyticsData!.kpis;
      
      // Customer retention insight
      if (kpis.customerRetentionRate > 0) {
        insights.add({
          'icon': Icons.repeat,
          'title': 'Customer Retention',
          'description': '${kpis.customerRetentionRate.toStringAsFixed(1)}% retention rate',
          'color': Colors.purple,
        });
      }
      
      // Customer lifetime value
      if (kpis.customerLifetimeValue > 0) {
        insights.add({
          'icon': Icons.account_balance_wallet,
          'title': 'Customer Lifetime Value',
          'description': '\$${kpis.customerLifetimeValue.toStringAsFixed(2)} per customer',
          'color': Colors.teal,
        });
      }
      
      // Average daily revenue
      if (kpis.averageDailyRevenue > 0) {
        insights.add({
          'icon': Icons.calendar_today,
          'title': 'Daily Revenue',
          'description': '\$${kpis.averageDailyRevenue.toStringAsFixed(2)} average per day',
          'color': Colors.orange,
        });
      }

      // Active customers count
      if (kpis.activeCustomers > 0) {
        insights.add({
          'icon': Icons.people_alt,
          'title': 'Active Customers',
          'description': '${kpis.activeCustomers} active buyers',
          'color': Colors.pink,
        });
      }
    }

    if (insights.isEmpty) {
      insights.add({
        'icon': Icons.info,
        'title': 'No Insights Yet',
        'description': 'Start recording sales to see insights',
        'color': Colors.grey,
      });
    }

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Insights',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (insight['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        insight['icon'] as IconData,
                        color: insight['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            insight['description'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadKPIs,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
