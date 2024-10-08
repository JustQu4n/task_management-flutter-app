import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  AppColors({this.appearance = Appearance.light});

  final Appearance appearance;

  bool get _isLightColors => appearance == Appearance.light;

  AppColorsScheme get scheme => _isLightColors ? lightScheme : darkScheme;

  static const AppColorsScheme lightScheme = AppColorsScheme(
    bgGray: Colors.black54,
    bgGrayLight: Color(0xFFE0E0E0),
    textGray: Color(0xFFAABBCC),
    textBlack: Color(0xFF000000),
    borderColor: Color(0xFFDCDCDC),
    buttonEnable: Color(0xFF418FFF),
    textOnBtnEnable: Color(0xFFFFFFFF),
    buttonDisable: Color(0xFFDDEBFF),
    fingerID: Color(0xFFFFFFFF),
    textWhite: Color(0xFFFFFFFF),
    gradient_bg_1: Color(0xFF7BB0EF),
    gradient_bg_2: Color(0xFF66A6F1),
    gradient_bg_3: Color(0xFF478DE0),
    gradient_bg_4: Color(0xFF398AE5),
    tfcolor: Color(0xFF6CA8F1),
    defaultBgContainer: Color(0xFFFFFFFF),
    failureText: Color(0xFFEF6565),
    bgGrayWhiteLight: Color(0xFFF1ECEC),
    colorDarkGray: Color(0xFF797A7C),
  );

  static const AppColorsScheme darkScheme = AppColorsScheme(
      bgGray: Colors.black54,
      bgGrayLight: Color(0xFFE0E0E0),
      textGray: Color(0xFFAABBCC),
      textBlack: Color(0xFFFFFFFF),
      borderColor: Color(0xFFF8F8F8),
      buttonEnable: Color(0xFF3A414C),
      textOnBtnEnable: Color(0xFF000000),
      buttonDisable: Color(0xFF9DC5FB),
      fingerID: Color(0xFFFFFFFF),
      textWhite: Color(0xFFFFFFFF),
      gradient_bg_1: Color(0xFF7BB0EF),
      gradient_bg_2: Color(0xFF66A6F1),
      gradient_bg_3: Color(0xFF478DE0),
      gradient_bg_4: Color(0xFF398AE5),
      tfcolor: Color(0xFF6CA8F1),
      defaultBgContainer: Color(0xFFFFFFFF),
      failureText: Color(0xFFEF6565),
      bgGrayWhiteLight: Color(0xFFF1ECEC),
      colorDarkGray: Color(0xFF838080));
}

enum Appearance { light, dark }

class AppColorsScheme {
  const AppColorsScheme(
      {required this.bgGray,
      required this.bgGrayLight,
      required this.textGray,
      required this.textBlack,
      required this.borderColor,
      required this.buttonEnable,
      required this.buttonDisable,
      required this.textOnBtnEnable,
      required this.fingerID,
      required this.textWhite,
      required this.gradient_bg_1,
      required this.gradient_bg_2,
      required this.gradient_bg_3,
      required this.gradient_bg_4,
      required this.tfcolor,
      required this.defaultBgContainer,
      this.primary = Colors.blue,
      this.primaryDarker = const Color.fromARGB(255, 100, 181, 246),
      this.primaryLighter = const Color.fromARGB(255, 100, 181, 246),
      required this.failureText,
        required this.bgGrayWhiteLight,
      required this.colorDarkGray});

  final Color bgGray;
  final Color bgGrayLight;
  final Color bgGrayWhiteLight;
  final Color textGray;
  final Color textBlack;
  final Color textWhite;
  final Color borderColor;
  final Color buttonEnable;
  final Color buttonDisable;
  final Color textOnBtnEnable;
  final Color fingerID;
  final Color primary;
  final Color primaryDarker;
  final Color primaryLighter;
  final Color gradient_bg_1;
  final Color gradient_bg_2;
  final Color gradient_bg_3;
  final Color gradient_bg_4;
  final Color tfcolor;
  final Color defaultBgContainer;
  final Color failureText;
  final Color colorDarkGray;
}
