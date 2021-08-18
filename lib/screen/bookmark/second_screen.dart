import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/save_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/user_model.dart';
import 'package:ifgpdemo/service/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget {
  final userid;

  const SecondScreen({Key key, this.userid}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  User user = User();
  // fetch save list from api
  Future<List<SaveModel>> fetchSaveList() async {
    try {
      final url = Uri.parse(
          'http://35.213.159.134/mysavestore.php?mysavestore=${widget.userid}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('API WORKED!');
        final List saveList = json.decode(response.body);
        return saveList.map((e) => SaveModel.fromJson(e)).toList();
      } else {
        print('FAILED');
      }
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchSaveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Saved',
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
      body: ListView(
        children: [
          // fetch data to show
          FutureBuilder(
              future: fetchSaveList(),
              builder: (context, AsyncSnapshot<List<SaveModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        SaveModel save = snapshot.data[index];

                        return Container(
                          height: 130,
                          width: 375,
                          color: Colors.white,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 4, bottom: 4),
                          child: Row(
                            children: [
                              // image
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://35.213.159.134/uploadimages/${save.images01}',
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
                              // title + category + author
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // category
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                    child: Text(
                                      save.category,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  // title
                                  Text(
                                    save.title,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  SizedBox(height: 7),
                                  // author
                                  Text(
                                    save.author,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              )),
                              SizedBox(width: 15),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    final url = Uri.parse(
                                        'http://35.213.159.134/saveinsert.php');
                                    final response =
                                        await http.post(url, body: {
                                      "idusersave": widget.userid.toString(),
                                      "save": save.idcontent.toString(),
                                      "Status_Save": 'unsave',
                                    });
                                    if (response.statusCode == 200) {
                                      print('deleted bookmark!');
                                    } else {
                                      print('failed');
                                    }
                                  } catch (e) {}
                                  print('delete bookmarked content');
                                },
                                child: Icon(
                                  CupertinoIcons.bookmark_fill,
                                  color: Colors.black,
                                  size: 17,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }

                return Container(
                  padding: EdgeInsets.all(21.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text('no saved contents.')],
                  ),
                );
              })
        ],
      ),
    );
  }
}
