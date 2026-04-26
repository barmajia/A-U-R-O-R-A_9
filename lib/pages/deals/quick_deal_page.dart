import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/models/aurora_product.dart';
import 'package:aurora/models/customer.dart';
import 'package:aurora/models/offline/offline_database.dart';
import 'package:aurora/services/analysis_engine.dart';
import 'package:aurora/services/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

/// Quick Deal Page - Allows creating deals with existing or new customers
/// Features:
/// - Select from existing customers or add new one
/// - Browse and select products with quantity
/// - Automatic deal creation with phone data in JSON
/// - Lazy mode for weak devices (deferred analysis)
class QuickDealPage extends StatefulWidget {
  const QuickDealPage({super.key});

  @override
  State<QuickDealPage> createState() => _QuickDealPageState();
}

class _QuickDealPageState extends State<QuickDealPage> {
  List<Customer> _customers = [];
  List<AuroraProduct> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Selected customer (null if adding new)
  Customer? _selectedCustomer;
  
  // For new customer
  final _newCustomerNameController = TextEditingController();
  final _newCustomerPhoneController = TextEditingController();
  final _newCustomerEmailController = TextEditingController();
  final _newCustomerAddressController = TextEditingController();
  final _newCustomerNotesController = TextEditingController();
  String? _selectedAgeRange;
  bool _isNewCustomer = false;

  // Selected products for deal
  final Map<String, _ProductQuantity> _selectedProducts = {};
  
  // Deal details
  final _dealNotesController = TextEditingController();
  String _selectedPaymentMethod = 'cash';
  String _selectedDealStatus = 'completed';
  
  bool _isSubmitting = false;
  bool _lazyMode = true; // Deferred analysis for weak devices

  static const _ageRangeOptions = [
    {'value': 'teens', 'label': 'Teens (<20)'},
    {'value': '20s', 'label': '20s (20-29)'},
    {'value': '30s', 'label': '30s (30-39)'},
    {'value': '40s', 'label': '40s (40-49)'},
    {'value': '50s', 'label': '50s (50-59)'},
    {'value': '60s', 'label': '60s (60-69)'},
    {'value': '70s+', 'label': '70+'},
  ];

  static const _paymentMethods = [
    {'value': 'cash', 'label': 'Cash', 'icon': Icons.money},
    {'value': 'card', 'label': 'Card', 'icon': Icons.credit_card},
    {'value': 'bank_transfer', 'label': 'Bank Transfer', 'icon': Icons.account_balance},
    {'value': 'credit', 'label': 'Credit', 'icon': Icons.pending_actions},
  ];

  static const _dealStatuses = [
    {'value': 'pending', 'label': 'Pending', 'color': Colors.orange},
    {'value': 'negotiating', 'label': 'Negotiating', 'color': Colors.blue},
    {'value': 'agreed', 'label': 'Agreed', 'color': Colors.purple},
    {'value': 'completed', 'label': 'Completed', 'color': Colors.green},
    {'value': 'cancelled', 'label': 'Cancelled', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _newCustomerNameController.dispose();
    _newCustomerPhoneController.dispose();
    _newCustomerEmailController.dispose();
    _newCustomerAddressController.dispose();
    _newCustomerNotesController.dispose();
    _dealNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      
      // Load customers and products in parallel
      final results = await Future.wait([
        supabaseProvider.getCustomers(),
        supabaseProvider.getAllProducts(),
      ]);

      setState(() {
        _customers = results[0] as List<Customer>;
        _products = results[1] as List<AuroraProduct>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  double get _totalAmount {
    return _selectedProducts.values.fold(
      0.0,
      (sum, item) => sum + (item.product.price.salePrice * item.quantity),
    );
  }

  int get _totalItems {
    return _selectedProducts.values.fold(0, (sum, item) => sum + item.quantity);
  }

  void _toggleNewCustomer() {
    setState(() {
      _isNewCustomer = !_isNewCustomer;
      if (!_isNewCustomer) {
        _selectedCustomer = null;
      }
    });
  }

  void _selectCustomer(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
      _isNewCustomer = false;
    });
  }

  void _addProduct(AuroraProduct product) {
    setState(() {
      if (_selectedProducts.containsKey(product.id)) {
        _selectedProducts[product.id]!.quantity++;
      } else {
        _selectedProducts[product.id] = _ProductQuantity(product, 1);
      }
    });
  }

  void _removeProduct(String productId) {
    setState(() {
      _selectedProducts.remove(productId);
    });
  }

  void _updateQuantity(String productId, int delta) {
    setState(() {
      if (_selectedProducts.containsKey(productId)) {
        final item = _selectedProducts[productId]!;
        final newQuantity = item.quantity + delta;
        if (newQuantity > 0) {
          item.quantity = newQuantity;
        } else {
          _selectedProducts.remove(productId);
        }
      }
    });
  }

  Future<void> _submitDeal() async {
    // Validation
    if (_isNewCustomer) {
      if (_newCustomerNameController.text.trim().isEmpty ||
          _newCustomerPhoneController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in customer name and phone'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final analysisEngine = context.read<AnalysisEngine>();
      final uuid = const Uuid();

      // Create deal items
      final dealItems = _selectedProducts.entries.map((entry) {
        final product = entry.value.product;
        final quantity = entry.value.quantity;
        final unitPrice = product.price.salePrice;
        return DealItem(
          productName: product.content.title,
          quantity: quantity,
          unitPrice: unitPrice,
          subtotal: unitPrice * quantity,
        );
      }).toList();

      // Create deal transaction with phone data in JSON
      final dealTransaction = DealTransaction(
        id: uuid.v4(),
        date: DateTime.now(),
        totalAmount: _totalAmount,
        itemCount: _totalItems,
        paymentMethod: _selectedPaymentMethod,
        status: _selectedDealStatus,
        notes: _dealNotesController.text.trim(),
        items: dealItems,
      );

      Customer? customer;

      if (_isNewCustomer) {
        // Create new customer with deal
        final phoneDigits = _newCustomerPhoneController.text.trim().replaceAll(RegExp(r'\D'), '');
        
        // Add phone data to notes as JSON
        final phoneDataJson = {
          'phone': phoneDigits,
          'phoneFormatted': _newCustomerPhoneController.text.trim(),
          'addedAt': DateTime.now().toIso8601String(),
          'source': 'quick_deal',
        };

        final existingNotes = _newCustomerNotesController.text.trim();
        final fullNotes = existingNotes.isNotEmpty
            ? '$existingNotes\n\n${const JsonEncoder.withIndent('  ').convert(phoneDataJson)}'
            : const JsonEncoder.withIndent('  ').convert(phoneDataJson);

        customer = await analysisEngine.createCustomerWithDeal(
          name: _newCustomerNameController.text.trim(),
          phone: phoneDigits,
          email: _newCustomerEmailController.text.trim().isEmpty 
              ? null 
              : _newCustomerEmailController.text.trim(),
          address: _newCustomerAddressController.text.trim().isEmpty
              ? null
              : _newCustomerAddressController.text.trim(),
          notes: fullNotes,
          ageRange: _selectedAgeRange,
          initialDeal: dealTransaction,
        );
      } else {
        // Add deal to existing customer
        customer = _selectedCustomer;
        await analysisEngine.createDeal(
          customerId: customer!.id,
          deal: dealTransaction,
        );
      }

      // Lazy mode: defer heavy analysis
      if (!_lazyMode) {
        // Run full analysis immediately
        await analysisEngine.refreshAllAnalytics();
      } else {
        // Schedule background analysis for later
        // Analysis will run when device is idle or on next app launch
        debugPrint('Lazy mode: Analysis deferred for background processing');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Deal created successfully! Total: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(_totalAmount)}',
              ),
            ),
          ]),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate back to customers page
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create deal: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Quick Deal'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(_lazyMode ? Icons.battery_saver : Icons.speed),
            tooltip: _lazyMode ? 'Lazy Mode: ON' : 'Lazy Mode: OFF',
            onPressed: () {
              setState(() => _lazyMode = !_lazyMode);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_lazyMode ? 'Lazy mode enabled (analysis deferred)' : 'Full analysis enabled'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _errorMessage != null
              ? _buildErrorState(colorScheme)
              : Column(
                  children: [
                    // Customer Selection Section
                    _buildCustomerSection(colorScheme),
                    
                    // Products Selection Section
                    Expanded(child: _buildProductsSection(colorScheme)),
                    
                    // Deal Summary & Submit
                    _buildDealSummary(colorScheme),
                  ],
                ),
    );
  }

  Widget _buildCustomerSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1. Select Customer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                icon: Icon(_isNewCustomer ? Icons.person : Icons.person_add),
                label: Text(_isNewCustomer ? 'Use Existing' : 'Add New'),
                onPressed: _toggleNewCustomer,
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_isNewCustomer)
            _buildNewCustomerForm(colorScheme)
          else
            _buildCustomerDropdown(colorScheme),
        ],
      ),
    );
  }

  Widget _buildNewCustomerForm(ColorScheme colorScheme) {
    return Column(
      children: [
        TextField(
          controller: _newCustomerNameController,
          decoration: InputDecoration(
            labelText: 'Customer Name *',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newCustomerPhoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number *',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newCustomerEmailController,
          decoration: const InputDecoration(
            labelText: 'Email (optional)',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newCustomerAddressController,
          decoration: const InputDecoration(
            labelText: 'Address (optional)',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedAgeRange,
          decoration: const InputDecoration(
            labelText: 'Age Range (optional)',
            prefixIcon: Icon(Icons.cake),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _ageRangeOptions
              .map((opt) => DropdownMenuItem(
                    value: opt['value'] as String,
                    child: Text(opt['label'] as String),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedAgeRange = value),
          isExpanded: true,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newCustomerNotesController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            prefixIcon: Icon(Icons.note),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildCustomerDropdown(ColorScheme colorScheme) {
    if (_customers.isEmpty) {
      return Card(
        color: colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.info_outline, color: colorScheme.onErrorContainer, size: 32),
              const SizedBox(height: 8),
              Text(
                'No customers found. Add a new customer first.',
                style: TextStyle(color: colorScheme.onErrorContainer),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _toggleNewCustomer,
                icon: const Icon(Icons.person_add),
                label: const Text('Add New Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          child: Icon(Icons.person, color: colorScheme.onPrimary),
        ),
        title: DropdownButton<Customer>(
          value: _selectedCustomer,
          hint: const Text('Select a customer'),
          isExpanded: true,
          underline: const SizedBox(),
          items: _customers.map((customer) {
            return DropdownMenuItem(
              value: customer,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      customer.initials,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          customer.phone,
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _selectCustomer,
        ),
      ),
    );
  }

  Widget _buildProductsSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '2. Select Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: _products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'No products available',
                        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    final isSelected = _selectedProducts.containsKey(product.id);
                    return _buildProductCard(product, isSelected, colorScheme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(AuroraProduct product, bool isSelected, ColorScheme colorScheme) {
    final selectedQty = _selectedProducts[product.id]?.quantity ?? 0;

    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _addProduct(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: product.images.isNotEmpty && product.images.first.url.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product.images.first.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                        ),
                      )
                    : const Center(child: Icon(Icons.image, size: 40)),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.content.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                        .format(product.price.salePrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  
                  // Quantity controls if selected
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _updateQuantity(product.id, -1),
                        ),
                        Text(
                          '$selectedQty',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _updateQuantity(product.id, 1),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealSummary(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // Selected products summary
          if (_selectedProducts.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  '${_totalItems} items',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                const Spacer(),
                Text(
                  'Total: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(_totalAmount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Payment method
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    prefixIcon: const Icon(Icons.payment),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _paymentMethods
                      .map((method) => DropdownMenuItem(
                            value: method['value'] as String,
                            child: Row(
                              children: [
                                Icon(method['icon'] as IconData, size: 20),
                                const SizedBox(width: 8),
                                Text(method['label'] as String),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                  isExpanded: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDealStatus,
                  decoration: InputDecoration(
                    labelText: 'Deal Status',
                    prefixIcon: const Icon(Icons.status),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _dealStatuses
                      .map((status) => DropdownMenuItem(
                            value: status['value'] as String,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: status['color'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    status['label'] as String,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedDealStatus = value!),
                  isExpanded: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Notes
          TextField(
            controller: _dealNotesController,
            decoration: InputDecoration(
              labelText: 'Deal Notes (optional)',
              prefixIcon: const Icon(Icons.note_alt),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitDeal,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle),
              label: Text(_isSubmitting ? 'Creating Deal...' : 'Complete Deal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
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
              onPressed: _loadData,
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

class _ProductQuantity {
  final AuroraProduct product;
  int quantity;

  _ProductQuantity(this.product, this.quantity);
}
