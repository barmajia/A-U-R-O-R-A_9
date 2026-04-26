import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/models/customer.dart';
import 'package:aurora/models/seller_analytics_data.dart';
import 'package:aurora/pages/customers/customer_details_screen.dart';
import 'package:aurora/services/seller_analytics_service.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Main Seller Analytics Page with Grid and Table views
class SellerAnalyticsPage extends StatefulWidget {
  const SellerAnalyticsPage({super.key});

  @override
  State<SellerAnalyticsPage> createState() => _SellerAnalyticsPageState();
}

class _SellerAnalyticsPageState extends State<SellerAnalyticsPage> {
  List<CustomerData> _customers = [];
  SellerAnalyticsData? _analyticsData;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isGridView = true; // Toggle between grid and table view
  String _selectedPeriod = '30d';
  bool _isAutoRefreshScheduled = false;

  @override
  void initState() {
    super.initState();
    _loadSellerData();
    _scheduleAutoRefresh();
  }

  void _scheduleAutoRefresh() {
    // Auto-refresh every 30 seconds when data changes occur
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadSellerData();
        _scheduleAutoRefresh();
      }
    });
  }

  Future<void> _loadSellerData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analyticsService = SellerAnalyticsService(
        supabaseProvider,
        sellerDb: supabaseProvider.sellerDb,
      );

      final analyticsData = await analyticsService.collectSellerData(
        period: _selectedPeriod,
      );

      setState(() {
        _analyticsData = analyticsData;
        _customers = analyticsData.customers;
        _isLoading = false;
      });

      // Automatically trigger analysis update
      _updateAnalysisFile();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load seller data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAnalysisFile() async {
    if (_analyticsData == null) return;

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analyticsService = SellerAnalyticsService(supabaseProvider);

      // Save updated analytics to file (UUID folder structure)
      await analyticsService.saveToFile(_analyticsData!);
      
      debugPrint('Analysis file auto-updated: ${_analyticsData!.filename}');
    } catch (e) {
      debugPrint('Failed to auto-update analysis file: $e');
    }
  }

  List<CustomerData> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    
    final query = _searchQuery.toLowerCase();
    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      drawer: const AppDrawer(currentPage: 'seller_analytics'),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _errorMessage != null
              ? _buildErrorState(colorScheme)
              : Column(
                  children: [
                    _buildSearchAndFilterBar(colorScheme),
                    _buildViewToggle(colorScheme),
                    Expanded(child: _buildCustomerContent(colorScheme)),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadSellerData,
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text('Refresh', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      title: const Text('Seller Analytics'),
      centerTitle: true,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: _openDataFolder,
          tooltip: 'Open Data Folder',
        ),
        IconButton(
          icon: const Icon(Icons.cloud_upload),
          onPressed: _uploadToCloud,
          tooltip: 'Upload to Cloud',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search customers...',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: colorScheme.onSurface),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: colorScheme.onSurface),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 12),
          // Period Selector
          _buildPeriodSelector(colorScheme),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: ['7d', '30d', '90d', '1y'].map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriod = period);
                _loadSellerData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    period,
                    style: TextStyle(
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewToggle(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('View:', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(width: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, icon: Icon(Icons.grid_on), label: Text('Grid')),
              ButtonSegment(value: false, icon: Icon(Icons.table_rows), label: Text('Table')),
            ],
            selected: {_isGridView},
            onSelectionChanged: (Set<bool> selected) {
              setState(() => _isGridView = selected.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerContent(ColorScheme colorScheme) {
    final filteredCustomers = _filteredCustomers;

    if (filteredCustomers.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return _isGridView
        ? _buildGridView(colorScheme, filteredCustomers)
        : _buildTableView(colorScheme, filteredCustomers);
  }

  Widget _buildGridView(ColorScheme colorScheme, List<CustomerData> customers) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildGridTile(customer, colorScheme);
      },
    );
  }

  Widget _buildGridTile(CustomerData customer, ColorScheme colorScheme) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      elevation: 3,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => _navigateToCustomerDetails(customer),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      customer.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Phone
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: colorScheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      customer.phone,
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(customer.status, colorScheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customer.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(customer.status, colorScheme),
                  ),
                ),
              ),
              const Spacer(),
              
              // Stats
              Divider(color: colorScheme.outlineVariant),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${customer.totalOrders}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Orders',
                        style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(customer.totalSpent),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Spent',
                        style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableView(ColorScheme colorScheme, List<CustomerData> customers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
          columns: const [
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Orders'), numeric: true),
            DataColumn(label: Text('Total Spent'), numeric: true),
            DataColumn(label: Text('Last Order')),
            DataColumn(label: Text('Actions')),
          ],
          rows: customers.map((customer) {
            return DataRow(
              cells: [
                DataCell(_buildCustomerCell(customer, colorScheme)),
                DataCell(Text(customer.phone)),
                DataCell(_buildStatusChip(customer.status, colorScheme)),
                DataCell(Text('${customer.totalOrders}')),
                DataCell(Text(NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(customer.totalSpent))),
                DataCell(Text(customer.lastOrderDate != null 
                    ? DateFormat('MMM d, yyyy').format(customer.lastOrderDate!) 
                    : 'N/A')),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 20),
                    onPressed: () => _navigateToCustomerDetails(customer),
                    tooltip: 'View Details',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCustomerCell(CustomerData customer, ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primary,
          child: Text(
            customer.initials,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          customer.name,
          style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, ColorScheme colorScheme) {
    final color = _getStatusColor(status, colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'vip':
        return Colors.purple;
      default:
        return colorScheme.primary;
    }
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: TextStyle(fontSize: 18, color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.5)),
            ),
          ],
        ],
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
            Icon(Icons.error_outline, size: 64, color: colorScheme.error.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSellerData,
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

  void _navigateToCustomerDetails(CustomerData customer) {
    // Convert CustomerData to Customer model for navigation
    // sellerId is obtained from the current user's id
    final sellerId = _analyticsData?.sellerId ?? '';
    final customerModel = Customer(
      id: customer.id,
      sellerId: sellerId,
      name: customer.name,
      phone: customer.phone,
      email: customer.email,
      totalOrders: customer.totalOrders,
      totalSpent: customer.totalSpent,
      createdAt: customer.createdAt,
      ageRange: null,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(customer: customerModel),
      ),
    ).then((result) {
      if (result == true) _loadSellerData();
    });
  }

  void _openDataFolder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening data folder... (Implementation pending)')),
    );
  }

  Future<void> _uploadToCloud() async {
    if (_analyticsData == null) return;

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analyticsService = SellerAnalyticsService(
        supabaseProvider,
        sellerDb: supabaseProvider.sellerDb,
      );

      await analyticsService.uploadToSupabase(_analyticsData!, bucketName: 'seller');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
