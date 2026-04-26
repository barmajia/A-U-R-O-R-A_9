import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class PlatformInit {
  static Future<void> initDesktop() async {
    if (!isDesktopPlatform) return;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Aurora E-commerce',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  static Future<void> setWindowSize(Size size) async {
    if (!isDesktopPlatform) return;
    await windowManager.setSize(size);
  }

  static Future<void> setMinimumSize(Size size) async {
    if (!isDesktopPlatform) return;
    await windowManager.setMinimumSize(size);
  }

  static bool get isDesktopPlatform =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}