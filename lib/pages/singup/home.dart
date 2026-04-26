import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/models/customer.dart';
import 'package:aurora/models/sale.dart';
import 'package:aurora/models/aurora_product.dart';
import 'package:aurora/pages/analytics/analytics_page.dart';
import 'package:aurora/pages/customers/customers_page.dart';
import 'package:aurora/pages/customers/customer_details_screen.dart';
import 'package:aurora/pages/product/product.dart';
import 'package:aurora/pages/sales/record_sale_screen.dart';
import 'package:aurora/pages/sales/sales_page.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Seller Home Page - Dashboard with stats, activity, and quick actions
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isLoading = true;
  String? _errorMessage;

  // Seller info
  String _sellerFirstName = '';

  // Stats data from database
  double _totalRevenue = 0;
  int _totalOrders = 0;
  int _totalCustomers = 0;
  double _todayRevenue = 0;
  int _pendingOrdersCount = 0;
  Map<String, dynamic> _kpis = {};

  // Recent activity
  List<ActivityItem> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final userId = supabaseProvider.currentUser!.id;
      final sellerDb = supabaseProvider.sellerDb;
      debugPrint('Loading seller data for user: $userId');

      // Kick off all data fetches in parallel to reduce dashboard load time
      final sellerFuture =
          sellerDb != null ? sellerDb.getSellerByUserId(userId) : Future.value();
      final kpisFuture = supabaseProvider.getSellerKPIs(period: '30d');
      final ordersFuture = _getSellerOrders(supabaseProvider);
      final recentSalesFuture = supabaseProvider.getSales(
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        limit: 10,
      );
      final customersFuture = supabaseProvider.getCustomers();
      final productsFuture = supabaseProvider.getAllProducts();

      final results = await Future.wait([
        sellerFuture,
        kpisFuture,
        ordersFuture,
        recentSalesFuture,
        customersFuture,
        productsFuture,
      ]);

      final localSeller = results[0] as Map<String, dynamic>?;
      final kpis = results[1] as Map<String, dynamic>;
      final ordersData = results[2] as Map<String, int>;
      final recentSales = results[3] as List<Sale>;
      final customers = results[4] as List;
      final products = results[5] as List<AuroraProduct>;

      // Resolve display name
      if (localSeller != null) {
        _sellerFirstName = localSeller['firstname'] as String? ?? '';
      } else {
        final supabaseSeller = await supabaseProvider.getCurrentSellerProfile();
        if (supabaseSeller != null) {
          final fullName = supabaseSeller['full_name'] as String? ?? '';
          final nameParts = fullName.split(' ');
          _sellerFirstName = nameParts.isNotEmpty ? nameParts[0] : 'Seller';
        }
      }
      debugPrint('Final display name: "$_sellerFirstName"');

      // Build enhanced activity list using already-fetched data
      final activities = _buildEnhancedActivity(
        recentSales: recentSales,
        products: products,
      );

      if (!mounted) return;
      setState(() {
        _kpis = kpis;
        _totalRevenue = kpis['total_revenue'] ?? 0;
        _totalOrders = ordersData['total_orders'] ?? 0;
        _pendingOrdersCount = ordersData['pending_orders'] ?? 0;
        _totalCustomers = customers.length;
        _todayRevenue = _calculateTodayRevenue(recentSales);
        _recentActivities = activities.isNotEmpty
            ? activities
            : _buildActivityFromSales(recentSales);

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load dashboard data: $e';
        _isLoading = false;
      });
    }
  }

  /// Fetch seller orders from Supabase
  Future<Map<String, int>> _getSellerOrders(
    SupabaseProvider supabaseProvider,
  ) async {
    try {
      final userId = supabaseProvider.currentUser!.id;
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));

      final response = await supabaseProvider.client
          .from('orders')
          .select('status, created_at')
          .eq('seller_id', userId)
          .gte('created_at', startDate.toIso8601String());

      final orders = response as List;
      int totalOrders = orders.length;
      int pendingOrders = orders.where((o) => o['status'] == 'pending').length;

      return {'total_orders': totalOrders, 'pending_orders': pendingOrders};
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      return {'total_orders': 0, 'pending_orders': 0};
    }
  }

  double _calculateTodayRevenue(List<Sale> sales) {
    final now = DateTime.now();
    return sales
        .where(
          (sale) =>
              sale.saleDate.year == now.year &&
              sale.saleDate.month == now.month &&
              sale.saleDate.day == now.day,
        )
        .fold(0.0, (sum, sale) => sum + sale.netTotal);
  }

  List<ActivityItem> _buildActivityFromSales(List<Sale> sales) {
    return sales.take(5).map((sale) {
      return ActivityItem(
        id: sale.id ?? '',
        title: 'Sale',
        subtitle:
            '${sale.customer?.name ?? 'Customer'} - ${NumberFormat.currency(symbol: '\$').format(sale.netTotal)}',
        icon: Icons.check_circle,
        time: sale.relativeTime,
        color: Colors.green,
      );
    }).toList();
  }

  /// Build enhanced activity list from already-fetched data
  List<ActivityItem> _buildEnhancedActivity({
    required List<Sale> recentSales,
    required List<AuroraProduct> products,
  }) {
    final activities = <ActivityItem>[];

    // Add recent sales
    for (final sale in recentSales.take(3)) {
activities.add(
        ActivityItem(
          id: 'sale_${sale.id}',
          title: 'Sale',
          subtitle:
              '${sale.customer?.name ?? 'Customer'} - ${NumberFormat.currency(symbol: '\$').format(sale.netTotal)}',
          icon: Icons.check_circle,
          time: sale.relativeTime,
          color: Colors.green,
        ),
      );
    }

    // Flag low stock items
    final lowStockProducts = products
        .where((p) => p.quantity != null && p.quantity! < 5)
        .take(2);

    for (final product in lowStockProducts) {
      activities.add(
        ActivityItem(
          id: 'stock_${product.asin}',
          title: 'Low Stock Alert',
          subtitle: 'Only ${product.quantity} left',
          icon: Icons.warning_amber,
          time: 'Recently',
          color: Colors.red,
        ),
      );
    }

    return activities.take(5).toList();
  }

  final currencyFormat = NumberFormat.currency(symbol: '\$');

@override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.app_title),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1E2C),
                      const Color(0xFF2D2D44),
                    ]
                  : [
                      const Color(0xFF667EEA),
                      const Color(0xFF764BA2),
                    ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(currentPage: 'home'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorView()
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  // Welcome Section
                  SliverToBoxAdapter(
                    child: _buildWelcomeSection(context),
                  ),

                  // Quick Stats
                  SliverToBoxAdapter(child: _buildQuickStatsSection(context)),

                  // Quick Actions
                  SliverToBoxAdapter(child: _buildQuickActionsSection(context)),

                  // Recent Activity
                  SliverToBoxAdapter(child: _buildRecentActivitySection(context)),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickDealDialog(context),
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label: const Text('New Deal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildErrorView() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(_errorMessage!),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    String greeting;
    IconData greetingIcon;

    if (now.hour < 12) {
      greeting = l10n.good_morning;
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (now.hour < 17) {
      greeting = l10n.good_afternoon;
      greetingIcon = Icons.wb_sunny;
    } else {
      greeting = l10n.good_evening;
      greetingIcon = Icons.nights_stay_outlined;
    }

    // Get seller name
    final displayName = _sellerFirstName;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.store, color: Color(0xFF667EEA), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                Text(
                  'Hello, $displayName!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = _kpis['period_days'] ?? 30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.quick_stats,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnalyticsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.trending_up, size: 18),
                label: Text(l10n.last_days(days)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: l10n.total_revenue,
                  value: currencyFormat.format(_totalRevenue),
                  subtitle: l10n.last_days(days),
                  icon: Icons.attach_money,
                  gradientColors: [
                    const Color(0xFF667EEA),
                    const Color(0xFF764BA2),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: l10n.orders,
                  value: _totalOrders.toString(),
                  subtitle: _pendingOrdersCount > 0
                      ? l10n.pending_count(_pendingOrdersCount)
                      : l10n.transactions,
                  icon: Icons.shopping_bag,
                  gradientColors: [
                    const Color(0xFF50FA7B),
                    const Color(0xFF28B83B),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: l10n.customers,
                  value: _totalCustomers.toString(),
                  subtitle:
                      '${_kpis['unique_customers_in_period'] ?? 0} ${l10n.active_customers}',
                  icon: Icons.people,
                  gradientColors: [
                    Colors.orange.shade400,
                    Colors.orange.shade700,
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: l10n.today,
                  value: currencyFormat.format(_todayRevenue),
                  subtitle: 'Daily revenue',
                  icon: Icons.today,
                  gradientColors: [
                    Colors.purple.shade400,
                    Colors.purple.shade700,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildQuickActionCard(
                title: 'Add Product',
                icon: Icons.add_box,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPage(),
                    ),
                  );
                },
              ),
              _buildQuickActionCard(
                title: 'Record Sale',
                icon: Icons.point_of_sale,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordSaleScreen(),
                    ),
                  );
                },
              ),
              _buildQuickActionCard(
                title: 'View Customers',
                icon: Icons.people,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomersPage(),
                    ),
                  );
                },
              ),
              _buildQuickActionCard(
                title: 'Sales Report',
                icon: Icons.analytics,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SalesPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SalesPage()),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_recentActivities.isEmpty)
            _buildEmptyActivity()
          else
            ..._recentActivities.map(
              (activity) => _buildActivityItem(activity),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No recent activity',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Record a sale to see activity here',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, color: activity.color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

/// Activity Item Model
class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
  final Color color;

  ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    required this.color,
  });
}

void _showQuickDealDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const QuickDealDialog(),
  ).then((result) {
    if (result == true) {
      // Reload data by calling the parent page's loadData through a callback
      final homepageState = context.findAncestorStateOfType<_HomepageState>();
      homepageState?._loadData();
    }
  });
}

class QuickDealDialog extends StatefulWidget {
  const QuickDealDialog({super.key});

  @override
  State<QuickDealDialog> createState() => _QuickDealDialogState();
}

class _QuickDealDialogState extends State<QuickDealDialog> {
  List<Customer> _customers = [];
  List<AuroraProduct> _products = [];
  Customer? _selectedCustomer;
  AuroraProduct? _selectedProduct;
  final _quantityController = TextEditingController(text: '1');
  final _discountController = TextEditingController(text: '0');
  String _paymentMethod = 'cash';
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showNewCustomer = false;
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _discountController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final customers = await supabaseProvider.getCustomers();
      final result = await supabaseProvider.getAllProductsWithEdgeFunction(limit: 100, offset: 0);
      List<AuroraProduct> products = [];
      if (result.success && result.data != null) {
        products = result.data!;
      }
      setState(() {
        _customers = customers;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  double get _totalAmount {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final price = _selectedProduct?.price ?? 0.0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    return (quantity * price) - discount;
  }

  Future<void> _createCustomer() async {
    if (_newNameController.text.trim().isEmpty || _newPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and phone are required'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final result = await supabaseProvider.addCustomer(
        name: _newNameController.text.trim(),
        phone: _newPhoneController.text.trim().replaceAll(RegExp(r'\D'), ''),
      );

      if (result.success) {
        final customers = await supabaseProvider.getCustomers();
        if (customers.isNotEmpty) {
          setState(() {
            _selectedCustomer = customers.last;
            _customers = customers;
            _showNewCustomer = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _saveSale() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final price = _selectedProduct?.price ?? 0.0;
      final discount = double.tryParse(_discountController.text) ?? 0;

      final result = await supabaseProvider.recordSale(
        customerId: _selectedCustomer?.id,
        productId: _selectedProduct?.asin,
        quantity: quantity,
        unitPrice: price,
        discount: discount,
        paymentMethod: _paymentMethod,
      );

      if (result.success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Sale recorded: \$${_totalAmount.toStringAsFixed(2)}'),
            ]),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 650),
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: const Color(0xFF667EEA)))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quick Deal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_showNewCustomer) ...[
                    TextField(
                      controller: _newNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Customer Name *',
                        labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newPhoneController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Phone *',
                        labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _showNewCustomer = false),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _createCustomer,
                          child: _isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Add Customer'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    DropdownButtonFormField<Customer>(
                      value: _selectedCustomer,
                      dropdownColor: isDark ? const Color(0xFF2D2D44) : Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Customer *',
                        labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _customers.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedCustomer = v),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _showNewCustomer = true),
                      child: const Text('+ Add New Customer'),
                    ),
                    const SizedBox(height: 12),
                  ],

                  DropdownButtonFormField<AuroraProduct>(
                    value: _selectedProduct,
                    dropdownColor: isDark ? const Color(0xFF2D2D44) : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Product *',
                      labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                      prefixIcon: const Icon(Icons.inventory),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _products.map((p) => DropdownMenuItem(
                      value: p,
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          p.title ?? p.asin ?? 'Product',
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedProduct = v),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Discount',
                            labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildPaymentChip('cash', 'Cash', Icons.money),
                      _buildPaymentChip('card', 'Card', Icons.credit_card),
                      _buildPaymentChip('transfer', 'Transfer', Icons.account_balance),
                      _buildPaymentChip('digital', 'Digital', Icons.phone_android),
                    ],
                  ),
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '\$${_totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isSaving || _selectedProduct == null) ? null : _saveSale,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Complete Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPaymentChip(String value, String label, IconData icon) {
    final isSelected = _paymentMethod == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54)),
        const SizedBox(width: 4),
        Text(label),
      ]),
      selected: isSelected,
      selectedColor: const Color(0xFF667EEA),
      onSelected: (v) => setState(() => _paymentMethod = value),
    );
  }
}
