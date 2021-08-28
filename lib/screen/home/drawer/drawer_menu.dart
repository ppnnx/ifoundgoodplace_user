import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/bookmark/bookmark_db_screen.dart';
import 'package:ifgpdemo/screen/favorite/favorite_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';

import '../home_screen.dart';

class MenuDrawer extends StatefulWidget {
  final iduser;
  final emailuser;
  final username;

  const MenuDrawer({Key key, this.iduser, this.emailuser, this.username})
      : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  id: widget.iduser,
                                  email: widget.emailuser,
                                )));
                  },
                  leading: Icon(
                    Icons.face,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookMarkDBScreen(
                                  iduser: widget.iduser,
                                  username: widget.username,
                                )));
                  },
                  leading: Icon(
                    CupertinoIcons.bookmark,
                    color: Colors.black,
                    size: 19,
                  ),
                  title: Text(
                    "Bookmark",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteScreen(
                                  iduser: widget.iduser,
                                )));
                  },
                  leading: Icon(
                    CupertinoIcons.heart,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    "Favorite",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.black),
          Container(
            padding: EdgeInsets.all(14.0),
            child: ListTile(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
              leading: Icon(
                CupertinoIcons.square_arrow_right,
                color: Colors.black,
                size: 20,
              ),
              title: Text(
                "Log out",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
