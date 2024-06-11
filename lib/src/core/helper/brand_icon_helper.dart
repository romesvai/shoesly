import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';

class BrandIconHelper {
  BrandIconHelper._();

  static SvgPicture getBrandIcon(
    String brand, {
    Color? color,
  }) {
    switch (brand) {
      case jordan:
        return AssetsHelper.svgJordanIcon.svg(
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );
      case adidas:
        return AssetsHelper.svgAdidasIcon.svg(
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );
      case nike:
        return AssetsHelper.svgNikeLogo.svg(
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );
      default:
        return AssetsHelper.svgNikeLogo.svg(
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );
    }
  }
}
