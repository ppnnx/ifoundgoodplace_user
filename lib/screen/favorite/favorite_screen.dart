import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:http/http.dart' as http;

class FavoriteScreen extends StatefulWidget {
  final iduser;

  const FavoriteScreen({Key key, this.iduser}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Contents> contents = [];

  Future<List<Contents>> fetchFavoriteList() async {
    var url = Uri.parse(
        'http://35.213.159.134/myfavstore.php?myfavstore=${widget.iduser}');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List favoritecontent = json.decode(response.body);

        return favoritecontent.map((f) => Contents.fromJson(f)).toList();
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'favorite.',
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
              print('back');
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
                    AsyncSnapshot<List<Contents>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final favcontent = snapshot.data[index];

                          return Container(
                            height: 120,
                            width: 375,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 4),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'http://35.213.159.134/uploadimages/${favcontent.image01}'),
                                            fit: BoxFit.cover)),
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
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          child: Text(
                                            favcontent.category,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          favcontent.title,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        });
                  }

                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('No favorite contents.'),
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
