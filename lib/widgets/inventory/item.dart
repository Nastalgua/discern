import 'package:flutter/material.dart';

import 'package:discern/helpers/font_text.dart';

import 'package:discern/helpers/string_format.dart';
import 'package:discern/models/inventory_item.dart';
import 'package:discern/constants/route_constants.dart';

class Item extends StatelessWidget {

  final InventoryItem item;

  const Item({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(20.0),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsViewRoute, 
              arguments: this.item.name
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image(image: AssetImage('assets/imgs/${this.item.name}.jpg'), fit: BoxFit.fill,)
              ),
              ListTile(
                title: montserratText(betterString(this.item.name), 22.0, FontWeight.w600),
                leading: montserratText("x${this.item.count}", 20.0, FontWeight.w300),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
