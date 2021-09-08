import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:http/http.dart' as http;

class HeaderDrawer extends StatefulWidget {
  final useridlogin;
  final email;

  const HeaderDrawer({
    Key? key,
    this.useridlogin,
    this.email = "Guest",
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<HeaderDrawer> {
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
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return widget.email == "Guest"
        ? Container(
            // color: Color(0xFFC1CFC0),
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(top: 20.0, left: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/second.png'),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.only(left: 19.0),
                  child: Column(
                    children: [
                      Text(
                        widget.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                )
              ],
            ),
          )
        : FutureBuilder(
            future: fetchdatauser(),
            builder: (context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      User user = snapshot.data![index];

                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // space for display + username + email
                            Container(
                              height: 200,
                              // color: Color(0xFFC1CFC0),
                              width: double.infinity,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 34, horizontal: 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // display
                                    user.image == null
                                        ? CircleAvatar(
                                            radius: 40,
                                            backgroundImage:
                                                AssetImage('assets/second.png'),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10000.0),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'http://35.213.159.134/avatar/${user.image}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) {
                                                return CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black12,
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
                                              user.username!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              user.email!,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
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
