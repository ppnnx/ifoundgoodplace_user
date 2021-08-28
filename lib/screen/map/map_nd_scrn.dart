import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';

class MapSCRN extends StatefulWidget {
  final idlogin;
  final email;

  const MapSCRN({Key key, this.idlogin, this.email}) : super(key: key);

  @override
  _MapSCRNState createState() => _MapSCRNState();
}

class _MapSCRNState extends State<MapSCRN> {
  GoogleMapController _controller;
  PageController _pagecontroller;
  double lat;
  double lng;

  List<Marker> allmarkers = [];
  List<Contents> contents = [];

  int prevPage;

  // fetch lat/lng from api
  Future<List<Contents>> fetchLatLng() async {
    try {
      final url = Uri.parse('http://35.213.159.134/ctall.php?home');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List alldata = json.decode(response.body);
        return alldata.map((e) => Contents.fromJson(e)).toList();
      } else {
        print('Failed!');
      }
    } catch (e) {}
    return [];
  }

  Future<Null> findLatLng() async {
    // print('findLatLng is work!');
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('Your Location : Lat = $lat , Lng = $lng');
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

  @override
  void initState() {
    super.initState();
    findLatLng();
    fetchLatLng().then((value) {
      setState(() {
        contents = value;
      });
      // print('______# contents : ${contents.length}');
      contents.forEach((element) {
        allmarkers.add(Marker(
            markerId: MarkerId(element.idcontent.toString()),
            draggable: false,
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
              title: element.title,
              snippet: element.username,
            )));
      });
      // print('______# markers : ${allmarkers.length}');
    });
    _pagecontroller = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pagecontroller.page.toInt() != prevPage) {
      prevPage = _pagecontroller.page.toInt();
      moveCamera();
    }
  }

  _contentList(index) {
    var content = contents[index];
    return AnimatedBuilder(
      animation: _pagecontroller,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pagecontroller.position.haveDimensions) {
          value = _pagecontroller.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // moveCamera();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailSCRN(
                        contents: content,
                        idcontent: content.idcontent,
                        iduser: widget.idlogin,
                        emailuser: widget.email,
                      )));
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                height: 160.0,
                width: 275.0,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0)
                ]),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl:
                              'http://35.213.159.134/uploadimages/${content.image01}',
                          height: 90.0,
                          width: 90.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 90.0,
                              width: 90.0,
                              color: Colors.black12,
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.title,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              content.username,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // bookmark
                                      Icon(
                                        CupertinoIcons.bookmark_fill,
                                        color: Colors.black38,
                                        size: 13,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        content.save.toString(),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      // favorite
                                      Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.black38,
                                        size: 14,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        content.favorite.toString(),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(width: 12),

                                      // read
                                      Icon(
                                        CupertinoIcons.eye_fill,
                                        color: Colors.black38,
                                        size: 14,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        content.counterread.toString(),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
      body: Stack(
        children: <Widget>[
          // components
          lat == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 7.0,
                    ),
                    mapType: MapType.normal,
                    markers: Set.from(allmarkers),
                    onMapCreated: mapcreated,
                  ),
                ),
          Positioned(
              bottom: 20.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pagecontroller,
                  itemCount: allmarkers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _contentList(index);
                  },
                ),
              )),
        ],
      ),
    );
  }

  void mapcreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(contents[_pagecontroller.page.toInt()].latitude,
              contents[_pagecontroller.page.toInt()].longitude),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0),
    ));
  }
}
