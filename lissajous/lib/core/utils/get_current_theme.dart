import 'package:flutter/material.dart';
import 'package:lissajous/theme/theme.dart';

ThemeData getCurrentTheme(bool isDarkTheme) {
  return isDarkTheme ? AppTheme.darkTheme : AppTheme.ligthTheme;
}
