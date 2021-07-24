import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_place/google_place.dart';

import 'package:location/location.dart' as Loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductDetails extends StatefulWidget {
  final String itemType;
  ProductDetails({Key? key, required this.itemType}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late GoogleMapController _controller;
  List<Marker> _markers = [];

  LatLng _initLocation = LatLng(20.5937, 78.9629);
  Loc.Location _location = Loc.Location();
  Location _userLocation = Location(lat: 20.5937, lng: 78.9629);

  bool _searched = false;

  @override
  void initState() { 
    super.initState();
  }

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
    this._controller = controller;

    this._location.onLocationChanged.listen((loc) async {
      this._userLocation = Location(lat: loc.latitude, lng: loc.longitude);

      if (!this._searched) {
        this._controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(loc.latitude!, loc.longitude!))
          )
        );

        setState(() { this._searched = true; });
        await this._retrieveNearby();
      }

    });
  }

  Widget _buildMap(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
      height: MediaQuery.of(context).size.height * 0.75,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: this._initLocation),
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        markers: Set<Marker>.of(this._markers),
        gestureRecognizers: [
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer()
          )
        ].toSet()
      ),
    );
  }

  Future<void> _retrieveNearby() async {
    setState(() {
      this._markers = [];
    });

    final BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    final API_KEY = dotenv.env['GOOGLE_PLACES_API_KEY'];
  
    String url = 
      '$BASE_URL?key=$API_KEY&location=${this._userLocation.lat},${this._userLocation.lng}&radius=10000&keyword=${'hospital'}';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      this._handleResponse(data);
    } else {
      print('An error has occured getting places nearby');
    }
  }

  void _handleResponse(data) {
    if (data['status'] == 'OK') {
      List<dynamic> places = data['results'];
      for (int i = 0; i < places.length; i++) {

        double lat = places[i]['geometry']['location']['lat'];
        double lng = places[i]['geometry']['location']['lng'];
        String name = places[i]['name'];

        print(lat);
        print(lng);
        print(name);
        print(places);

        setState(() {
          this._markers.add(
            Marker(
              markerId: MarkerId(places[i]['place_id']),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name,
                snippet: places[i]['vicinity']
              ),
              onTap: () {
                print('name');
              }
            )
          );
        });

      }
    }
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
