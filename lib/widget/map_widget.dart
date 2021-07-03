import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  // LatLng latLng = LatLng(18.810570, 98.952657);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(18.810570, 98.952657),
    zoom: 16.0,
  );
  // set initial position (center / start point) of map.

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      height: 450,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
      ),
    );
  }
}
