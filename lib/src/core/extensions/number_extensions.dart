import 'package:flutter/cupertino.dart';

extension IntX on int {
  BorderRadius get circularBorderRadius => BorderRadius.circular(toDouble());
}
