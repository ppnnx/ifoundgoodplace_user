import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/db/db_provider.dart';
import 'package:ifgpdemo/db/savemodel.dart';
import 'package:ifgpdemo/model/comment_model.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/author_profile/author_profile_screen.dart';
import 'package:ifgpdemo/screen/detail/detail_map_scrn.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailSCRN extends StatefulWidget {
  final Contents contents;
  final iduser;
  final emailuser;
  final idcontent;
  final int count;

  const DetailSCRN(
      {Key key,
      this.iduser,
      this.emailuser = "Guest",
      this.idcontent,
      this.contents,
      this.count})
      : super(key: key);

  @override
  _DetailSCRNState createState() => _DetailSCRNState();
}

class _DetailSCRNState extends State<DetailSCRN> {
  TextEditingController commentcontroller = TextEditingController();
  String statement; // for keep statement from report
  int _current = 0; // for dot
  bool favorited = false;
  bool bookmarked = false;

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

  // api add bookmark content to db
  Future getBookmark() async {
    try {
      final url = Uri.parse('http://35.213.159.134/saveinsert.php');
      final response = await http.post(url, body: {
        "idusersave": widget.iduser.toString(),
        "save": widget.idcontent.toString(),
        "Status_Save": 'saved',
      });
      if (response.statusCode == 200) {
        print('bookmarked already!');
      } else {
        print('failed');
      }
    } catch (e) {}
  }

  // db bookmark
  saveContent(Save saved) async {
    DatabaseProvider.db.addBookmark(saved);
    print("content added to bookmark store successfully");
  }

  // api add favorite content to db
  Future getFavorite() async {
    var url = Uri.parse('http://35.213.159.134/favinsert.php');

    try {
      var response = await http.post(url, body: {
        'iduserfav': widget.iduser.toString(),
        'fav': widget.idcontent.toString(),
        'Status_Fav': 'favorited',
      });
      if (response.statusCode == 200) {
        print('Content : ${widget.idcontent} is already FAVORITED!');
      } else {
        print('Failed!');
      }
    } catch (e) {}
  }

  // api add report content to db
  Future getReport() async {
    var url = Uri.parse('http://35.213.159.134/report.php');

    try {
      var response = await http.post(url, body: {
        'iduser': widget.iduser.toString(),
        'report': widget.idcontent.toString(),
        'statement': statement,
      });
      // print(
      //     'user id ${widget.userId} report content id ${widget.content.idcontent}');
      // print('report content id : ${widget.content.idcontent}');

      if (response.statusCode == 200) {
        print("Report this content already");
      } else {
        print("failed to report");
      }
    } catch (e) {}
  }

  // api add comment to db
  Future addComment() async {
    var url = Uri.parse('http://35.213.159.134/cominsert.php');
    var response = await http.post(url, body: {
      "idusercom": widget.iduser.toString(),
      "com": widget.idcontent.toString(),
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
    // print('delay start');
    await Future.delayed(Duration(milliseconds: millisec));
    // print('delay end');
  }

  // api insert share to db
  Future insertShare() async {
    try {
      final url = Uri.parse('http://35.213.159.134/shareinsert.php');
      final response = await http.post(url, body: {
        "iduser": widget.iduser.toString(),
        "share": widget.idcontent.toString(),
        "Status_Share": "shared",
      });

      if (response.statusCode == 200) {
        print('already share this content!');
      } else {
        print('share failed!');
      }
    } catch (e) {}
  }

  // fetch content data from api
  Future<List<Contents>> getStory() async {
    try {
      final url = Uri.parse('http://35.213.159.134/ctshow.php');
      final response = await http.post(url, body: {
        "ID_Content": widget.idcontent.toString(),
      });

      if (response.statusCode == 200) {
        final List contents = json.decode(response.body);
        return contents.map((e) => Contents.fromJson(e)).toList();
      } else {
        print("API Failed");
      }
    } catch (e) {}
    return [];
  }

  // fetch comment from api
  Future<List<CommentModel>> getComment() async {
    var url = Uri.parse('http://35.213.159.134/comshow.php');

    try {
      var response = await http
          .post(url, body: {'ID_Content': widget.idcontent.toString()});

      if (response.statusCode == 200) {
        final List comment = json.decode(response.body);

        return comment.map((json) => CommentModel.fromJson(json)).toList();
      } else {
        throw Exception('error');
      }
    } catch (e) {}
    return null;
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getStory();
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
        // title: Text(
        //   widget.idcontent.toString(),
        //   style: TextStyle(fontSize: 12),
        // ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          widget.emailuser == "Guest"
              ? Text('')
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // favorite
                      IconButton(
                        icon: Icon(
                          favorited == true
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: favorited == true ? Colors.red : Colors.black,
                          size: 18,
                        ),
                        onPressed: () {
                          if (favorited) {
                            setState(() {
                              favorited = false;
                            });
                          } else {
                            setState(() {
                              favorited = true;
                              getFavorite();
                            });
                          }
                        },
                      ),

                      // bookmark
                      IconButton(
                        icon: Icon(
                          bookmarked == true
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                          color: Colors.black,
                          size: 17,
                        ),
                        onPressed: () {
                          if (bookmarked) {
                            setState(() {
                              bookmarked = false;
                            });
                          } else {
                            setState(() {
                              bookmarked = true;
                              getBookmark();

                              // db bookmark
                              iduser = widget.iduser;
                              idauthor = widget.contents.iduser;
                              author = widget.contents.username;
                              idcontent = widget.contents.idcontent;
                              datecontent = widget.contents.dateContent;
                              title = widget.contents.title;
                              category = widget.contents.category;
                              story = widget.contents.content;
                              link = widget.contents.link;
                              latitude = widget.contents.latitude;
                              longitude = widget.contents.longitude;
                              counterread = widget.contents.counterread;
                              image01 = widget.contents.image01;
                              image02 = widget.contents.image02;
                              image03 = widget.contents.image03;
                              image04 = widget.contents.image04;
                              favorite = widget.contents.favorite;
                              save = widget.contents.save;
                              comments = widget.contents.comments;
                              share = widget.contents.share;

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
                            });
                          }
                        },
                      ),

                      // report + share
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
                              ]),
                    ],
                  ),
                ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
              future: getStory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Contents>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final content = snapshot.data[index];

                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // part 1 : header => date / author / category
                            Container(
                              padding: EdgeInsets.all(21.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // date
                                  Text(
                                    content.dateContent,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  // author
                                  GestureDetector(
                                    onTap: () {
                                      if (widget.iduser != content.iduser) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthorProfileScreen(
                                                      idauthor: content.iduser,
                                                      profileid: widget.iduser,
                                                      nameauthor:
                                                          content.username,
                                                      useremail:
                                                          widget.emailuser,
                                                    )));
                                      } else if (widget.iduser ==
                                          content.iduser) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      id: widget.iduser,
                                                      email: widget.emailuser,
                                                    )));
                                      }
                                    },
                                    child: Text(
                                      content.username,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  // category
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Text(
                                      content.category.toLowerCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 100),

                            // part 2 : middle => title / story / location / link
                            // title
                            Container(
                              padding: EdgeInsets.all(21.0),
                              child: Text(
                                content.title,
                                style: TextStyle(
                                    fontFamily: 'Kanit', fontSize: 24),
                              ),
                            ),

                            // images
                            showimages(content),
                            SizedBox(height: 60),

                            // story
                            Container(
                              padding: EdgeInsets.all(21.0),
                              child: Text(
                                content.content,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 80),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // location
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailMapScreen(
                                                    lat: content.latitude,
                                                    lng: content.longitude,
                                                    title: content.title,
                                                  )));
                                    },
                                    child: Icon(
                                      CupertinoIcons.placemark,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF7EB5A6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        elevation: 0.0),
                                  ),
                                  SizedBox(width: 10),
                                  // link
                                  content.link == null || content.link == " "
                                      ? Text('')
                                      : ElevatedButton(
                                          onPressed: () {
                                            _launchURL(content.link);
                                          },
                                          child: Icon(
                                            CupertinoIcons.play_fill,
                                            color: Colors.white,
                                            size: 21,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xFFFF2442),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              elevation: 0.0),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 70),

                            // show all total
                            Container(
                              padding: EdgeInsets.all(21.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        Text(content.favorite.toString()),
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
                                        Text(content.save.toString()),
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
                                        Text(content.share.toString()),
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
                                        Text(content.counterread.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),

                            // comment part
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // head
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 40, left: 21, bottom: 20),
                                    child: Text(
                                      'Comments (' +
                                          content.comments.toString() +
                                          ')',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),

                                  // check user login already
                                  widget.emailuser == "Guest"
                                      ? Container(
                                          height: 120,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                child: Text('Login'),
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen()),
                                                      (route) => false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22.0),
                                                    ),
                                                    minimumSize:
                                                        Size(200.0, 40.0)),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: double.infinity,
                                          height: 180,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: commentcontroller,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                                maxLines: 3,
                                                keyboardType:
                                                    TextInputType.text,
                                                cursorColor: Colors.black,
                                                autocorrect: false,
                                                decoration: InputDecoration(
                                                    fillColor: Colors.white70,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    hintText:
                                                        'type your comment..',
                                                    hintStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic)),
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
                                                        BorderRadius.circular(
                                                            22.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(),
                  );
                }
              }),

          // show comment
          FutureBuilder(
              future: getComment(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CommentModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext _, int index) {
                        final comment = snapshot.data[index];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 0),
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 16, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // image
                              comment.image == null || comment.image == ''
                                  ? CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                          AssetImage('assets/second.png'),
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10000.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'http://35.213.159.134/avatar/${comment.image}',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              SizedBox(width: 10),
                              // comment box
                              Container(
                                color: Colors.white,
                                constraints: BoxConstraints(
                                  maxWidth: 280,
                                  maxHeight: 120,
                                  minHeight: 110,
                                ),
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 16, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // username + datecomment + delete btn
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                comment.username,
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                comment.dateComment,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.emailuser == "Guest" ||
                                                widget.iduser != comment.idUser
                                            ? Text('')
                                            : IconButton(
                                                icon: Icon(
                                                  CupertinoIcons.minus,
                                                  color: Colors.black54,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  deleteComment(comment).then(
                                                      (value) => getComment());
                                                },
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    // comment part
                                    Text(
                                      comment.comment,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(12.0),
                    child: Text('no comments.'),
                  );
                }
              }),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // delete comment
  Future deleteComment(CommentModel commentModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Delete comment ?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade400,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minimumSize: Size(80, 30)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          final url =
                              Uri.parse('http://35.213.159.134/comdelete.php');
                          final response = await http.post(url, body: {
                            "idusercomdel": commentModel.idUser.toString(),
                            "idcomdel": commentModel.idComment.toString(),
                            "Status_Comment": "unavailable",
                          });
                          if (response.statusCode == 200) {
                            print('______# delete comment already');
                          } else {
                            print('______# failed to delete');
                          }
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade900,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minimumSize: Size(80, 30)),
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  // pop up menu function
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        insertShare();
        Share.share(
            'https://ifgp.com/content${widget.idcontent}/${widget.contents.title}');
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
                  title: Text('ใช้ภาพประกอบที่ไม่เหมาะสม'),
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
                        getReport();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(milliseconds: 1800),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  // images
  Widget showimages(Contents contents) {
    List images = [
      'http://35.213.159.134/uploadimages/${contents.image01}',
      'http://35.213.159.134/uploadimages/${contents.image02}',
      'http://35.213.159.134/uploadimages/${contents.image03}',
      'http://35.213.159.134/uploadimages/${contents.image04}',
    ];

    return Container(
      child: Column(
        children: [
          CarouselSlider(
              items: images.map((imgUrl) {
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
            children: images.map((url) {
              int index = images.indexOf(url);

              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: _current == index ? Colors.black : Colors.white,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
