import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifgpdemo/model/content_model.dart';

class MapWidget extends StatefulWidget {
  final Contents? contents;

  const MapWidget({Key? key, this.contents}) : super(key: key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 450,
        // child: GoogleMap(
        //   myLocationButtonEnabled: false,
        //   zoomControlsEnabled: false,

        // ),
        );
  }
}
