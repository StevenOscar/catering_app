import 'package:catering_app/constants/assets_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 40,
      fontWeight: fontWeight,
      height: height,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading2({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 30,
      fontWeight: fontWeight,
      height: height,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading3({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 24,
      height: height,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading4({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 20,
      height: height,

      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body1({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight,
      color: color,
      height: height,

      fontStyle: fontStyle,
    );
  }

  static TextStyle body2({
    required FontWeight fontWeight,
    Color? color,
    double? height,
    FontStyle? fontStyle,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight,
      height: height,

      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body3({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      height: height,

      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body4({
    required FontWeight fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyNunito,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight,
      height: height,
      color: color,
      fontStyle: fontStyle,
    );
  }
}
