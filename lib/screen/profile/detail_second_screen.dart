import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ifgpdemo/model/mycontent_model.dart';
import 'package:ifgpdemo/widget/comment_widget.dart';
import 'package:http/http.dart' as http;

class DetailSecond extends StatefulWidget {
  final MyContent mycontent;
  final userid;
  final useremail;
  final userimg;

  const DetailSecond(
      {Key key, this.userid, this.useremail, this.userimg, this.mycontent})
      : super(key: key);

  @override
  _DetailSecondState createState() => _DetailSecondState();
}

class _DetailSecondState extends State<DetailSecond> {
  int _current = 0;
  Timer _timer;
  double _progress;

  // api delete content
  Future deletecontent() async {
    try {
      final url = Uri.parse('http://35.213.159.134/ctdelete.php');
      final response = await http.post(url, body: {
        "ID_User": widget.userid.toString(),
        "ID_Contentdl": widget.mycontent.idcontent.toString(),
      });

      if (response.statusCode == 200) {
        print('this content was deleted!');
        // progress between doing
        _progress = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(milliseconds: 100),
            (Timer timer) async {
          EasyLoading.showProgress(_progress,
              status: '${(_progress * 100).toStringAsFixed(0)}%');
          _progress += 0.03;

          if (_progress >= 1) {
            EasyLoading.showSuccess('Done');
            _timer?.cancel();
            EasyLoading.dismiss();
            await delay();
            Navigator.of(context).pop(true);
          }

          // else {
          //   EasyLoading.showError('Failed');
          //   _timer?.cancel();
          //   EasyLoading.dismiss();
          // }
        });
      } else {}
    } catch (e) {}
  }

  Future delay() async {
    await Future.delayed(Duration(milliseconds: 2000));
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        // title: Text(
        //   widget.useremail + ' / ' + widget.userid.toString(),
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: Colors.black,
        //   ),
        // ),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 21,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        actions: [
          IconButton(
              icon: Icon(
                CupertinoIcons.trash,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {
                print('delete this content.');
                _showdeletedialog(context);
              }),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // date + author + category
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // date
                      Text(
                        widget.mycontent.dateContent,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      // author
                      Text(
                        widget.mycontent.username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                      // category
                      Container(
                        padding: EdgeInsets.only(
                            left: 6, right: 6, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            // color: Colors.black,
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          widget.mycontent.category,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.mycontent.statusReport == "reported"
                    ? Container(
                        height: 60,
                        width: double.infinity,
                        color: Colors.amberAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'This content was reported',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Please waiting for review.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ))
                    : Text(''),
                SizedBox(height: 100),

                // title
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.mycontent.title,
                    style: TextStyle(fontFamily: 'Kanit', fontSize: 22),
                  ),
                ),
                // images
                imageSlide(widget.mycontent),
                SizedBox(height: 60),

                // story
                Container(
                  padding: EdgeInsets.all(21.0),
                  child: Text(
                    widget.mycontent.content,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(height: 70),

                // clip video + location

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
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(
                              widget.mycontent.favorited.toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
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
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.mycontent.saved.toString()),
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
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.mycontent.shared.toString()),
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
                              size: 16,
                            ),
                            SizedBox(width: 7),
                            Text(widget.mycontent.counterread.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.black,
                ),

                // comment
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 30, left: 21, bottom: 20),
                        child: Text(
                          'Comments (' +
                              widget.mycontent.comment.toString() +
                              ')',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // show comments
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommentWidget(
                            idcontent: widget.mycontent.idcontent,
                            iduser: widget.userid,
                            emailuser: widget.useremail,
                          ),
                        ],
                      )),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // image slide
  Widget imageSlide(MyContent content) {
    // list images
    List imgList = [
      'http://35.213.159.134/uploadimages/${content.images01}',
      'http://35.213.159.134/uploadimages/${content.images02}',
      'http://35.213.159.134/uploadimages/${content.images03}',
      'http://35.213.159.134/uploadimages/${content.images04}',
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

  // alert delete dialog
  void _showdeletedialog(BuildContext context) => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: new Text("Delete this content?"),
            // content: new Text("This is my content"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(true),
                isDefaultAction: true,
                child: Text("No"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  deletecontent();
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ));
}
