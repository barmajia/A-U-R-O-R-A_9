import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/pages/singup/login.dart';
import 'package:aurora/pages/seller/sellerprofile.dart';
import 'package:aurora/services/secure_storage.dart';
import 'package:aurora/services/supabase.dart';
import 'package:aurora/services/user_preferences_service.dart';
import 'package:aurora/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// Settings Sections Enum
// ============================================================================

enum SettingsSection { account, preferences, privacy, support }

// ============================================================================
// Settings Page
// ============================================================================

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // Settings State
  String _selectedLanguage = 'English';
  String? _selectedLanguageCode = 'en';
  String _selectedCurrency = 'USD';
  String _selectedCountry = 'United States';
  bool _locationEnabled = true;
  bool _biometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _hasEnrolledBiometric = false;

  // Loading State
  bool _isLoading = false;
  bool _isLocationLoading = false;
  bool _isBiometricLoading = false;

  // Services
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkLocationStatus();
  }

  // ============================================================================
  // Initialization & Loading
  // ============================================================================

  Future<void> _checkLocationStatus() async {
    try {
      final isGranted = await Permission.locationWhenInUse.isGranted;
      if (mounted) {
        setState(() {
          _locationEnabled = isGranted;
        });
      }
    } catch (e) {
      debugPrint('Error checking location status: $e');
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _selectedLanguage = prefs.getString('language') ?? 'English';
          _selectedLanguageCode = prefs.getString('language_code') ?? 'en';
          _selectedCurrency = prefs.getString('currency') ?? 'USD';
          _selectedCountry = prefs.getString('country') ?? 'United States';
          _locationEnabled = prefs.getBool('location') ?? true;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      debugPrint('Error saving setting $key: $e');
    }
  }

  // ============================================================================
  // Generic Selector Method (Refactored)
  // ============================================================================

  void _showGenericSelector<T>({
    required String title,
    required List<T> options,
    required T currentValue,
    required String saveKey,
    required Widget Function(BuildContext, T, bool) itemBuilder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == currentValue;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: itemBuilder(context, option, isSelected),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () async {
                        if (!mounted) return;

                        setState(() {
                          // Update local state
                        });
                        await _saveSetting(saveKey, option.toString());
                        Navigator.pop(context);

                        // Show confirmation
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$title updated to $option'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Permission Handlers
  // ============================================================================

  Future<void> _toggleLocationPermission(bool value) async {
    if (_isLocationLoading) return;

    if (value) {
      setState(() => _isLocationLoading = true);

      try {
        final status = await Permission.locationWhenInUse.status;

        if (status.isDenied) {
          final requestStatus = await Permission.locationWhenInUse.request();
          if (mounted) {
            setState(() {
              _locationEnabled = requestStatus.isGranted;
            });
            _showPermissionResult(
              requestStatus.isGranted,
              'Location permission granted',
              'Location permission denied',
            );
          }
        } else if (status.isPermanentlyDenied) {
          if (mounted) {
            final shouldOpen = await _showPermissionDialog();
            if (shouldOpen == true && mounted) {
              await openAppSettings();
            }
          }
        } else if (status.isGranted && mounted) {
          setState(() {
            _locationEnabled = true;
          });
        }
      } catch (e) {
        debugPrint('Error toggling location permission: $e');
      } finally {
        if (mounted) {
          setState(() => _isLocationLoading = false);
        }
      }
    } else {
      // Can't programmatically revoke - show dialog with settings link
      if (mounted) {
        _showDisableLocationDialog();
      }
    }
  }

  Future<bool?> _showPermissionDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text('Permission Required'),
          ],
        ),
        content: const Text(
          'Location permission is permanently denied. '
          'Please enable it in app settings to use location features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.settings),
            label: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showDisableLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.grey),
            SizedBox(width: 12),
            Text('Disable Location'),
          ],
        ),
        content: const Text(
          'To disable location services, please go to device settings.\n\n'
          'Note: This will affect location-based features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            icon: const Icon(Icons.settings),
            label: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionResult(bool granted, String successMsg, String failMsg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(granted ? successMsg : failMsg),
        backgroundColor: granted ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================================
  // Logout Implementation
  // ============================================================================

  Future<void> _performLogout() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Clear secure storage
      await _secureStorage.clearAll();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Logout from Supabase
      final supabaseProvider = context.read<SupabaseProvider>();
      await supabaseProvider.logout();

      // Navigate to login and clear all routes
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

void _showLogoutConfirmation(AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[700]),
            const SizedBox(width: 12),
            Text(l10n.logout),
          ],
        ),
        content: Text(l10n.are_you_sure),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _performLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Dialogs
  // ============================================================================

  void _showFeedbackDialog() {
    final l10n = AppLocalizations.of(context);
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contact_us),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We value your feedback!'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(ThemeProvider themeProvider) {
    final pageController = PageController(
      initialPage: themeProvider.isDarkMode ? 1 : 0,
    );
    int currentPage = themeProvider.isDarkMode ? 1 : 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color(0xFF1E1E2C)
                    : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Row(
                      children: [
                        const Text(
                          'Choose Theme',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildModeBtn('Light', currentPage == 0, () {
                                setSheetState(() => currentPage = 0);
                                pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }),
                              _buildModeBtn('Dark', currentPage == 1, () {
                                setSheetState(() => currentPage = 1);
                                pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) =>
                          setSheetState(() => currentPage = index),
                      children: [
                        _buildThemeGrid(
                          themeProvider.lightThemes,
                          themeProvider,
                          false,
                          sheetContext,
                        ),
                        _buildThemeGrid(
                          themeProvider.darkThemes,
                          themeProvider,
                          true,
                          sheetContext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModeBtn(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF667EEA) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeGrid(
    List themes,
    ThemeProvider themeProvider,
    bool isDarkMode,
    BuildContext sheetContext,
  ) {
    final currentId = themeProvider.currentThemeId;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final isSelected = theme.id == currentId;
        return GestureDetector(
          onTap: () async {
            await themeProvider.setTheme(theme.id);
            if (!mounted) return;
            Navigator.pop(sheetContext);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${theme.name} applied'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  theme.surface ??
                  (isDarkMode ? const Color(0xFF2D2D44) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF667EEA)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2)),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: (theme.preview as List<Color>).take(3).map<Widget>((
                    color,
                  ) {
                    return Expanded(
                      child: Container(
                        height: 24,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  theme.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (isSelected)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFF667EEA),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context);
    final languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'العربية', 'code': 'ar'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.select_language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = lang['code'] == _selectedLanguageCode;

                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        title: Text(
                          lang['name']!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () async {
                          final code = lang['code'] as String;
                          final name = lang['name'] as String;

                          // Save both display name and code
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('language', name);
                          await prefs.setString('language_code', code);

                          // Update UserPreferencesService if possible
                          if (!mounted) return;
                          try {
                            final prefsService = context
                                .read<UserPreferencesService>();
                            await prefsService.setLanguage(code);
                          } catch (e) {
                            debugPrint('Could not update locale: $e');
                          }

                          setState(() {
                            _selectedLanguage = name;
                            _selectedLanguageCode = code;
                          });

                          if (!mounted) return;
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.language_changed(name)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemePreview(List<Color> swatches) {
    return SizedBox(
      width: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: swatches.take(3).map((color) {
          return Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12, width: 1),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAboutDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about_us),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aurora E-commerce App'),
            const SizedBox(height: 8),
            Text('${l10n.version}: 1.0.0'),
            const SizedBox(height: 16),
            const Text(
              'Your one-stop shop for everything. Shop smart, shop with Aurora.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // UI Builders
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settings),
            centerTitle: true,
            elevation: 0,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    // Account Section
                    _buildAccountSection(l10n),

                    // Preferences Section
                    _buildPreferencesSection(themeProvider, l10n),

                    // Privacy Section
                    _buildPrivacySection(l10n),

                    // Support Section
                    _buildSupportSection(l10n),

                    // Logout Button
                    _buildLogoutButton(l10n),

                    const SizedBox(height: 32),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildAccountSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.settings_account),
        _buildListTile(
          icon: Icons.person_outline,
          title: l10n.profile,
          subtitle: l10n.edit_profile,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Sellerprofile()),
            );
          },
        ),
        _buildListTile(
          icon: Icons.location_on_outlined,
          title: l10n.shipping_address,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.coming_soon)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(ThemeProvider themeProvider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.settings_general),
        _buildListTile(
          icon: Icons.palette_outlined,
          title: l10n.settings_theme,
          subtitle: themeProvider.useSystemTheme
              ? l10n.system_theme
              : themeProvider.currentThemeName,
          onTap: () => _showThemeSelector(themeProvider),
        ),
        _buildListTile(
          icon: Icons.language,
          title: l10n.language,
          subtitle: _selectedLanguage,
          onTap: () => _showLanguageSelector(),
        ),
        _buildListTile(
          icon: Icons.attach_money,
          title: l10n.currency,
          subtitle: _selectedCurrency,
          onTap: () => _showGenericSelector<String>(
            title: l10n.currency,
            options: ['EGP', 'EUR', 'GBP', 'JPY', 'CNY', 'SAR', 'AED', 'USD'],
            currentValue: _selectedCurrency,
            saveKey: 'currency',
            itemBuilder: (context, currency, isSelected) => Text(currency),
          ),
        ),
        _buildListTile(
          icon: Icons.public,
          title: l10n.country,
          subtitle: _selectedCountry,
          onTap: () => _showGenericSelector<String>(
            title: l10n.select_country,
            options: [
              'United States',
              'United Kingdom',
              'Canada',
              'Australia',
              'Germany',
              'France',
              'Spain',
              'Italy',
              'China',
              'Japan',
              'Saudi Arabia',
              'United Arab Emirates',
              'India',
              'Brazil',
              'Mexico',
            ],
            currentValue: _selectedCountry,
            saveKey: 'country',
            itemBuilder: (context, country, isSelected) => Text(country),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.settings_privacy),
        _buildListTile(
          icon: Icons.location_searching,
          title: l10n.location,
          subtitle: _locationEnabled ? l10n.enabled : l10n.disabled,
          trailing: _isLocationLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Switch(
                  value: _locationEnabled,
                  onChanged: (value) {
                    _toggleLocationPermission(value);
                  },
                ),
        ),
        _buildListTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacy_policy,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.coming_soon)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.help),
        _buildListTile(
          icon: Icons.help_outline,
          title: l10n.help_center,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.coming_soon)),
            );
          },
        ),
        _buildListTile(
          icon: Icons.feedback_outlined,
          title: l10n.contact_us,
          onTap: _showFeedbackDialog,
        ),
        _buildListTile(
          icon: Icons.info_outline,
          title: l10n.about,
          subtitle: '${l10n.version} 1.0.0',
          onTap: _showAboutDialog,
        ),
      ],
    );
  }

  Widget _buildLogoutButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: _isLoading ? null : () => _showLogoutConfirmation(l10n),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: Text(
            l10n.logout,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(icon, size: 24),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing:
            trailing ??
            (onTap != null ? const Icon(Icons.chevron_right, size: 24) : null),
        onTap: onTap,
      ),
    );
  }
}
