import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle headerStyled({Color? color, double? fontSize}) =>
      GoogleFonts.rammettoOne(
        fontSize: fontSize,
        color: color,
        letterSpacing: 3,
      );
}
