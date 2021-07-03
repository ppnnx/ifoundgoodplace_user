import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';

class ProfileWidget extends StatelessWidget {
  final username;

  const ProfileWidget({Key key, this.username = "Guest"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 17.0),
        child: Column(
          children: <Widget>[
            buildImage(),

            // username + email
            Container(
              padding: EdgeInsets.only(top: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(username,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  SizedBox(height: 14.0),
                ],
              ),
            ),

            // follow list
            buildFollowList(),

            SizedBox(height: 25.0),

            buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.amber.shade100,
      child: Icon(
        Icons.face,
        size: 32,
        color: Colors.blue.shade900,
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

  // Widget buildLoginButton() {
  //   return OutlinedButton(
  //     onPressed: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //       print('login profile button');
  //     },
  //     child: Text(
  //       "Log in",
  //       style: TextStyle(color: Colors.blue.shade900),
  //     ),
  //     style: OutlinedButton.styleFrom(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(24.0))),
  //       side: BorderSide(
  //         color: Colors.blue.shade900,
  //       ),
  //     ),
  //   );
  // }

  Widget buildFollowList() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "0",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Text(
            "Following",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(width: 16),
          Text(
            "0",
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
}
