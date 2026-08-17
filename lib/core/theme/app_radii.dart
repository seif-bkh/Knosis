import 'package:flutter/material.dart';

/// Corner radii. PRODUCT_REPORT.md section 12 asks for rounded corners in the
/// 16-24px range; [card] is the default for surfaces.
abstract final class AppRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
