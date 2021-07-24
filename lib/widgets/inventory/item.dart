import 'dart:io';
import 'package:discern/constants/route_constants.dart';
import 'package:discern/models/inventory_item.dart';
import 'package:discern/widgets/font_text.dart';
import 'package:flutter/material.dart';

import 'package:simple_shadow/simple_shadow.dart';

class Item extends StatelessWidget {

  final InventoryItem item;

  const Item({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsViewRoute, 
          arguments: this.item.name
        );
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SimpleShadow(
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 8),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22)
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image(image: AssetImage('assets/imgs/${this.item.name}.jpg'))
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    montserratText(this.item.name, 22.0, FontWeight.w600),
                    montserratText("   x${this.item.count}", 20.0, FontWeight.w300),
                  ],
                )
              )
            ],
          ),
        ),
        opacity: 0.25,
        color: Color(0xFFd1d1d1),
        offset: Offset(0, 4),
        sigma: 2,
      ),
    );
  }
}
