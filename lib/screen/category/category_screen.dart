import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/model/content_trending_model.dart';
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';
import 'package:ifgpdemo/screen/detail/detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final name;
  final idcategory;
  final userid;
  final useremail;
  final userimg;

  const CategoryScreen(
      {Key key,
      this.idcategory,
      this.name,
      this.userid,
      this.useremail,
      this.userimg})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Categories> category = [];
  List<Contents> content = [];
  List<TrendingModel> trending = [];

  Future<List<Contents>> getContentbyCate() async {
    var url = Uri.parse(
        'http://35.213.159.134/searchbycategory.php?searchbycategory=${widget.idcategory}');
    try {
      var response = await http.get(url);
      // print('content : ${response.body}');

      if (response.statusCode == 200) {
        final List contentbycate = json.decode(response.body);

        return contentbycate
            .map((contbycate) => Contents.fromJson(contbycate))
            .toList();
      }
    } catch (e) {}
    return null;
  }

  Future<List<Contents>> getTrendingContentbyCategory() async {
    var url = Uri.parse(
        'http://35.213.159.134/rankingbycategory.php?rankbycategory=${widget.idcategory}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List trendingcontentbycate = json.decode(response.body);

        return trendingcontentbycate
            .map((data) => Contents.fromJson(data))
            .toList();
      }
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    getContentbyCate();
    getTrendingContentbyCategory();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Text(
              widget.name,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_backspace,
                color: Color(0xFF41444b),
                size: 21,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorPadding: EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(54.0),
                color: Colors.black,
              ),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LATEST"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("TOP CHART"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // tab 1 : latest contents
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: FutureBuilder(
                    future: getContentbyCate(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Contents>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final catecont = snapshot.data[index];

                              return GestureDetector(
                                child: buildContentbyCate(catecont),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                                content: catecont,
                                                userId: widget.userid,
                                                userEmail: widget.useremail,
                                                userImage: widget.userimg,
                                                count: catecont.counterread++,
                                              )));
                                },
                              );
                            });
                      }
                      return Center(
                        child: Text('no content in this category'),
                      );
                    }),
              ),

              // tab 2 : top chart contents
              ListView(
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(
                    //   top: 32.0,
                    // ),
                    padding: EdgeInsets.only(top: 32, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Container(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 26, vertical: 10),
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(24.0),
                        //         border: Border.all(color: Colors.black)),
                        //     child: Text('Top Chart',
                        //         style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 21,
                        //             fontWeight: FontWeight.bold))),
                        // SizedBox(height: 24.0),

                        // fetch data from api
                        FutureBuilder(
                            future: getTrendingContentbyCategory(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Contents>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext _, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailSCRN(
                                                        contents: snapshot
                                                            .data[index],
                                                        iduser: widget.userid,
                                                        emailuser:
                                                            widget.useremail,
                                                        idcontent: snapshot
                                                            .data[index]
                                                            .idcontent,
                                                        count: snapshot
                                                            .data[index]
                                                            .counterread++,
                                                      )));
                                        },
                                        child: TrendingWidget(
                                          rank: index + 1,
                                          data: snapshot.data[index],
                                        ),
                                      );
                                    });
                              }
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('no chart.'),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContentbyCate(Contents contents) {
    return Container(
      child: Column(
        children: [
          Container(
            // color: Colors.white,
            // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            padding: EdgeInsets.only(left: 18, right: 18, top: 10),
            child: Row(
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'http://35.213.159.134/uploadimages/${contents.image01}',
                    height: 80,
                    width: 80,
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
                SizedBox(width: 22),

                // all text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        contents.title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // counter read + author(username)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundColor: Colors.amber,
                                //   radius: 13,
                                // ),
                                // SizedBox(width: 10),
                                Text(
                                  contents.username,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }

  // Widget buildHead(String namecategory) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 37, top: 40, bottom: 20),
  //     child: Text(
  //       namecategory,
  //       style: TextStyle(
  //         fontSize: 24,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
}

class TrendingWidget extends StatelessWidget {
  final int rank;
  final Contents data;

  const TrendingWidget({Key key, this.rank, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 375,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: EdgeInsets.only(left: 22, right: 16, top: 10, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                '$rank',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.title,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: 7),
                  Text(
                    data.username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.book,
                        color: Colors.black,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        data.counterread.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              )),
          SizedBox(width: 18),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl:
                          'http://35.213.159.134/uploadimages/${data.image01}',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          height: 80,
                          width: 80,
                          color: Colors.black12,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
