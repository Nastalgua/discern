import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class Information extends StatelessWidget {
  final String itemType;

  const Information({Key? key, required this.itemType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString('assets/information/${this.itemType}.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return MarkdownBody(
            data: snapshot.data as String,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 19.0,
                  color: Color(0xFF454545),
                  fontWeight: FontWeight.w400
                )
              )
            ),
          );
        }
      
        return CircularProgressIndicator();
      }
    );
  }
}
