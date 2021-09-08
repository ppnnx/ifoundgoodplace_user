import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_map_scrn.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkDetail extends StatefulWidget {
  final iduser;
  final idcontent;

  const BookmarkDetail({Key? key, this.idcontent, this.iduser})
      : super(key: key);

  @override
  _BookmarkDetailState createState() => _BookmarkDetailState();
}

class _BookmarkDetailState extends State<BookmarkDetail> {
  int _current = 0;

  // fetch content from api
  Future<List<Contents>> fetchbookmarked() async {
    try {
      final url = Uri.parse("http://35.213.159.134/ctshow.php");
      final response = await http.post(url, body: {
        "ID_Content": widget.idcontent.toString(),
      });

      if (response.statusCode == 200) {
        final List bookmarked = json.decode(response.body);
        return bookmarked.map((json) => Contents.fromJson(json)).toList();
      } else {
        print("API FETCH BOOKMARKED CONTENT FAILED");
      }
    } catch (e) {}
    return [];
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchbookmarked();
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
            size: 19,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.bookmark_fill,
              color: Colors.black,
              size: 17,
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
              print("delete this bookmark");
              EasyLoading.showSuccess("deleted this bookmark");
              await Future.delayed(Duration(milliseconds: 1000));
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: fetchbookmarked(),
            builder: (context, AsyncSnapshot<List<Contents>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Contents bookmarked = snapshot.data![index];

                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // part 1 : header => date / author / category
                          Container(
                            padding: EdgeInsets.all(21.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // date
                                Text(
                                  bookmarked.dateContent!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                // author
                                Text(
                                  bookmarked.username!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),

                                // category
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    bookmarked.category!.toLowerCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 100),

                          // part 2 : middle => title / story / location / link
                          // title
                          Container(
                            padding: EdgeInsets.all(21.0),
                            child: Text(
                              bookmarked.title!,
                              style:
                                  TextStyle(fontFamily: 'Kanit', fontSize: 24),
                            ),
                          ),

                          // images
                          showimages(bookmarked),
                          SizedBox(height: 60),

                          // story
                          Container(
                            padding: EdgeInsets.all(21.0),
                            child: Text(
                              bookmarked.content!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 80),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // location
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailMapScreen(
                                                  lat: bookmarked.latitude,
                                                  lng: bookmarked.longitude,
                                                  title: bookmarked.title,
                                                )));
                                  },
                                  child: Icon(
                                    CupertinoIcons.placemark,
                                    color: Colors.white,
                                    size: 21,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF7EB5A6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation: 0.0),
                                ),
                                SizedBox(width: 10),
                                // link
                                bookmarked.link == null ||
                                        bookmarked.link == " "
                                    ? Text('')
                                    : ElevatedButton(
                                        onPressed: () {
                                          _launchURL(bookmarked.link!);
                                        },
                                        child: Icon(
                                          CupertinoIcons.play_fill,
                                          color: Colors.white,
                                          size: 21,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFFF2442),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            elevation: 0.0),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(height: 70),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // images
  Widget showimages(Contents contents) {
    List images = [
      'http://35.213.159.134/uploadimages/${contents.image01}',
      'http://35.213.159.134/uploadimages/${contents.image02}',
      'http://35.213.159.134/uploadimages/${contents.image03}',
      'http://35.213.159.134/uploadimages/${contents.image04}',
    ];

    return Container(
      child: Column(
        children: [
          CarouselSlider(
            items: images.map(
              (imgUrl) {
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
              },
            ).toList(),
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
            ),
          ),
          SizedBox(height: 16),

          // dot (indicatior)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map(
              (url) {
                int index = images.indexOf(url);

                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    color: _current == index ? Colors.black : Colors.white,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
