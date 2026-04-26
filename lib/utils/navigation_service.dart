import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  static Future<T?> push<T>(Widget page) {
    final state = navigator;
    if (state == null) return Future.value();
    return state.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushReplacement<T, TO>(Widget page) {
    final state = navigator;
    if (state == null) return Future.value();
    return state.pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget page) {
    final state = navigator;
    if (state == null) return Future.value();
    return state.pushAndRemoveUntil<T>(MaterialPageRoute(builder: (_) => page), (route) => false);
  }

  static void pop<T>([T? result]) {
    navigator?.pop<T>(result);
  }

  static void popUntil(String routeName) {
    navigator?.popUntil((route) => route.settings.name == routeName);
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: duration,
      ),
    );
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String products = '/products';
  static const String analytics = '/analytics';
  static const String customers = '/customers';
}