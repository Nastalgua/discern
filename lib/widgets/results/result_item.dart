import 'dart:io';
import 'package:discern/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ResultItem extends StatelessWidget {
  final String itemType;

  const ResultItem({Key? key, required this.itemType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double length = 174.0;

    return SimpleShadow(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsViewRoute, 
              arguments: itemType
            );
          },
          child: Stack(
            children: [
              Container(
                width: length,
                height: length,
                decoration: BoxDecoration(
                  color: Color(0xFFe8e8e8),
                  borderRadius: BorderRadius.all(Radius.circular(22))
                )
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: length * 0.5,
                    height: length * 0.5,
                    child: FutureBuilder(
                      future: File('assets/icons/items/$itemType.svg').exists(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SvgPicture.asset('assets/icons/items/$itemType.svg');
                        } else {
                          return Container();
                        }
                      },
                    )
                  ),
                  Container(
                    // alignment: Alignment.center,
                    width: length,
                    child: Text(
                      this.itemType,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF454545)
                        )
                      ),
                    ),
                  )
                ],
              )
            ]
          ),
        ),
      ),
      opacity: 0.25,
      color: Color(0xFF222222),
      offset: Offset(0, 4),
      sigma: 2,
    );
  }
}
