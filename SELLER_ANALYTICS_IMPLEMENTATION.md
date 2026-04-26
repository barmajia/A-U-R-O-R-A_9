# Seller Analytics System - Complete Implementation Guide

## Overview

This implementation provides a comprehensive analytics system for sellers that:
1. **Collects all seller data** (profile, customers, sales, addresses)
2. **Generates JSON files** with complete seller information
3. **Calculates advanced KPIs** through an analysis engine
4. **Uploads/downloads data** to/from Supabase storage bucket named `seller`
5. **Displays enhanced analytics** in the updated Analytics page

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Analytics Page (UI)                       │
│  - Display KPIs, Charts, Insights                           │
│  - Upload/Download buttons                                   │
│  - Period selection                                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              SellerAnalyticsService                          │
│  - collectSellerData()                                       │
│  - uploadToSupabase()                                        │
│  - downloadFromSupabase()                                    │
│  - saveToFile()                                              │
│  - runAnalysis()                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│            SellerAnalyticsData (Model)                       │
│  - SellerProfile                                             │
│  - List<CustomerData>                                        │
│  - List<SaleData>                                            │
│  - List<AddressData>                                         │
│  - AnalyticsKPIs                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Supabase Storage                                │
│  Bucket: "seller"                                            │
│  Files: {seller_id}.json                                     │
└─────────────────────────────────────────────────────────────┘
```

## Files Created/Modified

### New Files

1. **`lib/models/seller_analytics_data.dart`**
   - `SellerAnalyticsData` - Main container for all seller data
   - `SellerProfile` - Seller profile information
   - `CustomerData` - Customer data for export
   - `SaleData` - Sales transaction data
   - `AddressData` - Address information
   - `AnalyticsKPIs` - Computed key performance indicators

2. **`lib/services/seller_analytics_service.dart`**
   - `SellerAnalyticsService` - Service class for analytics operations
   - Data collection methods
   - JSON export/import
   - Supabase storage upload/download
   - Analysis engine
   - Batch operations

### Modified Files

1. **`lib/pages/analytics/analytics_page.dart`**
   - Added upload/download/save buttons in app bar
   - Integrated `SellerAnalyticsService`
   - Enhanced insights display with advanced KPIs
   - Added loading states for cloud operations

## Features

### 1. Data Collection

The system collects comprehensive data about a seller:

```dart
final analyticsService = SellerAnalyticsService(supabaseProvider);
final analyticsData = await analyticsService.collectSellerData(
  period: '30d',
);
```

**Collected Data:**
- **Seller Profile**: Name, email, location, currency, phone, coordinates
- **Customers**: All customers linked to seller with stats
- **Sales**: All sales transactions with customer and product details
- **Addresses**: Shipping addresses associated with seller
- **KPIs**: Automatically calculated metrics

### 2. JSON Export Format

Each seller gets a JSON file named `{seller_id}.json`:

```json
{
  "seller_id": "123",
  "generated_at": "2025-01-15T10:30:00Z",
  "seller_profile": {
    "id": 123,
    "email": "seller@example.com",
    "full_name": "John Doe",
    "location": "Cairo, Egypt",
    "currency": "EGP",
    "phone_number": "1234567890",
    "age": 35,
    "latitude": 30.0444,
    "longitude": 31.2357
  },
  "customers": [...],
  "sales": [...],
  "addresses": [...],
  "kpis": {
    "revenue": {
      "total_revenue": 50000.0,
      "total_revenue_this_period": 15000.0,
      "average_order_value": 250.0,
      "average_daily_revenue": 500.0
    },
    "sales": {
      "total_sales": 200,
      "total_sales_this_period": 60,
      "total_items_sold": 450,
      "conversion_rate": 0.0
    },
    "customers": {
      "total_customers": 85,
      "active_customers": 45,
      "new_customers_this_period": 12,
      "customer_retention_rate": 52.94,
      "customer_lifetime_value": 588.24
    },
    "period": {
      "period": "30d",
      "period_days": 30,
      "calculated_at": "2025-01-15T10:30:00Z"
    }
  },
  "metadata": {
    "collection_timestamp": "2025-01-15T10:30:00Z",
    "period": "30d",
    "version": "1.0.0"
  }
}
```

### 3. KPIs Calculated

#### Revenue Metrics
- **Total Revenue**: Sum of all sales net totals
- **Revenue This Period**: Revenue in selected time period
- **Average Order Value**: Total revenue / total sales
- **Average Daily Revenue**: Period revenue / days in period

#### Sales Metrics
- **Total Sales**: Count of all transactions
- **Sales This Period**: Transactions in selected period
- **Total Items Sold**: Sum of quantities sold
- **Conversion Rate**: (requires visitor data - currently 0)

#### Customer Metrics
- **Total Customers**: Count of unique customers
- **Active Customers**: Customers who purchased in last 30 days
- **New Customers This Period**: First purchase in period
- **Customer Retention Rate**: (Active / Total) × 100
- **Customer Lifetime Value**: Total revenue / total customers

### 4. Supabase Storage Integration

#### Upload to Cloud

```dart
await analyticsService.uploadToSupabase(
  analyticsData,
  bucketName: 'seller',
  isPublic: false,
);
```

- Uploads JSON file to `seller` bucket
- File name: `{seller_id}.json`
- Supports private or public access

#### Download from Cloud

```dart
final data = await analyticsService.downloadFromSupabase(
  sellerId,
  bucketName: 'seller',
);
```

- Downloads seller data from storage
- Parses JSON back to model
- Returns null if not found

#### Delete from Cloud

```dart
await analyticsService.deleteFromSupabase(
  sellerId,
  bucketName: 'seller',
);
```

### 5. Local File Operations

#### Save to Device

```dart
final file = await analyticsService.saveToFile(analyticsData);
// Saved to: /documents/seller_analytics/{seller_id}.json
```

#### Load from Device

```dart
final data = await analyticsService.loadFromFile(sellerId);
```

### 6. Analysis Engine

Run analysis on collected data:

```dart
final analyzedData = analyticsService.runAnalysis(
  analyticsData,
  period: '30d',
);
```

Compare two snapshots:

```dart
final comparison = analyticsService.compareSnapshots(
  previousData,
  currentData,
);
// Returns: revenue_change_percent, sales_change_percent, trend, etc.
```

### 7. Batch Operations

Upload data for all sellers:

```dart
final results = await analyticsService.batchUploadAllSellers(
  bucketName: 'seller',
);
// Returns: {total, successful, failed, errors}
```

## UI Enhancements

### Analytics Page App Bar

Four action buttons added:
1. **Cloud Download** ⬇️ - Download from Supabase storage
2. **Cloud Upload** ⬆️ - Upload to Supabase storage
3. **Save to Device** 💾 - Save JSON to local storage
4. **Refresh** 🔄 - Reload data from database

### Enhanced Insights Card

Now displays additional insights:
- Customer Retention Rate
- Customer Lifetime Value
- Average Daily Revenue
- Active Customers Count

## Usage Examples

### Basic Usage in Analytics Page

```dart
// In initState or refresh method
final supabaseProvider = context.read<SupabaseProvider>();
final analyticsService = SellerAnalyticsService(supabaseProvider);

// Collect all data
final analyticsData = await analyticsService.collectSellerData(
  period: '30d',
);

// Access KPIs
print('Total Revenue: ${analyticsData.kpis.totalRevenue}');
print('Total Customers: ${analyticsData.kpis.totalCustomers}');
print('Retention Rate: ${analyticsData.kpis.customerRetentionRate}%');

// Upload to cloud
await analyticsService.uploadToSupabase(analyticsData);

// Save locally
await analyticsService.saveToFile(analyticsData);
```

### Access Customer Details

```dart
for (final customer in analyticsData.customers) {
  print('${customer.name}: ${customer.totalOrders} orders, '
        '\$${customer.totalSpent} spent');
  print('Status: ${customer.customerStatus}');
  print('Active: ${customer.isActive}');
}
```

### Access Sales Data

```dart
for (final sale in analyticsData.sales) {
  print('Sale #${sale.id}: ${sale.quantity} items × '
        '\$${sale.unitPrice} = \$${sale.netTotal}');
  print('Customer: ${sale.customerName ?? "Walk-in"}');
  print('Payment: ${sale.paymentMethod} - ${sale.paymentStatus}');
}
```

## Supabase Setup

### Storage Bucket Configuration

1. Create bucket named `seller` in Supabase Dashboard
2. Set appropriate RLS policies:
   ```sql
   -- Allow authenticated users to upload their own data
   CREATE POLICY "Users can upload own analytics"
   ON storage.objects FOR INSERT
   TO authenticated
   WITH CHECK (bucket_id = 'seller' AND (storage.foldername(name))[1] = auth.uid()::text);

   -- Allow users to download their own data
   CREATE POLICY "Users can download own analytics"
   ON storage.objects FOR SELECT
   TO authenticated
   USING (bucket_id = 'seller' AND (storage.foldername(name))[1] = auth.uid()::text);
   ```

3. Optionally enable public access for specific files

## Error Handling

All service methods include try-catch blocks with debug logging:

```dart
try {
  // Operation
} catch (e, stackTrace) {
  debugPrint('[SellerAnalytics] Error: $e');
  debugPrint('[SellerAnalytics] Stack: $stackTrace');
  rethrow;
}
```

UI shows appropriate error messages via SnackBars.

## Performance Considerations

1. **Caching**: Original KPI method uses SharedPreferences caching
2. **Pagination**: Sales fetched with limit (default 10,000)
3. **Lazy Loading**: Full analytics only loaded when needed
4. **Background Processing**: Consider isolates for large datasets

## Future Enhancements

- [ ] PDF report generation
- [ ] Email scheduled reports
- [ ] Real-time analytics streaming
- [ ] Advanced charting and visualizations
- [ ] Comparative period analysis (YoY, MoM)
- [ ] Product performance breakdown
- [ ] Geographic sales distribution
- [ ] Customer segmentation
- [ ] Predictive analytics

## Testing

Test the implementation:

1. Navigate to Analytics page
2. Verify basic KPIs load
3. Click upload button - check Supabase storage
4. Click download button - verify data loads
5. Click save button - check device storage
6. Verify enhanced insights appear
7. Test different time periods

## Troubleshooting

### Upload Fails
- Check Supabase storage bucket exists
- Verify RLS policies allow upload
- Ensure user is authenticated
- Check file size limits

### No Data Shown
- Verify seller has sales/customers
- Check database permissions
- Review debug logs for errors

### KPIs Show Zero
- Ensure sales exist in database
- Check date range includes sales
- Verify data types match expectations

---

**Implementation Date**: 2025
**Version**: 1.0.0
**Author**: Aurora Development Team
