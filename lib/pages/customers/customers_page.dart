import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/models/customer.dart';
import 'package:aurora/pages/customers/customer_details_screen.dart';
import 'package:aurora/pages/deals/quick_deal_page.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer> _customers = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final customers = await supabaseProvider.getCustomers();

      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load customers: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchCustomers(String query) async {
    if (query.isEmpty) {
      _loadCustomers();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final customers = await supabaseProvider.searchCustomers(query);

      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToAddCustomer() {
    showDialog(
      context: context,
      builder: (context) => const AddCustomerDialog(),
    ).then((result) {
      if (result == true) _loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      drawer: const AppDrawer(currentPage: 'customers'),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _errorMessage != null
              ? _buildErrorState(colorScheme)
              : Column(
                  children: [
                    _buildSearchBar(colorScheme),
                    _buildCustomerCount(colorScheme),
                    Expanded(child: _buildCustomerList(colorScheme)),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickDealPage()),
          ).then((result) {
            if (result == true) _loadCustomers();
          });
        },
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
        label: const Text('Create Deal', style: TextStyle(color: Colors.white)),
        tooltip: 'Create Quick Deal',
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      title: const Text('Customers'),
      centerTitle: true,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: _navigateToAddCustomer,
          tooltip: 'Add Customer',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadCustomers,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Search by name or phone...',
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
            prefixIcon: Icon(Icons.search, color: colorScheme.onSurface),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.onSurface),
                    onPressed: () {
                      _searchController.clear();
                      _loadCustomers();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: _searchCustomers,
        ),
      ),
    );
  }

  Widget _buildCustomerCount(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '${_customers.length} customer${_customers.length != 1 ? 's' : ''}',
        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
      ),
    );
  }

  Widget _buildCustomerList(ColorScheme colorScheme) {
    if (_customers.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        return _buildCustomerCard(customer, colorScheme);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer, ColorScheme colorScheme) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => _navigateToCustomerDetails(customer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primary,
                child: Text(
                  customer.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📱 ${customer.phone}',
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    if (customer.ageRange != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        customer.ageRangeDisplay,
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ],
                ),
              ),

              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${customer.totalOrders} orders',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(customer.totalSpent),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No customers yet',
            style: TextStyle(fontSize: 18, color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _navigateToAddCustomer,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Your First Customer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              onPressed: _loadCustomers,
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

  void _navigateToCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerDetailsScreen(customer: customer)),
    ).then((result) {
      if (result == true) _loadCustomers();
    });
  }
}

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({super.key});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedAgeRange;
  bool _isLoading = false;

  static const _ageRangeOptions = [
    {'value': 'teens', 'label': 'Teens (<20)'},
    {'value': '20s', 'label': '20s (20-29)'},
    {'value': '30s', 'label': '30s (30-39)'},
    {'value': '40s', 'label': '40s (40-49)'},
    {'value': '50s', 'label': '50s (50-59)'},
    {'value': '60s', 'label': '60s (60-69)'},
    {'value': '70s+', 'label': '70+'},
  ];

  static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) return 'Enter a valid phone number';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabaseProvider = context.read<SupabaseProvider>();
      final result = await supabaseProvider.addCustomer(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().replaceAll(RegExp(r'\D'), ''),
        ageRange: _selectedAgeRange,
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (!mounted) return;

      if (result.success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(result.message),
            ]),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(result.message)),
            ]),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: _isLoading ? _buildLoading(isDark) : _buildForm(isDark, borderColor),
      ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(0xFF667EEA)),
          const SizedBox(height: 16),
          Text(
            'Saving customer...',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isDark, Color borderColor) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Customer',
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
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _inputDecoration('Name *', Icons.person_outline, isDark, borderColor),
              validator: _validateName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _inputDecoration('Phone *', Icons.phone_outlined, isDark, borderColor),
              validator: _validatePhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedAgeRange,
              dropdownColor: isDark ? const Color(0xFF2D2D44) : Colors.white,
              decoration: _inputDecoration('Age Range', Icons.calendar_today, isDark, borderColor),
              items: _ageRangeOptions.map((opt) => DropdownMenuItem(
                value: opt['value'],
                child: Text(opt['label']!, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              )).toList(),
              onChanged: (v) => setState(() => _selectedAgeRange = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _inputDecoration('Email (Optional)', Icons.email_outlined, isDark, borderColor),
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _inputDecoration('Notes (Optional)', Icons.note_alt_outlined, isDark, borderColor),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, bool isDark, Color borderColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
      prefixIcon: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2)),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
    );
  }
}
