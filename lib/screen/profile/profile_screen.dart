import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:ifgpdemo/screen/create/create_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final name;
  final id;

  const ProfileScreen({Key key, this.name, this.id}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<User> users = [];
  

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

  }

  @override
  void initState() {
    super.initState();
    fetchDataUser();
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
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MainScreen()));
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

      body: FutureBuilder(
        future: fetchDataUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
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
                          SizedBox(height: 24),

                          // username 
                          Text(user.username, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          SizedBox(height: 20),

                          // follower + following
                          buildfollow(user.following.toString(), user.follower.toString()),
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

      // body: ListView(
      //   physics: BouncingScrollPhysics(),
      //   children: [
      //     Center(
      //       child: Container(
      //         padding: EdgeInsets.only(top: 17.0),
      //         child: Column(
      //           children: <Widget>[
      //             buildImage(),

      //             // username + email
      //             Container(
      //               padding: EdgeInsets.only(top: 22.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: <Widget>[
      //                   Text(widget.name,
      //                       style: TextStyle(
      //                           fontSize: 17, fontWeight: FontWeight.w500)),
      //                   SizedBox(height: 20.0),
      //                   Text(widget.id.toString())
      //                 ],
      //               ),
      //             ),

      //             buildFollowList(),

      //             SizedBox(height: 25.0),

      //             buildEditButton(),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // )
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

  Widget buildLoginButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        print('login profile button');
      },
      child: Text(
        "Log in",
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
