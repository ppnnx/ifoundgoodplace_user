import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final idcontent;
  final iduser;
  final emailuser;

  const CommentWidget(
      {Key? key, this.idcontent, this.iduser, this.emailuser = "Guest"})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<CommentModel> commentModel = [];

  Future<List<CommentModel>?> getComment() async {
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
            (BuildContext context, AsyncSnapshot<List<CommentModel>?> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext _, int index) {
                  final comment = snapshot.data![index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
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
                                borderRadius: BorderRadius.circular(10000.0),
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
                                          comment.username!,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          comment.dateComment!,
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
                                            deleteComment(comment)
                                                .then((value) => getComment());
                                          },
                                        )
                                ],
                              ),
                              SizedBox(height: 16),
                              // comment part
                              Text(
                                comment.comment!,
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

                  // return Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       // border: Border.all(color: Colors.black),
                  //       borderRadius: BorderRadius.circular(4.0)),
                  //   margin: EdgeInsets.only(left: 18, right: 18, bottom: 10),
                  //   padding: EdgeInsets.only(
                  //       top: 20, left: 20, right: 16, bottom: 20),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(comment.comment),
                  //           widget.emailuser == "Guest" ||
                  //                   widget.iduser != comment.idUser
                  //               ? Text('')
                  //               : InkWell(
                  //                   onTap: () {
                  //                     deleteComment(snapshot.data[index])
                  //                         .then((value) => getComment());
                  //                   },
                  //                   child: Icon(
                  //                     CupertinoIcons.minus_circle_fill,
                  //                     color: Colors.black38,
                  //                     size: 20,
                  //                   ),
                  //                 ),
                  //         ],
                  //       ),
                  //       SizedBox(height: 17),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: <Widget>[
                  //           Container(
                  //               child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.end,
                  //             children: [
                  //               Text(comment.username),
                  //               SizedBox(height: 3),
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     comment.dateComment,
                  //                     style: TextStyle(
                  //                         color: Colors.grey, fontSize: 12),
                  //                   ),
                  //                   // SizedBox(width: 3),
                  //                   // Text(
                  //                   //   comment.timeComment,
                  //                   //   style: TextStyle(
                  //                   //       color: Colors.grey, fontSize: 12),
                  //                   // )
                  //                 ],
                  //               ),
                  //             ],
                  //           )),
                  //           SizedBox(width: 12),
                  //           comment.image == null || comment.image == ''
                  //               ? CircleAvatar(
                  //                   radius: 21,
                  //                   backgroundImage:
                  //                       AssetImage('assets/second.png'),
                  //                 )
                  //               : ClipRRect(
                  //                   borderRadius:
                  //                       BorderRadius.circular(10000.0),
                  //                   child: CachedNetworkImage(
                  //                     imageUrl:
                  //                         'http://35.213.159.134/avatar/${comment.image}',
                  //                     width: 30,
                  //                     height: 30,
                  //                     fit: BoxFit.cover,
                  //                     placeholder: (context, url) {
                  //                       return Center(
                  //                         child: CircularProgressIndicator(),
                  //                       );
                  //                     },
                  //                     errorWidget: (context, url, error) {
                  //                       return CircleAvatar(
                  //                         radius: 21,
                  //                         backgroundColor: Colors.black12,
                  //                         child: Icon(
                  //                           Icons.error,
                  //                           color: Colors.red,
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // );
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
}
