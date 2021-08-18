import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/bookmark/bookmark_db_screen.dart';
import 'package:ifgpdemo/screen/bookmark/bookmark_db_scrn.dart';
import 'package:ifgpdemo/screen/bookmark/second_screen.dart';
import 'package:ifgpdemo/screen/favorite/favorite_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';

class Header extends StatefulWidget {
  final useridlogin;

  const Header({Key key, this.useridlogin}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Header> {
  List<User> users = [];
  // int id;
  // String username;
  // String email;

  // check login already
  // Future checklogin() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     id = preferences.getInt('id');
  //     username = preferences.getString('username');
  //     email = preferences.getString('email');
  //   });
  // }

  // api fetch user data
  Future<List<User>> fetchdatauser() async {
    try {
      final url = Uri.parse(
          'http://35.213.159.134/myprofile.php?profile=${widget.useridlogin}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // print('api for drawer worked');
        final List users = json.decode(response.body);
        return users.map((e) => User.fromJson(e)).toList();
      } else {
        print('api for drawer failed');
      }
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchdatauser(),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data[index];

                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // space for display + username + email
                        Container(
                          height: 200,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 34, horizontal: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // display
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10000.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'http://35.213.159.134/avatar/${user.image}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 12),

                                // username + email
                                Container(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          user.email,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )),
                                // SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                        // list menu
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.face,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (_) => Profile(
                                  //           iduser: user.iduser,
                                  //         )));

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                                id: user.iduser,
                                                image: user.image,
                                                email: user.email,
                                              )));
                                },
                              ),
                              SizedBox(height: 5),
                              ListTile(
                                leading: Icon(
                                  CupertinoIcons.bookmark,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                title: Text('Save',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookMarkDBScreen(
                                                iduser: user.iduser,
                                                username: user.username,
                                              )));
                                },
                              ),
                              SizedBox(height: 5),
                              ListTile(
                                leading: Icon(
                                  CupertinoIcons.heart,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                title: Text('Favorite',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavoriteScreen(
                                                iduser: user.iduser,
                                              )));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(21.0),
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
