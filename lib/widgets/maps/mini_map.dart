import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:location/location.dart' as Loc;
import 'package:google_place/google_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMap extends StatefulWidget {
  MiniMap({Key? key}) : super(key: key);

  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late GoogleMapController _controller;

  Loc.Location _location = Loc.Location();
  LatLng _initLocation = LatLng(20.5937, 78.9629);
  Location _userLocation = Location(lat: 20.5937, lng: 78.9629);

  List<Marker> _markers = [];

  bool _searched = false;

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;

    this._location.onLocationChanged.listen(
      (loc) async {
        this._userLocation = Location(lat: loc.latitude, lng: loc.longitude);

        if (!this._searched) {
          this._controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(loc.latitude!, loc.longitude!), 
                zoom: 12
              )
            )
          );

          setState(() { this._searched = true; });
          await this._retrieveNearby();
        }
      }
    );
  }

  Future<void> _retrieveNearby() async {
    setState(() {
      this._markers.clear();
    });

    final baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];

    String url = '$baseURL?key=$apiKey&location=${this._userLocation.lat},${this._userLocation.lng}&radius=10000&keyword=${'hospital'}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      this._handleResponse(data);
    } else {
      print('An error has occured getting places nearby');
    }
  }

  void _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      print("REQUEST DENIED");
    } else if (data['status'] == 'OK') {
      List<dynamic> places = data['results'];
      for (int i = 0; i < places.length; i++) {
        double lat = places[i]['geometry']['location']['lat'];
        double lng = places[i]['geometry']['location']['lng'];
        String name = places[i]['name'];

        setState(
          () {
            this._markers.add(
              Marker(
                markerId: MarkerId(places[i]['place_id']),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: places[i]['vicinity']
                )
              )
            );
          }
        );

      }
    } else {
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        gestureRecognizers:[
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer()
          )
        ].toSet()
      ),
    );
  }
}