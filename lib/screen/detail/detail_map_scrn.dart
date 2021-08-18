import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailMapScreen extends StatefulWidget {
  final lat;
  final lng;

  const DetailMapScreen({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _DetailMapScreenState createState() => _DetailMapScreenState();
}

class _DetailMapScreenState extends State<DetailMapScreen> {
  Set<Marker> _marker = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.xmark,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.lat == null || widget.lng == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _marker.add(Marker(
                    markerId: MarkerId('id'),
                    position: LatLng(widget.lat, widget.lng),
                  ));
                });
              },
              markers: _marker,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.lng),
                zoom: 15,
              )),
    );
  }
}
