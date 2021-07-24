import 'package:discern/helpers/inventory_management.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:discern/helpers/font_text.dart';
import 'package:discern/models/inventory_item.dart';
import 'package:discern/widgets/inventory/item.dart';
import 'package:discern/providers/auth_provider.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  late DocumentReference _userReference;
  late Stream<DocumentSnapshot<Object?>> _userStream;
  late List<InventoryItem> _inventory;

  @override
  void initState() {
    super.initState();

    this._userReference = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthProvider.getUser().uid);
    
    this._userStream = _userReference.snapshots();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: montserratText('Inventory', 26, FontWeight.w300, color: Color(0xFF454545)),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF454545)),
        onPressed: () {
          Navigator.pop(context);
        }
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        padding: EdgeInsets.only(top: 25),
        itemBuilder: (context, index) => Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: new Item(
                item: this._inventory[index]
              )
            ),
            Positioned(

              right: 0,
              child: RawMaterialButton(
                onPressed: () {
                  updateInventory(this._inventory[index].name, -1);
                },
                elevation: 2.0,
                fillColor: Colors.red,
                child: Icon(
                  Icons.delete,
                  size: 30.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            )
          ]
        ),
        separatorBuilder: (context, index) => Divider(
          height: 25,
        ),
        itemCount: this._inventory.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._buildAppBar(context),
      backgroundColor: Color(0xFFf7f7f7),
      body: StreamBuilder(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final inventory = snapshot.data?['inventory'];
          this._inventory = (inventory as List<dynamic>).map(
            (e) => InventoryItem.fromJSON(e)
          ).toList();

          return this._buildItems(context);
        
        }
      ),
    );
  }
}
