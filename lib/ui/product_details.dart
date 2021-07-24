import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discern/helpers/inventory_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:discern/widgets/maps/mini_map.dart';
import 'package:discern/providers/auth_provider.dart';
import 'package:discern/constants/route_constants.dart';
import 'package:discern/widgets/results/information.dart';

class ProductDetails extends StatefulWidget {
  final String itemType;
  ProductDetails({Key? key, required this.itemType}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthProvider.getUser().uid);

  @override
  void initState() { 
    super.initState();
  }

  Widget _actionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async { // add to inventory
        if (!AuthProvider.isLoggedIn()) {
          showDialog(
            context: context, 
            builder: (BuildContext context) => failAlert(context)
          );

          return;
        }
        
        updateInventory(widget.itemType, 1);
        
        Navigator.of(context).pushNamed(InventoryViewRoute);
      },
      child: Container(
        width: 60,
        height: 60,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF14D4D), Color(0xFFF87C7C)]
          )
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        widget.itemType,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 26,
            color: Color(0xFF454545),
            fontWeight: FontWeight.w300
          )
        ),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF454545)),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.pop(context);
        }
      ),
    );
  }

  Widget _buildImages() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Image(image: AssetImage('assets/imgs/${widget.itemType}.jpg'))
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF454545)
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._appBar(),
      floatingActionButton: this._actionButton(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              this._buildImages(),
              Information(itemType: widget.itemType),
              this._buildHeader('Disposal Locations'),
              MiniMap()
            ],
          ),
        ),
      ),
    );
  }
}
