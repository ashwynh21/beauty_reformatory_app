import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
This class I have placed here to manage the conversion functions as well as any
other functions that can go here to be used in multiple places across the
application.
 */

// ignore: camel_case_types
class utilities {
  static _colors colors = new _colors();
  static _material_colors material_colors = new _material_colors();
  static _flare flares = new _flare();
}
class _colors {
    Color primary = Color(0xFFB97095);

    Color white = Colors.white;
    Color dark = Color(0xFF261F22);
    Color light = Color(0xFFF9B0D5);
    Color facebook = Color(0xFF3F7EBC);
    Color google = Color(0xFFE54E3F);
}
class _material_colors {
  static Map<int, Color> primary_map = {
    50: Color(0xFFB97095).withOpacity(0.1),
    100: Color(0xFFB97095).withOpacity(0.2),
    200: Color(0xFFB97095).withOpacity(0.3),
    300: Color(0xFFB97095).withOpacity(0.4),
    400: Color(0xFFB97095).withOpacity(0.5),
    500: Color(0xFFB97095).withOpacity(0.6),
    600: Color(0xFFB97095).withOpacity(0.7),
    700: Color(0xFFB97095).withOpacity(0.8),
    800: Color(0xFFB97095).withOpacity(0.9),
    900: Color(0xFFB97095).withOpacity(1),
  };

  MaterialColor primary = MaterialColor(0xFFB97095, primary_map);
}
class _flare {
  List<String> files = [
    'lib/assets/flares/logo.flr',
    'lib/assets/flares/top_wave.flr',
    'lib/assets/flares/avatar_icon.flr',
    'lib/assets/flares/lock_icon.flr',
    'lib/assets/flares/password_icon.flr',
    'lib/assets/flares/google.flr',
    'lib/assets/flares/facebook.flr',
    'lib/assets/flares/avatar_icon.flr',
    'lib/assets/flares/mail_icon.flr',
    'lib/assets/flares/mobile_icon.flr',
    'lib/assets/flares/globe_icon.flr',
  ];

  Future<void> preload() async {
    for (final filename in files) {
      await cachedActor(rootBundle, filename);
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }
}