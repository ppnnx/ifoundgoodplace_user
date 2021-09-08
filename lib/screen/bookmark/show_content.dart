import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifgpdemo/db/db_provider.dart';
import 'package:http/http.dart' as http;

class ShowContent extends StatefulWidget {
  final id;
  final iduser;
  final idauthor;
  final author;
  final idcontent;
  final datecontent;
  final title;
  final category;
  final story;
  final link;
  final lat;
  final lng;
  final read;
  final img01;
  final img02;
  final img03;
  final img04;
  final favorite;
  final save;
  final comment;
  final share;

  const ShowContent(
      {Key? key,
      this.id,
      this.iduser,
      this.idauthor,
      this.author,
      this.idcontent,
      this.datecontent,
      this.title,
      this.category,
      this.story,
      this.link,
      this.lat,
      this.lng,
      this.read,
      this.img01,
      this.img02,
      this.img03,
      this.img04,
      this.favorite,
      this.save,
      this.comment,
      this.share})
      : super(key: key);

  @override
  _ShowContentState createState() => _ShowContentState();
}

class _ShowContentState extends State<ShowContent> {
  int _current = 0;
  Set<Marker> _marker = {};

  // set marker for map
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _marker.add(Marker(
        markerId: MarkerId('id'),
        position: LatLng(widget.lat, widget.lng),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    List images = [
      'http://35.213.159.134/uploadimages/${widget.img01}',
      'http://35.213.159.134/uploadimages/${widget.img02}',
      'http://35.213.159.134/uploadimages/${widget.img03}',
      'http://35.213.159.134/uploadimages/${widget.img04}',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 21,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        // title: Text(
        //   widget.idcontent.toString(),
        //   style: TextStyle(color: Colors.black, fontSize: 12),
        // ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                CupertinoIcons.bookmark_fill,
                color: Colors.black,
                size: 16,
              ),
              onPressed: () async {
                try {
                  final url = Uri.parse('http://35.213.159.134/saveinsert.php');
                  final response = await http.post(url, body: {
                    "idusersave": widget.iduser.toString(),
                    "save": widget.idcontent.toString(),
                    "Status_Save": 'unsave',
                  });
                  if (response.statusCode == 200) {
                    print('deleted bookmark!');
                  } else {
                    print('failed');
                  }
                } catch (e) {}
                DatabaseProvider.db.delete(widget.id);
                Navigator.of(context).pop();
              })
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // date
                      Text(
                        widget.datecontent,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.author,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 6, right: 6, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          widget.category,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),

                // title
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontFamily: 'Kanit', fontSize: 24),
                  ),
                ),

                // images
                Container(
                  child: Column(
                    children: [
                      CarouselSlider(
                          items: images.map((imgUrl) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                imageUrl: imgUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Container(
                                    height: 300.0,
                                    color: Colors.black12,
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 300.0,
                            initialPage: 0,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          )),
                      SizedBox(height: 16),

                      // dot (indicatior)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.map((url) {
                          int index = images.indexOf(url);

                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Colors.black
                                  : Colors.grey.shade400,
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 60),

                // content
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.story,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(height: 80),

                // location
                widget.lat == null && widget.lng == null
                    ? Text(' ')
                    : Container(
                        margin: EdgeInsets.all(10.0),
                        height: 300,
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            markers: _marker,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.lat, widget.lng),
                              zoom: 15,
                            )),
                      ),
                SizedBox(height: 70),

                // show all total
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // favorite
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(widget.favorite.toString()),
                          ],
                        ),
                      ),
                      // bookmark
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.bookmark_fill,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.save.toString()),
                          ],
                        ),
                      ),
                      // share
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.share.toString()),
                          ],
                        ),
                      ),
                      // count read
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.eye,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.read.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openRemoveBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0))),
            contentPadding: EdgeInsets.only(top: 15.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     //     Text(
                  //     //       "Remove from list",
                  //     //       style: TextStyle(
                  //     //           fontSize: 18.0, fontWeight: FontWeight.w500),
                  //     //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 30.0),
                    child: Center(
                      child: Text(
                        "Remove from list",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0)),
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
