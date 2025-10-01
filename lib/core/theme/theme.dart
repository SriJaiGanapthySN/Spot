import 'package:flutter/material.dart';
import 'package:spot/core/theme/app_pallete.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete().background,
  );
}
