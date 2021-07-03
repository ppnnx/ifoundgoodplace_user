import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final idcontent;
  final iduser;
  final emailuser;

  const CommentWidget(
      {Key key, this.idcontent, this.iduser, this.emailuser = "Guest"})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<CommentModel> commentModel = [];

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

    // if (response.statusCode == 200) {
    //   final List comment = json.decode(response.body);
    //   // print(response.body);
    //   if (comment == "No Comment") {

    //     print('no comment');
    //   }

    //   return comment.map((json) => CommentModel.fromJson(json)).toList();
    // } else {
    //   throw Exception('request api error');
    // }
  }

  // Future deleteComment() async {
  //   var url = Uri.parse('http://35.213.159.134/cominsertanddelete.php');

  //   try {
  //     var response = await http.post(url, body: {'comdelete': comments});

  //     if (response.statusCode == 200) {
  //       showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //                 title: Text('message'),
  //                 content: Text('Do you want to delete this comment'),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {},
  //                     child: Text('Yes'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: Text('No'),
  //                   )
  //                 ],
  //               ));
  //     }
  //   } catch (e) {}
  // }

  @override
  void initState() {
    super.initState();
    getComment();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getComment(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext _, int index) {
                  final comment = snapshot.data[index];

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0)),
                    margin: EdgeInsets.only(
                        top: 14, left: 18, right: 18, bottom: 12),
                    padding: EdgeInsets.only(
                        top: 20, left: 20, right: 16, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(comment.comment),
                            widget.emailuser == "Guest" ||
                                    widget.iduser != comment.idUser
                                ? Text('')
                                : InkWell(
                                    onTap: () {
                                      deleteComment(snapshot.data[index])
                                          .then((value) => getComment());
                                    },
                                    child: Icon(
                                      CupertinoIcons.multiply_circle_fill,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(comment.username),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      comment.dateComment,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    // SizedBox(width: 3),
                                    // Text(
                                    //   comment.timeComment,
                                    //   style: TextStyle(
                                    //       color: Colors.grey, fontSize: 12),
                                    // )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(width: 12),

                            comment.image == null
                                ? CircleAvatar(
                                    radius: 21,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.face,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 21,
                                    backgroundImage: NetworkImage(
                                        'http://35.213.159.134/uploadimages/${comment.image}'),
                                  ),
                            // CircleAvatar(
                            //   backgroundColor: Colors.black,
                            //   radius: 21,

                            //   child: Text(
                            //     comment.username[0],
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }

          return Center(
            child: Text('no comments.'),
          );
        });
  }

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
                          var url = Uri.parse(
                              'http://35.213.159.134/cominsertanddelete.php');
                          var response = await http.post(url, body: {
                            'comdelete': commentModel.idComment.toString(),
                          });
                          print(response.body);

                          Navigator.pop(context);
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

  // void removeItem() {
  //   setState(() {
  //     commentModel.removeAt();
  //   });
  // }

  // var url = Uri.parse('http://35.213.159.134/cominsertanddelete.php');
  // var response = await http.post(url, body: {
  //   'comdelete': commentModel.idComment.toString(),
  // });

  // if (response.statusCode == 200) {
  //   var result = json.decode(response.body);
  //   print(result);
  // } else {
  //   throw Exception('error');
  // }

  // void showDeleteAlert(CommentModel commentModel) => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           // title: Text('ข้อ'),
  //           content: Text('Delete comment ?'),
  //           contentTextStyle: TextStyle(
  //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
  //           buttonPadding:
  //               EdgeInsets.only(left: 7, right: 10, bottom: 8, top: 8),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text(
  //                 'No',
  //                 style: TextStyle(color: Colors.black54),
  //               ),
  //               style: ElevatedButton.styleFrom(
  //                   primary: Colors.grey.shade300,
  //                   elevation: 0.0,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0)),
  //                   minimumSize: Size(60, 30)),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'Yes',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               style: ElevatedButton.styleFrom(
  //                   primary: Colors.red.shade900,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0)),
  //                   minimumSize: Size(60, 30)),
  //             ),
  //           ],
  //         ));
}
