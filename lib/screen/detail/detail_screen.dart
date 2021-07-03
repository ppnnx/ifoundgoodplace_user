import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/author_profile/author_profile_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/widget/comment_widget.dart';
import 'package:share/share.dart';

class DetailScreen extends StatefulWidget {
  final Contents content;
  final userEmail;
  final userId;
  final userImage;

  const DetailScreen({
    Key key,
    this.content,
    this.userEmail = "Guest",
    this.userId,
    this.userImage,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController commentcontroller = TextEditingController();
  bool favorited = false;
  bool bookmark = false;
  String favoritedornot = " ";
  int _current = 0;

  // api add comment to db
  Future addComment() async {
    var url = Uri.parse('http://35.213.159.134/cominsertanddelete.php');
    var response = await http.post(url, body: {
      'textcom': commentcontroller.text,
      'com': widget.content.idcontent.toString(),
      'idusercom': widget.userId.toString(),
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1800),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'ส่งความคิดเห็นแล้ว',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.white,
                ),
              ],
            ),
            backgroundColor: Colors.blue.shade900,
          ),
        );
      await delay(1500);
      setState(() {
        commentcontroller.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  // delay
  Future<void> delay(int millisec) async {
    print('delay start');
    await Future.delayed(Duration(milliseconds: millisec));
    print('delay end');
  }

  // api add favorite content to db
  Future getFavorite() async {
    var url = Uri.parse('http://35.213.159.134/favinsert.php');

    try {
      var response = await http.post(url, body: {
        'iduserfav': widget.userId.toString(),
        'fav': widget.content.idcontent.toString(),
        'Status_Fav': '1'
      });
      print('user : ${widget.userId}');
      print('content : ${widget.content.idcontent}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          favoritedornot = data;
        });
      }

      print(response.body);
    } catch (e) {}
  }

  // api add report content to db
  Future getReport() async {
    var url = Uri.parse('http://35.213.159.134/report.php');

    try {
      var response = await http.post(url, body: {
        'iduser': widget.userId.toString(),
        'report': widget.content.idcontent.toString(),
      });
      print(
          'user id ${widget.userId} report content id ${widget.content.idcontent}');
      // print('report content id : ${widget.content.idcontent}');

      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {}
  }

  // _favorited() {
  //   if (widget.userEmail == "Guest") {
  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //               title: Text('message'),
  //               content: Text('please login before'),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: Text('OK')),
  //               ],
  //             ));
  //   }
  //   else {
  //     setState(() {
  //     favorited = !favorited;
  //   });
  //   }
  // }

  _favorited() {
    setState(() {
      favorited = !favorited;
    });
  }

  // _bookmark() {
  //   setState(() {
  //     bookmark = !bookmark;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getFavorite();
  }

  @override
  void dispose() {
    commentcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 21,
            ),
            onPressed: () {
              print('back');
              Navigator.pop(context);
            }),
        actions: <Widget>[
          widget.userEmail == "Guest"
              ? Text('')
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            favorited || favoritedornot == "1"
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            _favorited();
                            getFavorite();
                          }),
                      IconButton(
                          icon: Icon(
                            bookmark
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            color: Colors.black,
                            size: 19,
                          ),
                          onPressed: () {}),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: Colors.black,
                          size: 19,
                        ),
                        onPressed: showBottomSheet,
                      ),
                    ],
                  ),
                ),
        ],
      ),

////////////////////////////////////// app bar /////////////////////////////

      body: ListView(
        children: [
          Container(
            // padding: EdgeInsets.all(21.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // catergory
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // date
                      Text(
                        widget.content.dateContent,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),

                      // author (username).
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthorProfileScreen(
                                      idauthor: widget.content.iduser,
                                      profileid: widget.userId,
                                    ))),
                        child: Text(
                          widget.content.username,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      // Text(
                      //   widget.content.username,
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w500,
                      //       fontStyle: FontStyle.italic),
                      // ),

                      // category
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                            // color: Colors.black,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          widget.content.category,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // test
                // Text(widget.userId.toString()),
                SizedBox(height: 100),

                // title
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.content.title,
                    style: TextStyle(fontFamily: 'Kanit', fontSize: 24),
                  ),
                ),
                // SizedBox(height: 80),

                // image
                // Container(
                //   child: Image.network(
                //     'http://35.213.159.134/uploadimages/${widget.content.image01}',
                //     height: 300,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                imageSlide(widget.content),

                // author(username)
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                // CircleAvatar(
                //   backgroundColor: Colors.amber,
                //   radius: 15,
                // ),
                // SizedBox(width: 10),
                //     Text(
                //       widget.content.username,
                //       style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                //     )
                //   ],
                // ),

                SizedBox(height: 60),

                // content
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.content.content,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        widget.content.counterread.toString(),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'read.',
                        style: TextStyle(
                            color: Colors.black, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),

///////////////////////// comment start ////////////////////////////
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40, left: 21, bottom: 20),
                        child: Text(
                          'Comment.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // check user is login already ?
                      widget.userEmail == "Guest"
                          ? Container(
                              height: 120,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    child: Text('Login'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                        ),
                                        minimumSize: Size(200.0, 40.0)),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: commentcontroller,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    // maxLines: 3,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.black,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),

                                        // prefix: widget.userImage == null
                                        //     ? CircleAvatar(
                                        //         radius: 21,
                                        //         backgroundColor:
                                        //             Colors.grey.shade300,
                                        //         child: Icon(
                                        //           Icons.face,
                                        //           color: Colors.black,
                                        //           size: 18,
                                        //         ),
                                        //       )
                                        //     : CircleAvatar(
                                        //       radius: 21,
                                        //       backgroundImage: NetworkImage(
                                        //       'http://35.213.159.134/uploadimages/${widget.userImage}'),
                                        //     ),

                                        hintText: 'type your comment..',
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      addComment();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.paperplane,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10),
                                        Text('SEND'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 21),
                                ],
                              ),
                            ),

                      // show comments
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommentWidget(
                            idcontent: widget.content.idcontent,
                            iduser: widget.userId,
                            emailuser: widget.userEmail,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                ///////////////////////// comment end /////////////////////////
              ],
            ),
          ),
        ],
      ),
    );
  }

  // bottom sheet for share + report button
  void showBottomSheet() => showModalBottomSheet(
      enableDrag: false,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(14.0),
        topRight: Radius.circular(14.0),
      )),
      builder: (context) => Container(
            // height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('Share'),
                  onTap: () {
                    Share.share(
                        '${widget.content.title} \nhttps://example.com');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('Report'),
                  onTap: () => _showAlertReport(context),
                ),
                // MaterialButton(
                //   minWidth: 300.0,
                //   color: Colors.grey.shade200,
                //   elevation: 0.0,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(24.0),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: Text(
                //     'Cancel',
                //     style: TextStyle(color: Colors.black),
                //   ),
                // )
              ],
            ),
          ));

  // image slide
  Widget imageSlide(Contents contents) {
    // list images
    List imgList = [
      'http://35.213.159.134/uploadimages/${contents.image01}',
      'http://35.213.159.134/uploadimages/${contents.image02}',
      'http://35.213.159.134/uploadimages/${contents.image03}',
      'http://35.213.159.134/uploadimages/${contents.image04}',
    ];

    return Container(
      child: Column(
        children: [
          CarouselSlider(
              items: imgList.map((imgUrl) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 300.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              )),
          SizedBox(height: 16),

          // dot (indicatior)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);

              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _current == index ? Colors.black : Colors.grey.shade400,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  _showAlertReport(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to report this content'),
            actions: [
              TextButton(
                onPressed: () {
                  getReport();
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              )
            ],
          ));
}
