import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';

class AuthorProfileScreen extends StatefulWidget {
  final idauthor;
  final profileid;
  final nameauthor;
  final useremail;

  const AuthorProfileScreen(
      {Key? key,
      this.idauthor,
      this.profileid,
      this.nameauthor,
      this.useremail})
      : super(key: key);

  @override
  _AuthorProfileScreenState createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  List<User> users = [];
  bool isFollowing = false;

  // fetch author's data from api by author's id
  Future<List<User>?> getAuthorData() async {
    var url = Uri.parse(
        'http://35.213.159.134/myprofile.php?profile=${widget.idauthor}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List author = json.decode(response.body);
        // print(author);

        return author.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('error');
      }
    } catch (e) {}
    return null;
  }

  // fetch author's contents from api
  Future<List<Contents>?> getContents() async {
    var url = Uri.parse(
        'http://35.213.159.134/mycontent.php?iduser=${widget.idauthor}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List contentofuser = json.decode(response.body);

        return contentofuser.map((e) => Contents.fromJson(e)).toList();
      }
    } catch (e) {}
    return null;
  }

  Future getFollow() async {
    try {
      final url = Uri.parse('http://35.213.159.134/followinsert.php');
      final response = await http.post(url, body: {
        "iduser": widget.profileid.toString(),
        "follow": widget.idauthor.toString(),
        "Status_follow": "followed",
      });

      if (response.statusCode == 200) {
        print('following this user!');
        // var result = json.decode(response.body);

        // if (result == "result_follow is true") {
        //   print('following!');
        //   setState(() {
        //     isFollowing = true;
        //   });
        // } else if (result == "result_unfollow is true") {
        //   print('unfollow!');
        //   setState(() {
        //     isFollowing = false;
        //   });
        // }
      } else {
        print('cant follow this account');
      }
    } catch (e) {}
  }

  // checkFollow() async {
  //   try {
  //     final url = Uri.parse(
  //         "http://35.213.159.134/followlist.php?followerlist=&followinglist=${widget.profileid}");
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final List following = json.decode(response.body);
  //       return following.map((e) => User.fromJson(e)).toList();
  //     }
  //   } catch (e) {}
  // }

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
                builder: (BuildContext context,
                    AsyncSnapshot<List<User>?> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];

                          return Center(
                            child: Container(
                              padding: EdgeInsets.only(top: 18.0),
                              child: Column(
                                children: <Widget>[
                                  // author's image
                                  user.image == null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              AssetImage('assets/second.png'),
                                          radius: 40,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000.0),
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
                                  SizedBox(height: 24.0),

                                  // author's username
                                  Text(
                                    user.username!,
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

                                  // follow button
                                  // buildBTNFollow(),
                                  buildFollowButton(),
                                  SizedBox(height: 20),
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
            Divider(
              color: Colors.black,
            ),

            // user's content
            Container(
              padding:
                  EdgeInsets.only(left: 16, top: 20, bottom: 10, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            text: widget.nameauthor,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
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

                  // fetch data from api
                  FutureBuilder(
                      future: getContents(),
                      builder:
                          (context, AsyncSnapshot<List<Contents>?> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final mycontent = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailSCRN(
                                                  contents:
                                                      snapshot.data![index],
                                                  emailuser: widget.useremail,
                                                  iduser: widget.profileid,
                                                  count:
                                                      mycontent.counterread! +
                                                          1,
                                                )));
                                  },
                                  child: Container(
                                    height: 180,
                                    margin: EdgeInsets.only(bottom: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black54),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        // image
                                        ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'http://35.213.159.134/uploadimages/${mycontent.image01}',
                                            width: 150,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
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

                                        Expanded(
                                          child: Container(
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
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    mycontent.category!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                // title
                                                Text(
                                                  mycontent.title!,
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
                                                            color:
                                                                Colors.black38,
                                                            size: 16,
                                                          ),
                                                          SizedBox(width: 7),
                                                          Text(
                                                            mycontent.favorite
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
                                                            color:
                                                                Colors.black38,
                                                            size: 16,
                                                          ),
                                                          SizedBox(width: 7),
                                                          Text(
                                                            mycontent.comments
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
                                                            CupertinoIcons.eye,
                                                            color:
                                                                Colors.black38,
                                                            size: 17,
                                                          ),
                                                          SizedBox(width: 7),
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
                          child: Text('No contents'),
                        );
                      }),
                ],
              ),
            ),
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

  // Widget buildBTNFollow() {
  //   if (isFollowing) {
  //     return ElevatedButton(
  //       onPressed: () {},
  //       child: Text(
  //         'Follow',
  //         style: TextStyle(
  //           color: Colors.blue.shade900,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         primary: Colors.white,
  //         elevation: 0.0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(24.0)),
  //         ),
  //         side: BorderSide(
  //           color: Colors.blue.shade900,
  //         ),
  //       ),
  //     );
  //   } else if (!isFollowing) {
  //     return ElevatedButton(
  //       onPressed: () {},
  //       child: Text(
  //         'Unfollow',
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         primary: Colors.blue.shade900,
  //         elevation: 0.0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(24.0)),
  //         ),
  //         side: BorderSide(
  //           color: Colors.blue.shade900,
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget buildFollowButton() {
    return ElevatedButton(
        onPressed: () {
          if (widget.profileid == null) {
            return showAlertLogin();
          }
          setState(() {
            isFollowing = !isFollowing;
            getFollow();
          });
        },
        child: Text(
          isFollowing == false ? 'Follow' : 'Unfollow',
          style: TextStyle(
            color: isFollowing == false ? Colors.blue.shade900 : Colors.white,
          ),
        ),
        style: isFollowing == false
            ? ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
                side: BorderSide(
                  color: Colors.blue.shade900,
                ),
              )
            : ElevatedButton.styleFrom(
                primary: Colors.blue.shade900,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
                side: BorderSide(
                  color: Colors.blue.shade900,
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

  showAlertLogin() async {
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
