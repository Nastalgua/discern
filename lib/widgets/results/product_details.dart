import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductDetails extends StatefulWidget {
  final String itemType;
  ProductDetails({Key? key, required this.itemType}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);


  Widget _actionButton() {
    return FloatingActionButton(
      onPressed: () {

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

  Widget _buildImages() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Image(image: AssetImage('assets/imgs/${widget.itemType}.jpg'))
    );
  }

  Widget _buildInformation() {
    return FutureBuilder(
      future: rootBundle.loadString('assets/information/${widget.itemType}.md'),
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

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Widget _buildMap(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
      height: MediaQuery.of(context).size.height * 0.75,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        gestureRecognizers: [
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer()
          )
        ].toSet()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._appBar(),
      floatingActionButton: this._actionButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              this._buildImages(),
              this._buildInformation(),
              this._buildHeader('Disposal Locations'),
              this._buildMap(context)
            ],
          ),
        ),
      ),
    );
  }
}
