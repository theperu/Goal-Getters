import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle withColor(Color c) => copyWith(color: c);
}
