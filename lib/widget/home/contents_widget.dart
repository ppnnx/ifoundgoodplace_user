import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_screen.dart';
import 'package:ifgpdemo/service/api/content_api.dart';

class ContentsWidget extends StatelessWidget {
  final email;
  final userid;
  final userimg;
  const ContentsWidget({Key key, this.email, this.userid, this.userimg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contents>>(
        future: ContentAPI.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final listcontent = snapshot.data[index];

                  return GestureDetector(
                    child: buildContents(listcontent),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    content: snapshot.data[index],
                                    userEmail: email,
                                    userId: userid,
                                    userImage: userimg,
                                  )));
                    },
                  );
                });
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: 300),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildContents(Contents contents) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 10),
            child: Row(
              children: [
                // image
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'http://35.213.159.134/uploadimages/${contents.image01}'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 22),

                // all text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        contents.title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // catergory
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14.0),
                          // border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          contents.category,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      SizedBox(height: 8),

                      // date
                      // Text(
                      //   contents.dateContent,
                      //   style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      // ),

                      // counter read + author(username)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundColor: Colors.amber,
                                //   radius: 13,
                                // ),
                                // SizedBox(width: 10),
                                Text(
                                  contents.username,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Row(
                          //   children: [
                          //     Icon(
                          //       CupertinoIcons.eye_fill,
                          //       color: Colors.black.withOpacity(0.8),
                          //       size: 19,
                          //     ),
                          //     SizedBox(width: 5),
                          //     Text(
                          //       contents.counterread.toString(),
                          //       style: TextStyle(
                          //           color: Colors.black.withOpacity(0.8),
                          //           fontSize: 14),
                          //     )
                          //   ],
                          // )),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
