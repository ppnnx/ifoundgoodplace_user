import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';
import 'package:ifgpdemo/service/api/content_api.dart';
import 'package:http/http.dart' as http;

class AllContentsWidget extends StatefulWidget {
  final emailuser;
  final iduser;

  const AllContentsWidget({Key? key, this.emailuser = "Guest", this.iduser})
      : super(key: key);

  @override
  _AllContentsWidgetState createState() => _AllContentsWidgetState();
}

class _AllContentsWidgetState extends State<AllContentsWidget> {
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final listcontent = snapshot.data![index];

                  return GestureDetector(
                    child: buildContents(listcontent),
                    onTap: () async {
                      try {
                        final url =
                            Uri.parse('http://35.213.159.134/counterread.php');
                        final response = await http.post(url, body: {
                          "ID_Content": listcontent.idcontent.toString(),
                          "Click": '1',
                        });
                        if (response.statusCode == 200) {
                          print('success');
                        }
                      } catch (e) {}

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailSCRN(
                                    contents: snapshot.data![index],
                                    emailuser: widget.emailuser,
                                    iduser: widget.iduser,
                                    idcontent: listcontent.idcontent,
                                    count: listcontent.counterread! + 1,
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
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'http://35.213.159.134/uploadimages/${contents.image01}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 100,
                        width: 100,
                        color: Colors.black12,
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 22),

                // all text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // catergory
                      // Container(
                      //   padding:
                      //       EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black,
                      //     borderRadius: BorderRadius.circular(14.0),
                      //     // border: Border.all(color: Colors.black),
                      //   ),
                      //   child: Text(
                      //     contents.category,
                      //     style: TextStyle(color: Colors.white, fontSize: 10),
                      //   ),
                      // ),
                      // SizedBox(height: 8),

                      // title
                      // Text(
                      //   contents.title,
                      //   style: TextStyle(color: Colors.black, fontSize: 16),
                      // ),
                      // SizedBox(height: 10),

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
                          contents.category!,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      SizedBox(height: 8),

                      // title
                      Text(
                        contents.title!,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 10),

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
                                  contents.username!,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
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
