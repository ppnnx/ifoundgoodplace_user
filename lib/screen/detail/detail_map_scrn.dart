import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailMapScreen extends StatefulWidget {
  final lat;
  final lng;
  final title;

  const DetailMapScreen({Key? key, this.lat, this.lng, this.title})
      : super(key: key);

  @override
  _DetailMapScreenState createState() => _DetailMapScreenState();
}

class _DetailMapScreenState extends State<DetailMapScreen> {
  double? lat;
  double? lng;
  Set<Marker> _marker = {};

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location is Open');

      // check permission location
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(context, 'Share your location is close',
              'Please open share your location');
        } else {
          // find lat lng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(context, 'Location Service is not allow',
              'Please allow location service in setting');
        } else {
          // find lat lng
          findLatLng();
        }
      }
    } else {
      print('Service Location is Close');
      alertLocationService(context, 'Location Service is not allow',
          'Please allow location service in setting');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng is work!');
    Position? position = await findPosition();
    //setState(() {
    // lat = position!.latitude;
    // lng = position.longitude;
    // print('Lat = $lat , Lng = $lng');
    //});
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

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
                      infoWindow: InfoWindow(
                        title: widget.title,
                      )));
                });
              },
              markers: _marker,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.lng),
                zoom: 15,
              )),
    );
  }

  alertLocationService(BuildContext context, String title, String subtitle) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  // Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                  exit(0);
                },
                child: Text('OK'))
          ],
        ),
      );
}
