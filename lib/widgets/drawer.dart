import 'package:aurora/pages/analytics/analytics_page.dart';
import 'package:aurora/pages/customers/customers_page.dart';
import 'package:aurora/pages/product/product.dart';
import 'package:aurora/pages/seller/sellerProfile.dart';
import 'package:aurora/pages/setting/setting.dart';
import 'package:aurora/pages/singup/home.dart';
import 'package:aurora/pages/singup/login.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/theme/themeprovider.dart';
import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/pages/seller_analytics/seller_analytics_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;

  const AppDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final supabaseProvider = context.watch<SupabaseProvider>();
    final currentUser = supabaseProvider.currentUser;
    final accountType = supabaseProvider.accountType;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // AppBar background colors from theme
    final appBarBg = isDark ? AppColors.darkSurface : AppColors.auroraPrimary;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E1E2C),
                    const Color(0xFF2D2D44),
                    const Color(0xFF1E1E2C),
                  ]
                : [
                    const Color(0xFF667EEA),
                    const Color(0xFF764BA2),
                    Colors.white,
                  ],
            stops: isDark ? null : const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, currentUser, accountType),

              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Home - Always visible
                      _buildMenuItem(
                        context,
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        title: AppLocalizations.of(context).home,
                        pageName: 'home',
                        onTap: () =>
                            _navigateTo(context, const Homepage(), 'home'),
                      ),

                      // Seller Profile - Only for sellers
                      if (accountType == AccountType.seller) ...[
                        _buildMenuItem(
                          context,
                          icon: Icons.store_outlined,
                          activeIcon: Icons.store,
                          title: AppLocalizations.of(context).seller_profile,
                          pageName: 'seller_profile',
                          onTap: () => _navigateTo(
                            context,
                            const Sellerprofile(),
                            'seller_profile',
                          ),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.inventory_2_outlined,
                          activeIcon: Icons.inventory_2,
                          title: AppLocalizations.of(context).products,
                          pageName: 'products',
                          onTap: () => _navigateTo(
                            context,
                            const ProductPage(),
                            'products',
                          ),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.people_outlined,
                          activeIcon: Icons.people,
                          title: AppLocalizations.of(context).customers,
                          pageName: 'seller_analytics',
                          onTap: () => _navigateTo(
                            context,
                            const SellerAnalyticsPage(),
                            'seller_analytics',
                          ),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.analytics_outlined,
                          activeIcon: Icons.analytics,
                          title: AppLocalizations.of(context).analytics,
                          pageName: 'analytics',
                          onTap: () => _navigateTo(
                            context,
                            const AnalyticsPage(),
                            'analytics',
                          ),
                        ),
                        // Deals functionality moved to Messages (NearbyUsersScreen handles deal proposals)
                      ],
                      
                      // Common Menu Items - Visible to all users
                      _buildMenuItem(
                        context,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings,
                        title: AppLocalizations.of(context).settings,
                        pageName: 'settings',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Setting(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        activeIcon: Icons.help,
                        title: AppLocalizations.of(context).help,
                        pageName: 'help',
                        onTap: () => _showComingSoon(
                          context,
                          AppLocalizations.of(context).help,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer - Logout
              _buildFooter(context, supabaseProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    dynamic user,
    AccountType accountType,
  ) {
    final fullName =
        user?.userMetadata?['full_name'] ?? AppLocalizations.of(context).user;
    final email = user?.email ?? 'email@example.com';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxHeight < 180;
        final avatarSize = isLandscape ? 28.0 : 40.0;
        final padding = isLandscape ? 12.0 : 20.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color(0xFF667EEA).withOpacity(0.3),
                      Color(0xFF764BA2).withOpacity(0.2),
                    ]
                  : [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
            ),
            borderRadius: BorderRadius.circular(isLandscape ? 12 : 20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: isLandscape ? 10 : 20,
                offset: Offset(0, isLandscape ? 4 : 10),
              ),
            ],
          ),
          child: isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarSize,
                      backgroundColor: isDark ? colorScheme.surface : Colors.white,
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: avatarSize,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    CircleAvatar(
                      radius: avatarSize,
                      backgroundColor: isDark ? colorScheme.surface : Colors.white,
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String pageName,
    required VoidCallback onTap,
    String? badge,
  }) {
    final isActive = currentPage == pageName;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? const Color(0xFF3D3D5C) : const Color(0xFFF0EBFF))
            : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.9)),
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: const Color(0xFF667EEA), width: 2)
            : Border.all(color: Colors.transparent),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          )
                        : null,
                    color: isActive
                        ? null
                        : (isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? (isDark ? Colors.white : const Color(0xFF667EEA))
                          : (isDark ? Colors.grey[300] : Colors.grey[800]),
                    ),
                  ),
                ),

                // Badge
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: isActive
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SupabaseProvider supabaseProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context, supabaseProvider),
              icon: Icon(Icons.logout, color: colorScheme.error),
              label: Text(
                AppLocalizations.of(context).logout,
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: colorScheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // App Version
          Text(
            'Aurora E-commerce v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? colorScheme.onSurface.withOpacity(0.6)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 Aurora. All rights reserved.',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? colorScheme.onSurface.withOpacity(0.5)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page, String pageName) {
    // Close the drawer

    // If we're already on this page, nothing to do
    if (currentPage == pageName) {
      return;
    }

    // Navigate to the page normally - this allows back button to work
    // Each page is added to the stack, so user can navigate back
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _showComingSoon(BuildContext context, String feature) {
    Navigator.pop(context); // Close drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    SupabaseProvider supabaseProvider,
  ) {
    Navigator.pop(context); // Close drawer

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red[700]),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context).logout),
            ],
          ),
          content: Text(AppLocalizations.of(context).are_you_sure),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                await supabaseProvider.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context).logout),
            ),
          ],
        );
      },
    );
  }
}
