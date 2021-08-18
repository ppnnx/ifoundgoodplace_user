import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/mycontent_model.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:ifgpdemo/screen/create/create_screen.dart';
import 'package:ifgpdemo/screen/edit_profile/edit_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/profile/detail_second_screen.dart';

class ProfileScreen extends StatefulWidget {
  final id;
  final image;
  final email;

  const ProfileScreen({
    Key key,
    this.id,
    this.image,
    this.email,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<User>> fetchDataUser() async {
    var url =
        Uri.parse('http://35.213.159.134/myprofile.php?profile=${widget.id}');

    try {
      var response = await http.get(url);
      // print('user : ${response.body}');

      if (response.statusCode == 200) {
        final List profile = json.decode(response.body);

        return profile.map((users) => User.fromJson(users)).toList();
      }
    } catch (e) {}
    return null;
  }

  Future<List<MyContent>> getContents() async {
    var url =
        Uri.parse('http://35.213.159.134/mycontent.php?iduser=${widget.id}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List contentofuser = json.decode(response.body);

        return contentofuser.map((e) => MyContent.fromJson(e)).toList();
      }
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchDataUser();
    getContents();
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            print('add your content.');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateScreen(
                          idauthor: widget.id,
                        )));
          },
        ),
        body: Container(
          child: ListView(
            children: [
              FutureBuilder(
                future: fetchDataUser(),
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
                                  // image
                                  user.image == null || user.image == ''
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              AssetImage('assets/second.png'),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10000.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'http://35.213.159.134/avatar/${user.image}',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
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
                                  SizedBox(height: 24),

                                  // username
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 20),

                                  // follower + following
                                  buildfollow(user.following.toString(),
                                      user.follower.toString()),

                                  SizedBox(height: 20),

                                  buildButton(
                                      text: 'edit profile',
                                      onClicked: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                    user: snapshot.data[index],
                                                  )))),
                                  SizedBox(height: 20),

                                  Divider(color: Colors.black38),

                                  // user's content
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 16,
                                        top: 20,
                                        bottom: 10,
                                        right: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // header
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          child: Text.rich(
                                            TextSpan(
                                              text: '',
                                              style: TextStyle(fontSize: 15),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: user.username,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                TextSpan(
                                                  text: ' \'s articles.',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // Divider(
              //   color: Colors.black38,
              // ),

              // fetch content from api
              FutureBuilder(
                  future: getContents(),
                  builder: (context, AsyncSnapshot<List<MyContent>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            MyContent mycontent = snapshot.data[index];
                            return GestureDetector(
                              onTap: () {
                                if (mycontent.statusContent == "hidden") {
                                  return null;
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailSecond(
                                                mycontent: snapshot.data[index],
                                                userid: widget.id,
                                                useremail: widget.email,
                                                userimg: widget.image,
                                              )));
                                }
                              },
                              child: Container(
                                height: 180,
                                margin: EdgeInsets.only(
                                    bottom: 14, left: 12, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black54),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // image
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'http://35.213.159.134/uploadimages/${mycontent.images01}',
                                        width: 150,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: 150,
                                            height: 180,
                                            color: Colors.black12,
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // text
                                    Expanded(
                                      child: mycontent.statusContent == "hidden"
                                          ? Container(
                                              height: 180,
                                              color: Colors.grey.shade200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'This content was reported.',
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 4,
                                                        right: 4,
                                                        top: 3,
                                                        bottom: 3),
                                                    // color: Colors.amber,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Statement : ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Text(
                                                          mycontent.statement
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  mycontent.statusContent ==
                                                          "hidden"
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4,
                                                                  right: 4,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          child: Text(
                                                            'status content : unpublished',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                        )
                                                      : Text(' '),
                                                ],
                                              ))
                                          : Container(
                                              padding: EdgeInsets.only(
                                                  top: 12,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // category
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 5,
                                                                top: 2,
                                                                bottom: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          mycontent.category,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),

                                                      // if this content was reported - show tag
                                                      mycontent.statusReport ==
                                                              "reported"
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 2,
                                                                      bottom:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .amberAccent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2.0),
                                                              ),
                                                              child: Text(
                                                                mycontent
                                                                    .statusReport,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )
                                                          : Text(''),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  // title
                                                  Text(
                                                    mycontent.title,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Kanit',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        // favorite
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .heart_fill,
                                                              color: Colors
                                                                  .black38,
                                                              size: 16,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              mycontent
                                                                  .favorited
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(width: 14),
                                                        // comment
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .bubble_right_fill,
                                                              color: Colors
                                                                  .black38,
                                                              size: 16,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              mycontent.comment
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(width: 14),
                                                        // reads
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .eye,
                                                              color: Colors
                                                                  .black38,
                                                              size: 17,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              mycontent
                                                                  .counterread
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // date
                                                  // Text(
                                                  //   mycontent.dateContent,
                                                  //   style: TextStyle(
                                                  //       color: Colors.black,
                                                  //       fontSize: 12),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }

                    return Center(
                      child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('no content')),
                    );
                  }),
            ],
          ),
        ));
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

  // Widget buildPhoto() {
  //   final userItem = users.map((user) {
  //     final image01 = 'http://35.213.159.134/uploadimages/${user.image}';

  //     return CircleAvatar(
  //       radius: 50,
  //       backgroundImage: NetworkImage(image01),
  //     );
  //   }).toList();
  // }

  // Widget buildImage() {
  //   return CircleAvatar(
  //     radius: 50,
  //     backgroundColor: Colors.amber.shade100,
  //     child: Icon(
  //       Icons.face,
  //       size: 32,
  //       color: Colors.black,
  //     ),
  //   );
  // : CircleAvatar(
  //     radius: 50,
  //     backgroundImage: NetworkImage(
  //         'http://35.213.159.134/uploadimages/${users.image}'),
  //   );
  // }

  Widget buildFollowList() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '0',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Text(
            "Following",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(width: 16),
          Text(
            '0',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Text(
            "Followers",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    final String text,
    final VoidCallback onClicked,
  }) =>
      OutlinedButton(
        onPressed: onClicked,
        child: Text(
          text,
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

  Widget buildFollowButton() {
    return OutlinedButton(
      onPressed: () {},
      child: Text(
        "Follow",
        style: TextStyle(color: Colors.blue.shade900),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        side: BorderSide(
          color: Colors.blue.shade900,
        ),
      ),
    );
  }
}
