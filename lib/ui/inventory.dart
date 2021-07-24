import 'package:discern/widgets/font_text.dart';
import 'package:flutter/material.dart';

import 'package:discern/providers/auth_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  late DocumentReference _userReference;
  late Stream<DocumentSnapshot<Object?>> _userStream;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final inventory = snapshot.data?['inventory'];

        // print(inventory);

        return Scaffold(
          appBar: this._buildAppBar(context)
        );
        
      }
    );
  }
}
