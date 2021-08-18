import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double lat;
  double lng;

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
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('Lat = $lat , Lng = $lng');
    });
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {}
    return null;
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: 'you are here.', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();

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
        title: Text(
          'map.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: lat == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
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
