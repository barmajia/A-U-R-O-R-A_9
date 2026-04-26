import 'package:flutter/material.dart';
import 'package:aurora/l10n/app_localizations.dart';
import 'package:aurora/utils/responsive_utils.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigate;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final bool showNavigationRail;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigate,
    this.floatingActionButton,
    this.appBar,
    this.drawer,
    this.showNavigationRail = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktopView(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final useNavigationRail = isDesktop || (isTablet && showNavigationRail);

    return Scaffold(
      appBar: useNavigationRail ? null : appBar,
      drawer: useNavigationRail ? null : drawer,
      body: Row(
        children: [
          if (useNavigationRail) _buildNavigationRail(context),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = ResponsiveUtils.isDesktopView(context);

    return NavigationRail(
      extended: isDesktop,
      selectedIndex: currentIndex,
      onDestinationSelected: onNavigate,
      labelType: isDesktop ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(Icons.store, size: isDesktop ? 48 : 32, color: Theme.of(context).primaryColor),
            if (isDesktop) const SizedBox(height: 8),
            if (isDesktop)
              Text(
                'Aurora',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(l10n.home),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.inventory_2_outlined),
          selectedIcon: const Icon(Icons.inventory_2),
          label: Text(l10n.products),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: Text(l10n.customers),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: Text(l10n.analytics),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(l10n.settings),
        ),
      ],
    );
  }
}

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showMenuButton;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showMenuButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktopView(context);
    final showLeading = showMenuButton && !isDesktop;

    return AppBar(
      title: Text(title),
      centerTitle: isDesktop,
      leading: showLeading
          ? leading ?? (Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ))
          : null,
      actions: isDesktop
          ? [
              ...?actions,
              const SizedBox(width: 16),
            ]
          : actions,
      elevation: 0,
    );
  }
}

class AdaptiveBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdaptiveBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.inventory_2_outlined),
          selectedIcon: const Icon(Icons.inventory_2),
          label: l10n.products,
        ),
        NavigationDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: l10n.customers,
        ),
        NavigationDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: l10n.analytics,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }
}