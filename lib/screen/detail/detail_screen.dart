import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifgpdemo/db/db_provider.dart';
import 'package:ifgpdemo/db/savemodel.dart';
import 'package:ifgpdemo/model/check_favorited_model.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/author_profile/author_profile_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:ifgpdemo/service/provider/bookmark_provider.dart';
import 'package:ifgpdemo/widget/comment_widget.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Contents content;
  final userEmail;
  final userId;
  final userImage;
  final int count;

  const DetailScreen({
    Key key,
    this.content,
    this.userEmail = "Guest",
    this.userId,
    this.userImage,
    this.count,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController commentcontroller = TextEditingController();
  bool favorited = false;
  bool bookmarked = false;
  String favoritedornot = " ";
  String bookmarkornot = " ";
  int _current = 0;
  List<Contents> contentmodel = [];
  String statement; // for keep statement from report
  CheckFavorited checkFavorited = CheckFavorited();
  Set<Marker> _marker = {};

  // db's parameter
  int iduser;
  int idauthor;
  String author;
  int idcontent;
  String datecontent;
  String title;
  String category;
  String story;
  String link;
  double latitude;
  double longitude;
  int counterread;
  String image01;
  String image02;
  String image03;
  String image04;
  int favorite;
  int save;
  int comments;
  int share;
  //

  // set marker for map
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _marker.add(Marker(
        markerId: MarkerId('id'),
        position: LatLng(widget.content.latitude, widget.content.longitude),
      ));
    });
  }

  // api get counter read to db
  Future getCounterRead() async {
    try {
      final url = Uri.parse('http://35.213.159.134/counterread.php');
      final response = await http.post(url, body: {
        "ID_Content": widget.content.idcontent.toString(),
        "Click": '1',
      });
      if (response.statusCode == 200) {
        print('success');
      }
    } catch (e) {}
  }

  // api insert share to db
  Future insertShare() async {
    try {
      final url = Uri.parse('http://35.213.159.134/shareinsert.php');
      final response = await http.post(url, body: {
        "iduser": widget.userId.toString(),
        "share": widget.content.idcontent.toString(),
        "Status_Share": "shared",
      });

      if (response.statusCode == 200) {
        print('already share this content!');
      } else {
        print('share failed!');
      }
    } catch (e) {}
  }

  // api add comment to db
  Future addComment() async {
    var url = Uri.parse('http://35.213.159.134/cominsert.php');
    var response = await http.post(url, body: {
      "idusercom": widget.userId.toString(),
      "com": widget.content.idcontent.toString(),
      "textcom": commentcontroller.text,
      "Status_Comment": "available",
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
        'Status_Fav': 'favorited',
      });
      print('user : ${widget.userId}');
      print('content : ${widget.content.idcontent}');
      if (response.statusCode == 200) {
        print('Content : ${widget.content.idcontent} is already FAVORITED!');
        // var data = json.decode(response.body);

        // setState(() {
        //   favoritedornot = data;
        // });
      } else {
        print('Failed!');
      }
      // print(response.body);
    } catch (e) {}
  }

  // api add bookmark content to db
  Future getBookmark() async {
    try {
      final url = Uri.parse('http://35.213.159.134/saveinsert.php');
      final response = await http.post(url, body: {
        "idusersave": widget.userId.toString(),
        "save": widget.content.idcontent.toString(),
        "Status_Save": 'saved',
      });
      if (response.statusCode == 200) {
        // var data = json.decode(response.body);

        // setState(() {
        //   bookmarkornot = data;
        // });

        // print('user : ${widget.userId}');
        // print(' bookmark content : ${widget.content.idcontent}');
        print('bookmarked already!');
      } else {
        print('failed');
      }
    } catch (e) {}
  }

  // api add report content to db
  Future getReport() async {
    var url = Uri.parse('http://35.213.159.134/report.php');

    try {
      var response = await http.post(url, body: {
        'iduser': widget.userId.toString(),
        'report': widget.content.idcontent.toString(),
        'statement': statement,
      });
      print(
          'user id ${widget.userId} report content id ${widget.content.idcontent}');
      // print('report content id : ${widget.content.idcontent}');

      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {}
  }

  // api check status favorite
  Future<CheckFavorited> _checkStatusFavorite() async {
    try {
      final url = Uri.parse(
          'http://35.213.159.134/statusfav.php?iduser=${widget.userId}&idcontent=${widget.content.idcontent}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (checkFavorited.statusFav == 'favorited') {
          print('this content was FAVORITED!');
          setState(() {
            favorited = true;
          });
        } else {
          print('this content was UNFAVORITED!');
          setState(() {
            favorited = false;
          });
        }
      } else {
        print('api is not work!');
      }
    } catch (e) {}
    return null;
  }

  // db bookmark
  saveContent(Save saved) async {
    DatabaseProvider.db.addBookmark(saved);
    print("content added to bookmark store successfully");
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

  // url launch
  void _launchURL(String url) async {
    if (!url.contains('http')) url = 'https://$url';
    await canLaunch(url) ? launch(url) : throw 'Could not launch $url';
  }

  _favorited() {
    setState(() {
      favorited = !favorited;
    });
  }

  _bookmark() {
    setState(() {
      bookmarked = !bookmarked;
    });
  }

  @override
  void initState() {
    super.initState();
    getCounterRead();
    // _checkStatusFavorite();
    // getFavorite();
  }

  @override
  void dispose() {
    commentcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bookmark = Provider.of<BookMarkProvider>(context, listen: false);

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
              Navigator.pop(context);
            }),
        actions: <Widget>[
          widget.userEmail == "Guest"
              ? Text('')
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // favorited == true
                      //     ? Text('favorited')
                      //     : Text('unfavorited'),
                      SizedBox(width: 5),
                      // favorite button
                      // checkFavorited.statusFav == 'favorited' ||
                      //         favorited == true
                      //     ? IconButton(
                      //         icon: Icon(CupertinoIcons.heart_fill,
                      //             color: Colors.black, size: 20),
                      //         onPressed: () {
                      //           setState(() {
                      //             _favorited();
                      //           });
                      //         })
                      //     : IconButton(
                      //         icon: Icon(CupertinoIcons.heart,
                      //             color: Colors.black, size: 20),
                      //         onPressed: () {
                      //           setState(() {
                      //             _favorited();
                      //           });
                      //         }),
                      IconButton(
                        icon: Icon(
                          checkFavorited.statusFav == 'favorited' ||
                                  favorited == true
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: checkFavorited.statusFav == 'favorited' ||
                                  favorited == true
                              ? Colors.red.shade800
                              : Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
                          _favorited();
                          // _checkStatusFavorite();
                          getFavorite();
                        },
                      ),
                      // IconButton(
                      //     icon: Icon(
                      //       favorited || favoritedornot == "1"
                      //           ? CupertinoIcons.heart_fill
                      //           : CupertinoIcons.heart,
                      //       color: Colors.black,
                      //       size: 20,
                      //     ),
                      //     onPressed: () {
                      //       // if (favorited) {
                      //       //   setState(() {
                      //       //     favorited = false;
                      //       //   });
                      //       // } else {
                      //       //   setState(() {
                      //       //     favorited = true;
                      //       //   });
                      //       // }
                      //       _favorited();
                      //       getFavorite();
                      //     }),
                      IconButton(
                          icon: Icon(
                            bookmark.contentList.contains(widget.content) ||
                                    bookmarked
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            color: Colors.black,
                            size: 19,
                          ),
                          onPressed: () {
                            _bookmark();
                            getBookmark();
                            bookmark.contentList.contains(widget.content)
                                ? bookmark.removeItem(widget.content)
                                : bookmark.addItem(widget.content);

                            // db bookmark
                            setState(() {
                              iduser = widget.userId;
                              idauthor = widget.content.iduser;
                              author = widget.content.username;
                              idcontent = widget.content.idcontent;
                              datecontent = widget.content.dateContent;
                              title = widget.content.title;
                              category = widget.content.category;
                              story = widget.content.content;
                              link = widget.content.link;
                              latitude = widget.content.latitude;
                              longitude = widget.content.longitude;
                              counterread = widget.content.counterread;
                              image01 = widget.content.image01;
                              image02 = widget.content.image02;
                              image03 = widget.content.image03;
                              image04 = widget.content.image04;
                              favorite = widget.content.favorite;
                              save = widget.content.save;
                              comments = widget.content.comments;
                              share = widget.content.share;
                            });

                            Save saved = Save(
                                iduser: iduser,
                                idauthor: idauthor,
                                author: author,
                                idcontent: idcontent,
                                datecontent: datecontent,
                                title: title,
                                category: category,
                                story: story,
                                link: link,
                                latitude: latitude,
                                longitude: longitude,
                                counterread: counterread,
                                image01: image01,
                                image02: image02,
                                image03: image03,
                                image04: image04,
                                favorite: favorite,
                                save: save,
                                comments: comments,
                                share: share);

                            saveContent(saved);
                            print(
                                "user : ${saved.iduser} saved content : ${saved.idcontent}");
                          }),
                      // IconButton(
                      //   icon: Icon(
                      //     CupertinoIcons.ellipsis_vertical,
                      //     color: Colors.black,
                      //     size: 19,
                      //   ),
                      //   onPressed: showBottomSheet,
                      // ),

                      PopupMenuButton<int>(
                          icon: Icon(
                            CupertinoIcons.ellipsis_vertical,
                            color: Colors.black,
                            size: 19,
                          ),
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Share'),
                                    ],
                                  ),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.exclamationmark_triangle,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Report'),
                                    ],
                                  ),
                                )
                              ])
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
                        onTap: () {
                          if (widget.userId != widget.content.iduser) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthorProfileScreen(
                                          idauthor: widget.content.iduser,
                                          profileid: widget.userId,
                                          nameauthor: widget.content.username,
                                          useremail: widget.userEmail,
                                          userimage: widget.userImage,
                                        )));
                          } else if (widget.userId == widget.content.iduser) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          id: widget.userId,
                                          email: widget.userEmail,
                                          image: widget.userImage,
                                        )));
                          }
                        },
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
                  height: 80,
                ),

                // link video
                // Container(
                //   padding: EdgeInsets.all(21.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       widget.content.link == " " || widget.content.link == null
                //           ? Container()
                //           : ElevatedButton(
                //               onPressed: () {
                //                 _launchURL(widget.content.link);
                //               },
                //               child: Icon(CupertinoIcons.film,
                //                   color: Colors.white),
                //               style: ElevatedButton.styleFrom(
                //                   primary: Colors.black,
                //                   elevation: 0.0,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(10.0),
                //                   )),
                //             ),
                //       SizedBox(width: 21),

                //     ],
                //   ),
                // ),

                // location
                widget.content.latitude == null &&
                        widget.content.longitude == null
                    ? Text(' ')
                    : Container(
                        height: 300,
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            markers: _marker,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.content.latitude,
                                  widget.content.longitude),
                              zoom: 15,
                            )),
                      ),
                SizedBox(height: 70),

                // show all total
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // favorite
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 7),
                            Text(widget.content.favorite.toString()),
                          ],
                        ),
                      ),
                      // bookmark
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.bookmark_fill,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(widget.content.save.toString()),
                          ],
                        ),
                      ),
                      // share
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(widget.content.share.toString()),
                          ],
                        ),
                      ),
                      // count read
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.eye,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(widget.content.counterread.toString()),
                          ],
                        ),
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
                          'Comments (' +
                              widget.content.comments.toString() +
                              ')',
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
                              height: 180,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: commentcontroller,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    maxLines: 3,
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
                                ],
                              ),
                            ),

                      // show comments
                      CommentWidget(
                        idcontent: widget.content.idcontent,
                        iduser: widget.userId,
                        emailuser: widget.userEmail,
                      ),
                      SizedBox(height: 20),
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
  // void showBottomSheet() => showModalBottomSheet(
  //     enableDrag: false,
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(14.0),
  //       topRight: Radius.circular(14.0),
  //     )),
  //     builder: (context) => Container(
  //           // height: 150,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               ListTile(
  //                 leading: Icon(
  //                   Icons.share,
  //                   color: Colors.black,
  //                   size: 20,
  //                 ),
  //                 title: Text('Share'),
  //                 onTap: () {
  //                   insertShare();
  //                   Share.share(
  //                       '${widget.content.title} \nhttps://ifgp.com/${widget.content.title}');

  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               ListTile(
  //                 leading: Icon(
  //                   CupertinoIcons.exclamationmark_triangle,
  //                   color: Colors.black,
  //                   size: 20,
  //                 ),
  //                 title: Text('Report'),
  //                 onTap: () => _showAlertReport(context),
  //               ),
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
  //     ],
  //   ),
  // ));

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
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 300.0,
                        color: Colors.black12,
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
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

  // pop up menu function
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        insertShare();
        Share.share(
            '${widget.content.title} \nhttps://ifgp.com/content${widget.content.idcontent}');
        print('share');
        break;
      case 1:
        _showAlertReport(context);
        print('report');
        break;
    }
  }

  // report part
  _showAlertReport(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'แจ้งบทความไม่เหมาะสม',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: <Widget>[
              RadioListTile(
                  value: 'copyright', // ละเมิดลิขสิทธิ์
                  groupValue: statement,
                  title: Text('ละเมิดลิขสิทธิ์'),
                  subtitle: Text('ลอกเลียนแบบบทความผู้อื่น'),
                  onChanged: (value) {
                    setState(() {
                      statement = value as String;
                      print(value);
                    });
                  }),
              RadioListTile(
                  value: 'rude word', // คำหยาบ
                  groupValue: statement,
                  title: Text('ใช้ภาษาที่ไม่เหมาะสม'),
                  subtitle: Text('ใช้คำหยาบคาย'),
                  onChanged: (value) {
                    setState(() {
                      statement = value as String;
                      print(value);
                    });
                  }),
              RadioListTile(
                  value: 'pornography and nudity', // ภาพอนาจาร
                  groupValue: statement,
                  title: Text('รูปภาพอนาจาร'),
                  subtitle: Text('รูปภาพเชิง 18+'),
                  onChanged: (value) {
                    setState(() {
                      statement = value as String;
                      print(value);
                    });
                  }),
              Container(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    ),
                    SizedBox(width: 14),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 1800),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'ส่งรายงานปัญหาแล้ว',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.teal.shade400,
                            ),
                          );
                        getReport();
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'ส่งรายงานปัญหา',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal.shade400,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      });
}
