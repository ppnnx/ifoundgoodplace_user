import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final name;
  final idcategory;
  final userid;
  final useremail;
  final userimg;

  const CategoryScreen(
      {Key key, this.idcategory, this.name, this.userid, this.useremail, this.userimg})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Categories> category = [];
  List<Contents> content = [];

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
  }

  @override
  void initState() {
    super.initState();
    getContentbyCate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: FutureBuilder(
          future: getContentbyCate(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Contents>> snapshot) {
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
                                    )));
                      },
                    );
                  });
            }

            return Center(
              child: Text('no content in this category.'),
            );
          }),
    );
  }

  Widget buildContentbyCate(Contents contents) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 10),
            child: Row(
              children: [
                // image
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'http://35.213.159.134/uploadimages/${contents.image01}'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 22),

                // all text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // catergory
                      // Container(
                      //   padding:
                      //       EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black,
                      //     borderRadius: BorderRadius.circular(14.0),
                      //     // border: Border.all(color: Colors.black),
                      //   ),
                      //   child: Text(
                      //     contents.category,
                      //     style: TextStyle(color: Colors.white, fontSize: 10),
                      //   ),
                      // ),
                      // SizedBox(height: 8),

                      // title
                      Text(
                        contents.title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // date
                      // Text(
                      //   contents.dateContent,
                      //   style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      // ),

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
                          // Container(
                          //   child: Row(
                          //   children: [
                          //     Icon(
                          //       CupertinoIcons.eye_fill,
                          //       color: Colors.black.withOpacity(0.8),
                          //       size: 19,
                          //     ),
                          //     SizedBox(width: 5),
                          //     Text(
                          //       contents.counterread.toString(),
                          //       style: TextStyle(
                          //           color: Colors.black.withOpacity(0.8),
                          //           fontSize: 14),
                          //     )
                          //   ],
                          // )),
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
