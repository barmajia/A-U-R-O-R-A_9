import 'package:flutter/material.dart';

enum ScreenType { phone, tablet, desktop }

class ResponsiveUtils {
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return ScreenType.phone;
    if (width < 1200) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktopView(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  static double getSidebarWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 280;
    if (width >= 600) return 240;
    return 0;
  }

  static EdgeInsets getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return const EdgeInsets.all(32);
    if (width >= 600) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, ScreenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = constraints.maxWidth < 600
            ? ScreenType.phone
            : (constraints.maxWidth < 1200 ? ScreenType.tablet : ScreenType.desktop);
        return builder(context, screenType);
      },
    );
  }
}

class AdaptiveLayout extends StatelessWidget {
  final Widget? phone;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({super.key, this.phone, this.tablet, this.desktop});

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveUtils.getScreenType(context);
    switch (screenType) {
      case ScreenType.phone:
        return phone ?? tablet ?? desktop ?? const SizedBox();
      case ScreenType.tablet:
        return tablet ?? desktop ?? phone ?? const SizedBox();
      case ScreenType.desktop:
        return desktop ?? tablet ?? phone ?? const SizedBox();
    }
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? phone;
  final double? tablet;
  final double? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.phone,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveUtils.getScreenType(context);
    final padding = switch (screenType) {
      ScreenType.phone => phone ?? 16,
      ScreenType.tablet => tablet ?? 24,
      ScreenType.desktop => desktop ?? 32,
    };
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: children,
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: children,
    );
  }
}