import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/db/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/bookmark/show_content.dart';

class BookMarkDBScreen extends StatefulWidget {
  final iduser;
  final username;

  const BookMarkDBScreen({Key key, this.iduser, this.username})
      : super(key: key);
  @override
  _BookMarkDBScreenState createState() => _BookMarkDBScreenState();
}

class _BookMarkDBScreenState extends State<BookMarkDBScreen> {
  // getting all bookmark
  saveContent() async {
    final saves = await DatabaseProvider.db.savedList();
    return saves;
  }

  // Future refreshBookmark() async {
  //   this._save = await DatabaseProvider.db.savedList();
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Save.',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: saveContent(),
        // ignore: missing_return
        builder: (context, bookmark) {
          switch (bookmark.connectionState) {
            case ConnectionState.waiting:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                // check that we didn't get a null
                if (bookmark.data == Null) {
                  return Center(
                    child: Text(
                      "You don't have Save List.",
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: bookmark.data.length,
                    itemBuilder: (context, index) {
                      // setting items
                      int id = bookmark.data[index]['id'];
                      int iduser = bookmark.data[index]['iduser'];
                      int idauthor = bookmark.data[index]['idauthor'];
                      String author = bookmark.data[index]['author'];
                      int idcontent = bookmark.data[index]['idcontent'];
                      String datecontent = bookmark.data[index]['datecontent'];
                      String title = bookmark.data[index]['title'];
                      String category = bookmark.data[index]['category'];
                      String story = bookmark.data[index]['story'];
                      String link = bookmark.data[index]['link'];
                      double lat = bookmark.data[index]['latitude'];
                      double lng = bookmark.data[index]['longitude'];
                      int read = bookmark.data[index]['counterread'];
                      String image01 = bookmark.data[index]['image01'];
                      String image02 = bookmark.data[index]['image02'];
                      String image03 = bookmark.data[index]['image03'];
                      String image04 = bookmark.data[index]['image04'];
                      int favorite = bookmark.data[index]['favorite'];
                      int save = bookmark.data[index]['save'];
                      int comments = bookmark.data[index]['comments'];
                      int share = bookmark.data[index]['share'];

                      return widget.iduser != iduser
                          ? Container(
                              child: bookmark.data.length == 0
                                  ? Text("You don't have Save List.")
                                  : null)
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowContent(
                                              id: id,
                                              iduser: iduser,
                                              idauthor: idauthor,
                                              author: author,
                                              idcontent: idcontent,
                                              datecontent: datecontent,
                                              title: title,
                                              category: category,
                                              story: story,
                                              link: link,
                                              lat: lat,
                                              lng: lng,
                                              read: read,
                                              img01: image01,
                                              img02: image02,
                                              img03: image03,
                                              img04: image04,
                                              favorite: favorite,
                                              save: save,
                                              comment: comments,
                                              share: share,
                                            )));
                              },
                              child: Container(
                                height: 130,
                                width: 375,
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 4, bottom: 4),
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'http://35.213.159.134/uploadimages/$image01',
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
                                    SizedBox(width: 16),

                                    // title + category + author
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // category
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        // title
                                        Text(
                                          title,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        SizedBox(height: 7),
                                        // author
                                        Text(
                                          author,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )),
                                    SizedBox(width: 15),

                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final url = Uri.parse(
                                              'http://35.213.159.134/saveinsert.php');
                                          final response =
                                              await http.post(url, body: {
                                            "idusersave": iduser.toString(),
                                            "save": idcontent.toString(),
                                            "Status_Save": 'unsave',
                                          });
                                          if (response.statusCode == 200) {
                                            print('deleted bookmark!');
                                          } else {
                                            print('failed');
                                          }
                                        } catch (e) {}
                                        DatabaseProvider.db.deleteBookmark(id);
                                        // print('delete bookmarked content');
                                      },
                                      child: Icon(
                                        CupertinoIcons.bookmark_fill,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  );
                }
              }
              break;
            case ConnectionState.none:
              {
                return Center(
                  child: Text("Can't connect with local database."),
                );
              }
              break;
            case ConnectionState.active:
              {
                return null;
              }
              break;
          }
        },
      ),
    );
  }
}
