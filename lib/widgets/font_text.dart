import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget poppinsText(String text, double fontSize, FontWeight fontWeight, {color: Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color
      )
    ),
  );
}

Widget montserratText(String text, double fontSize, FontWeight fontWeight, {color: Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color
      )
    ),
  );
}
