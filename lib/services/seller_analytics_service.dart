/// Seller Analytics Service
/// Collects all seller data, generates KPIs, and handles JSON export/upload
/// 
/// Features:
/// - Collect complete seller data (profile, customers, sales, addresses)
/// - Generate comprehensive analytics and KPIs
/// - Export to JSON file format
/// - Upload to Supabase storage bucket
/// - Download and analyze existing data

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/seller_analytics_data.dart';
import '../models/seller.dart';
import '../models/customer.dart';
import '../models/sale.dart';
import '../backend/sellerdb.dart';
import 'supabase.dart';

class SellerAnalyticsService {
  final SupabaseProvider _supabase;
  final SellerDB? _sellerDb;
  
  SellerAnalyticsService(this._supabase, {SellerDB? sellerDb}) : _sellerDb = sellerDb;

  // ==========================================================================
  // DATA COLLECTION
  // ==========================================================================

  /// Collect all data for a seller and generate analytics
  Future<SellerAnalyticsData> collectSellerData({
    String? sellerId,
    String period = '30d',
  }) async {
    try {
      // Get current seller if not specified
      final effectiveSellerId = sellerId ?? _supabase.currentUser?.id;
      if (effectiveSellerId == null) {
        throw Exception('No seller ID provided and no logged-in user');
      }

      debugPrint('[SellerAnalytics] Collecting data for seller: $effectiveSellerId');

      // Fetch seller profile
      final seller = await _fetchSellerProfile(effectiveSellerId);
      if (seller == null) {
        throw Exception('Seller profile not found');
      }

      // Fetch all customers
      final customers = await _fetchAllCustomers(effectiveSellerId);
      debugPrint('[SellerAnalytics] Fetched ${customers.length} customers');

      // Fetch all sales (no date limit for complete data)
      final sales = await _fetchAllSales(effectiveSellerId);
      debugPrint('[SellerAnalytics] Fetched ${sales.length} sales');

      // Fetch addresses
      final addresses = await _fetchAddresses(effectiveSellerId);
      debugPrint('[SellerAnalytics] Fetched ${addresses.length} addresses');

      // Build analytics data
      final analyticsData = SellerAnalyticsData.fromData(
        seller: seller,
        customerList: customers,
        saleList: sales,
        addressList: addresses,
        extraMetadata: {
          'collection_timestamp': DateTime.now().toIso8601String(),
          'period': period,
          'version': '1.0.0',
        },
      );

      debugPrint('[SellerAnalytics] Data collection complete');
      return analyticsData;
    } catch (e, stackTrace) {
      debugPrint('[SellerAnalytics] Error collecting data: $e');
      debugPrint('[SellerAnalytics] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Fetch seller profile - prioritizes local SQLite, falls back to Supabase
  Future<Seller?> _fetchSellerProfile(String sellerId) async {
    try {
      // First try local SQLite database
      if (_sellerDb != null) {
        final sellerMap = await _sellerDb.getSellerByUserId(sellerId);
        if (sellerMap != null && sellerMap.isNotEmpty) {
          debugPrint('[SellerAnalytics] Loaded seller from local SQLite');
          return _convertMapToSeller(sellerMap);
        }
      }
      
      // Fall back to Supabase
      debugPrint('[SellerAnalytics] Falling back to Supabase for seller data');
      final response = await _supabase.client
          .from('sellers')
          .select()
          .eq('user_id', sellerId)
          .single();

      if (response == null) return null;
      return Seller.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[SellerAnalytics] Error fetching seller profile: $e');
      return null;
    }
  }

  /// Convert local SQLite map to Seller model
  Seller _convertMapToSeller(Map<String, dynamic> map) {
    return Seller(
      id: map['id'] as int?,
      userId: map['user_id'] as String? ?? '',
      firstname: map['firstname'] as String? ?? '',
      secondname: map['secondname'] as String? ?? '',
      thirdname: map['thirdname'] as String? ?? '',
      fourthname: map['fourthname'] as String? ?? map['forthname'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      location: map['location'] as String? ?? '',
      currency: map['currency'] as String? ?? 'EGP',
      accountType: map['account_type'] as String? ?? 'seller',
      isVerified: map['is_verified'] == 1,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      chatRoomId: map['chat_room_id'] as String?,
      createdAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'] as String) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.tryParse(map['updated_at'] as String) 
          : null,
    );
  }

  /// Fetch all customers for seller
  Future<List<Customer>> _fetchAllCustomers(String sellerId) async {
    try {
      final response = await _supabase.client
          .from('customers')
          .select()
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      if (response == null) return [];
      return (response as List)
          .map((json) => Customer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[SellerAnalytics] Error fetching customers: $e');
      return [];
    }
  }

  /// Fetch all sales for seller
  Future<List<Sale>> _fetchAllSales(String sellerId) async {
    try {
      // Get all sales without date restriction
      return await _supabase.getSales(
        startDate: DateTime(2000), // Very old date to get all
        limit: 10000,
      );
    } catch (e) {
      debugPrint('[SellerAnalytics] Error fetching sales: $e');
      return [];
    }
  }

  /// Fetch addresses for seller
  Future<List<AddressData>> _fetchAddresses(String sellerId) async {
    try {
      final response = await _supabase.client
          .from('shipping_addresses')
          .select()
          .eq('user_id', sellerId)
          .order('is_default', ascending: false);

      if (response == null) return [];
      
      return (response as List).map((addr) {
        return AddressData(
          id: addr['id'] as String,
          type: addr['type'] as String? ?? 'other',
          fullAddress: addr['address_line_1'] as String? ?? '',
          city: addr['city'] as String?,
          region: addr['state'] as String?,
          country: addr['country'] as String?,
          postalCode: addr['postal_code'] as String?,
          latitude: (addr['latitude'] as num?)?.toDouble(),
          longitude: (addr['longitude'] as num?)?.toDouble(),
          isDefault: addr['is_default'] as bool? ?? false,
          createdAt: addr['created_at'] != null
              ? DateTime.parse(addr['created_at'] as String)
              : null,
        );
      }).toList();
    } catch (e) {
      debugPrint('[SellerAnalytics] Error fetching addresses: $e');
      return [];
    }
  }

  // ==========================================================================
  // JSON EXPORT/IMPORT
  // ==========================================================================

  /// Convert seller data to JSON string
  String toJsonString(SellerAnalyticsData data) {
    return const JsonEncoder.withIndent('  ').convert(data.toJson());
  }

  /// Parse JSON string to seller data
  SellerAnalyticsData fromJsonString(String jsonString) {
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return SellerAnalyticsData.fromJson(jsonMap);
  }

  /// Save seller data to local file
  /// Creates folder structure: {seller_uuid}/{seller_full_name}.json
  Future<File> saveToFile(SellerAnalyticsData data, {String? directory}) async {
    try {
      final dir = directory != null
          ? Directory(directory)
          : await getApplicationDocumentsDirectory();
      
      // Create seller UUID folder
      final sellerDir = Directory('${dir.path}/seller_analytics/${data.sellerId}');
      if (!await sellerDir.exists()) {
        await sellerDir.create(recursive: true);
      }

      // Use seller full name for filename
      final safeFileName = _sanitizeFileName(data.sellerProfile.fullName);
      final filePath = '${sellerDir.path}/$safeFileName.json';
      final file = File(filePath);
      
      final jsonString = toJsonString(data);
      await file.writeAsString(jsonString);
      
      debugPrint('[SellerAnalytics] Saved to: $filePath');
      return file;
    } catch (e) {
      debugPrint('[SellerAnalytics] Error saving to file: $e');
      rethrow;
    }
  }

  /// Sanitize filename to remove invalid characters
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }

  /// Load seller data from local file
  Future<SellerAnalyticsData?> loadFromFile(String sellerId, {String? directory}) async {
    try {
      final dir = directory != null
          ? Directory(directory)
          : await getApplicationDocumentsDirectory();
      
      final filePath = '${dir.path}/seller_analytics/$sellerId.json';
      final file = File(filePath);
      
      if (!await file.exists()) {
        debugPrint('[SellerAnalytics] File not found: $filePath');
        return null;
      }

      final jsonString = await file.readAsString();
      return fromJsonString(jsonString);
    } catch (e) {
      debugPrint('[SellerAnalytics] Error loading from file: $e');
      return null;
    }
  }

  // ==========================================================================
  // SUPABASE STORAGE UPLOAD/DOWNLOAD
  // ==========================================================================

  /// Upload seller data JSON to Supabase storage bucket
  /// Bucket name: 'seller'
  Future<bool> uploadToSupabase(
    SellerAnalyticsData data, {
    String bucketName = 'seller',
  }) async {
    try {
      debugPrint('[SellerAnalytics] Uploading to Supabase bucket: $bucketName');

      final supabase = _supabase.client;
      final jsonString = toJsonString(data);
      final bytes = utf8.encode(jsonString);

      // Upload to storage
      final response = await supabase.storage
          .from(bucketName)
          .uploadBinary(
            data.filename,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      debugPrint('[SellerAnalytics] Upload successful: ${response.toString()}');

      return true;
    } catch (e) {
      debugPrint('[SellerAnalytics] Error uploading to Supabase: $e');
      rethrow;
    }
  }

  /// Download seller data from Supabase storage
  Future<SellerAnalyticsData?> downloadFromSupabase(
    String sellerId, {
    String bucketName = 'seller',
  }) async {
    try {
      debugPrint('[SellerAnalytics] Downloading from Supabase bucket: $bucketName');

      final supabase = _supabase.client;
      final filename = '$sellerId/$sellerId.json';

      // Download from storage
      final data = await supabase.storage
          .from(bucketName)
          .download(filename);

      // Convert to string
      final jsonString = utf8.decode(data);
      
      // Parse to model
      return fromJsonString(jsonString);
    } catch (e) {
      debugPrint('[SellerAnalytics] Error downloading from Supabase: $e');
      return null;
    }
  }

  /// Delete seller data from Supabase storage
  Future<bool> deleteFromSupabase(
    String sellerId, {
    String bucketName = 'seller',
  }) async {
    try {
      debugPrint('[SellerAnalytics] Deleting from Supabase bucket: $bucketName');

      final supabase = _supabase.client;
      final filename = '$sellerId.json';

      await supabase.storage.from(bucketName).remove([filename]);
      
      debugPrint('[SellerAnalytics] Deletion successful');
      return true;
    } catch (e) {
      debugPrint('[SellerAnalytics] Error deleting from Supabase: $e');
      return false;
    }
  }

  /// Get public URL for seller data
  String? getPublicUrl(String sellerId, {String bucketName = 'seller'}) {
    try {
      final supabase = _supabase.client;
      final filename = '$sellerId.json';
      return supabase.storage.from(bucketName).getPublicUrl(filename);
    } catch (e) {
      debugPrint('[SellerAnalytics] Error getting public URL: $e');
      return null;
    }
  }

  // ==========================================================================
  // ANALYSIS ENGINE
  // ==========================================================================

  /// Run analysis on seller data and update KPIs
  SellerAnalyticsData runAnalysis(SellerAnalyticsData data, {
    String period = '30d',
  }) {
    debugPrint('[SellerAnalytics] Running analysis with period: $period');

    // Recalculate KPIs with fresh data
    final updatedKPIs = AnalyticsKPIs.calculate(
      customers: data.customers,
      sales: data.sales,
      period: period,
    );

    // Create new instance with updated KPIs
    return SellerAnalyticsData(
      sellerId: data.sellerId,
      generatedAt: DateTime.now(),
      sellerProfile: data.sellerProfile,
      customers: data.customers,
      sales: data.sales,
      addresses: data.addresses,
      kpis: updatedKPIs,
      metadata: {
        ...data.metadata,
        'last_analysis': DateTime.now().toIso8601String(),
        'analysis_period': period,
      },
    );
  }

  /// Compare two seller data snapshots
  Map<String, dynamic> compareSnapshots(
    SellerAnalyticsData previous,
    SellerAnalyticsData current,
  ) {
    final prevRevenue = previous.kpis.totalRevenue;
    final currRevenue = current.kpis.totalRevenue;
    final revenueChange = prevRevenue > 0 
        ? ((currRevenue - prevRevenue) / prevRevenue) * 100 
        : 0;

    final prevSales = previous.kpis.totalSales;
    final currSales = current.kpis.totalSales;
    final salesChange = prevSales > 0 
        ? ((currSales - prevSales) / prevSales) * 100 
        : 0;

    final prevCustomers = previous.customers.length;
    final currCustomers = current.customers.length;
    final customerChange = prevCustomers > 0 
        ? ((currCustomers - prevCustomers) / prevCustomers) * 100 
        : 0;

    return {
      'revenue_change_percent': revenueChange,
      'revenue_change_absolute': currRevenue - prevRevenue,
      'sales_change_percent': salesChange,
      'sales_change_absolute': currSales - prevSales,
      'customer_change_percent': customerChange,
      'customer_change_absolute': currCustomers - prevCustomers,
      'trend': revenueChange > 0 ? 'up' : revenueChange < 0 ? 'down' : 'stable',
    };
  }

  // ==========================================================================
  // BATCH OPERATIONS
  // ==========================================================================

  /// Collect and upload data for all sellers
  Future<Map<String, dynamic>> batchUploadAllSellers({
    String bucketName = 'seller',
  }) async {
    try {
      debugPrint('[SellerAnalytics] Starting batch upload for all sellers');

      // Get all sellers
      final response = await _supabase.client
          .from('sellers')
          .select('id, email');

      if (response == null) {
        return {'success': false, 'error': 'Failed to fetch sellers'};
      }

      final sellers = response as List;
      final results = <String, dynamic>{
        'total': sellers.length,
        'successful': 0,
        'failed': 0,
        'errors': <String>[],
      };

      for (final sellerData in sellers) {
        final sellerId = sellerData['id'].toString();
        try {
          // Collect data
          final analyticsData = await collectSellerData(sellerId: sellerId);
          
          // Upload to Supabase
          await uploadToSupabase(analyticsData, bucketName: bucketName);
          
          results['successful'] = (results['successful'] as int) + 1;
          debugPrint('[SellerAnalytics] Uploaded data for seller: $sellerId');
        } catch (e) {
          results['failed'] = (results['failed'] as int) + 1;
          results['errors'].add('$sellerId: $e');
          debugPrint('[SellerAnalytics] Failed for seller $sellerId: $e');
        }
      }

      debugPrint('[SellerAnalytics] Batch upload complete: ${results['successful']}/${results['total']} successful');
      return results;
    } catch (e) {
      debugPrint('[SellerAnalytics] Batch upload error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}
