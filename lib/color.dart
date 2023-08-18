import 'package:flutter/material.dart';

const MaterialColor maincolor = MaterialColor(_maincolorPrimaryValue, <int, Color>{
  50: Color(0xFFE0F4EB),
  100: Color(0xFFB3E4CE),
  200: Color(0xFF80D3AD),
  300: Color(0xFF4DC18C),
  400: Color(0xFF26B373),
  500: Color(_maincolorPrimaryValue),
  600: Color(0xFF009E52),
  700: Color(0xFF009548),
  800: Color(0xFF008B3F),
  900: Color(0xFF007B2E),
});
const int _maincolorPrimaryValue = 0xFF00A65A;

const MaterialColor maincolorAccent = MaterialColor(_maincolorAccentValue, <int, Color>{
  100: Color(0xFFA8FFC1),
  200: Color(_maincolorAccentValue),
  400: Color(0xFF42FF78),
  700: Color(0xFF29FF66),
});
const int _maincolorAccentValue = 0xFF75FF9D;