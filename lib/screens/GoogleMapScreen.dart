import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({@required this.title, this.index});

  final title;
  final index;

  @override
  State<StatefulWidget> createState() => _googleMapScreen();
}

class _googleMapScreen extends State<GoogleMapScreen> {
  GoogleMapController googleMapController;
  var location = new Location();
  Map<String, double> userLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    this.googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Hero(
        tag: "link_${widget.index}",
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
              target: userLocation == null
                  ? _center
                  : LatLng(userLocation["latitude"], userLocation["longitude"]),
              zoom: 11.0),
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          compassEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          markers: _markers,
        ),
      ),
    );
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = (await location.getLocation()) as Map<String, double>;
      userLocation = currentLocation;
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
