import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/favorite_model.dart';
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final iduser;
  final email;

  const FavoriteScreen({Key key, this.iduser, this.email}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Contents> contents = [];

  Future<List<FavoriteModel>> fetchFavoriteList() async {
    var url = Uri.parse(
        'http://35.213.159.134/myfavstore.php?myfavstore=${widget.iduser}');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List favoritecontent = json.decode(response.body);

        return favoritecontent.map((f) => FavoriteModel.fromJson(f)).toList();
      }
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Favorited',
            style: Theme.of(context).textTheme.bodyText1,
          ),
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
          )),
      body: Container(
        child: ListView(
          children: [
            // Text(widget.iduser.toString()),

            // fetch data from api
            FutureBuilder(
                future: fetchFavoriteList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FavoriteModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          FavoriteModel favorite = snapshot.data[index];

                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 130,
                              width: 375,
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                  top: 8, bottom: 4, left: 8, right: 8),
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 4, bottom: 4),
                              child: Row(
                                children: <Widget>[
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     height: 100,
                                  //     width: 100,
                                  //     decoration: BoxDecoration(
                                  //         image: DecorationImage(
                                  //             image: NetworkImage(
                                  //                 'http://35.213.159.134/uploadimages/${favcontent.image01}'),
                                  //             fit: BoxFit.cover)),
                                  //   ),
                                  // ),
                                  ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'http://35.213.159.134/uploadimages/${favorite.images01}',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.black12,
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            child: Text(
                                              favorite.category,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            favorite.title,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            favorite.author,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        final url = Uri.parse(
                                            'http://35.213.159.134/favinsert.php');
                                        final response =
                                            await http.post(url, body: {
                                          "iduserfav": widget.iduser.toString(),
                                          "fav": favorite.idcontent.toString(),
                                          "Status_Fav": "unfavorite",
                                        });

                                        if (response.statusCode == 200) {
                                          print('deleted favorited!');
                                        } else {
                                          print('failed');
                                        }
                                      } catch (e) {}
                                    },
                                    child: Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Colors.black,
                                      size: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Container(
                    padding: EdgeInsets.all(21.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('no favorited contents.'),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
