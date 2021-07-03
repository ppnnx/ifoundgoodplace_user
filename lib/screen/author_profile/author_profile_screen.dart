import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/follow_model.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthorProfileScreen extends StatefulWidget {
  final idauthor;
  final profileid;

  const AuthorProfileScreen({Key key, this.idauthor, this.profileid})
      : super(key: key);

  @override
  _AuthorProfileScreenState createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  List<User> users = [];
  bool isFollowing = false;
  String isFollow = '';

  // fetch author's data from api by author's id
  Future<List<User>> getAuthorData() async {
    var url = Uri.parse(
        'http://35.213.159.134/myprofile.php?profile=${widget.idauthor}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List author = json.decode(response.body);
      // print(author);

      return author.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('error');
    }
  }

  Future addFollowing() async {
    var url = Uri.parse('http://35.213.159.134/followinsert.php');

    try {
      var response = await http.post(url, body: {
        "iduser": widget.profileid.toString(),
        "follow": widget.idauthor.toString(),
        // 'Status_Fav': '1',
      });
      // print('iduser : ${widget.profileid}');
      // print('idauthor : ${widget.idauthor}');

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        setState(() {
          isFollow = result;
        });

        // if (result == '1') {
        //   setState(() {
        //     isFollow = result;
        //     isFollowing = true;
        //   });
        // } else if (result == '0') {
        //   setState(() {
        //     isFollow = result;
        //     isFollowing = false;
        //   });
        // }
      }
      // print(response.body);
    } catch (e) {}
  }

  buildProfileButton() {
    // check id login with id author
    if (widget.profileid == widget.idauthor) {
      return buildEditButton();
    } else if (widget.profileid != widget.idauthor ||
        widget.profileid == null) {
      return buildFollowBTN();
    }

    // else if (widget.profileid != widget.idauthor ||
    //     widget.profileid == null ||
    //     !isFollowing ||
    //     isFollow == '0') {
    //   return buildUnFollowBtn();
    // }
  }

  // handle about follow button
  handleFollowUser() {
    // check login if dont login , show alert login
    if (widget.profileid == null) {
      return showAlertLogin();
    } else {
      setState(() {
        isFollowing = !isFollowing;
      });
    }
  }

  handleUnfollowUser() {
    if (widget.profileid == null) {
      return showAlertLogin();
    } else {
      setState(() {
        isFollowing = false;
        isFollowing = !isFollowing;
      });
    }
  }

  // check login account following this account isn't ?
  checkFollowing() async {
    var url = Uri.parse(
        'http://35.213.159.134/followlist.php?followinglist=${widget.profileid}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var doc = json.decode(response.body);
      print(doc);
      // setState(() {
      //   isFollowing = true;
      // });
    } else {
      throw Exception('error');
    }
  }

  @override
  void initState() {
    super.initState();
    getAuthorData();
    // checkFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
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
        body: ListView(
          children: <Widget>[
            FutureBuilder(
                future: getAuthorData(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data[index];

                          return Center(
                            child: Container(
                              padding: EdgeInsets.only(top: 18.0),
                              child: Column(
                                children: <Widget>[
                                  // author's image
                                  user.image == null
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.face,
                                            size: 32,
                                            color: Colors.black,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              'http://35.213.159.134/uploadimages/${user.image}'),
                                        ),
                                  SizedBox(height: 24.0),

                                  // author's username
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 20),

                                  // author's follower + following
                                  buildfollow(
                                    user.following.toString(),
                                    user.follower.toString(),
                                  ),
                                  SizedBox(height: 20),

                                  buildProfileButton(),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ));
  }

  Widget buildEditButton() {
    return OutlinedButton(
      onPressed: () {
        print('edit profile button');
      },
      child: Text(
        "edit profile",
        style: TextStyle(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildfollow(String following, String follower) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            following,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 7),
          Text(
            'Following',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(width: 12),
          Text(
            follower,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 7),
          Text(
            'Followers',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildFollowButton(String text, Function function) {
    return ElevatedButton(
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
            color: isFollowing || isFollow == '1'
                ? Colors.white
                : Colors.blue.shade900),
      ),
      style: ElevatedButton.styleFrom(
        primary: isFollowing || isFollow == '1'
            ? Colors.blue.shade900
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.blue.shade900,
        ),
        minimumSize: Size(100, 40),
        elevation: 0.0,
      ),
    );
  }

  Widget buildFollowBtn() {
    return ElevatedButton(
      onPressed: () {
        handleFollowUser();
        addFollowing();
      },
      child: Text(
        'Follow',
        style: TextStyle(color: Colors.blue.shade900),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.blue.shade900,
        ),
        minimumSize: Size(100, 40),
        elevation: 0.0,
      ),
    );
  }

  Widget buildUnFollowBtn() {
    return ElevatedButton(
      onPressed: () {
        handleUnfollowUser();
        addFollowing();
      },
      child: Text(
        'UnFollow',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue.shade900,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.blue.shade900,
        ),
        minimumSize: Size(100, 40),
        elevation: 0.0,
      ),
    );
  }

  Widget buildFollowBTN() {
    return ElevatedButton(
      onPressed: () {
        handleFollowUser();
        addFollowing();
      },
      child: Text(
        isFollowing || isFollow == '1' ? 'Unfollow' : 'Follow',
        style: TextStyle(
            color: isFollowing || isFollow == '1'
                ? Colors.white
                : Colors.blue.shade900),
      ),
      style: ElevatedButton.styleFrom(
        primary: isFollowing || isFollow == '1'
            ? Colors.blue.shade900
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.blue.shade900,
        ),
        minimumSize: Size(100, 40),
        elevation: 0.0,
      ),
    );
  }

  Future<void> showAlertLogin() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            title: Icon(CupertinoIcons.exclamationmark_circle,
                color: Colors.blue.shade900, size: 44),
            content: Text(
              "Please Login before.",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }
}
