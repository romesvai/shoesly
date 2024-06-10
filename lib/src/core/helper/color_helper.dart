import 'package:flutter/material.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';

class ColorHelper {
  ColorHelper._();

  static Color getColorFromString(String color) {
    switch (color) {
      case red:
        return Colors.red;
      case blue:
        return Colors.blue;
      case yellow:
        return Colors.yellow;
      case black:
        return Colors.black;
      case white:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }
}
