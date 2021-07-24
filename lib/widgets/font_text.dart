import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget poppinsText(String text, double fontSize, FontWeight fontWeight) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight
      )
    ),
  );
}
