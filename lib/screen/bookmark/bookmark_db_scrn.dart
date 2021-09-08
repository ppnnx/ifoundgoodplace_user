import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/db/db_provider.dart';
import 'package:ifgpdemo/db/savemodel.dart';

class SaveDBSCRN extends StatefulWidget {
  final iduser;
  final username;

  const SaveDBSCRN({Key? key, this.iduser, this.username}) : super(key: key);

  @override
  _SaveDBSCRNState createState() => _SaveDBSCRNState();
}

class _SaveDBSCRNState extends State<SaveDBSCRN> {
  List<Save>? saved;

  Future refreshSaveList() async {
    this.saved = await DatabaseProvider.db.getSaveList();
  }

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
          future: DatabaseProvider.db.getSaveList(),
          builder: (BuildContext context, AsyncSnapshot<List<Save>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading . . ."),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text("You don't have Save List."),
                  )
                : ListView(
                    children: snapshot.data!.map((saved) {
                      return Container(
                        height: 130,
                        width: 375,
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 4),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'http://35.213.159.134/uploadimages/${saved.image01}',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // category
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(2.0)),
                                  child: Text(
                                    saved.category!,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 7),
                                // title
                                Text(
                                  saved.title!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                SizedBox(height: 7),
                                // author
                                Text(
                                  saved.author!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            )),
                            SizedBox(width: 15),

                            GestureDetector(
                              onTap: () async {
                                // try {
                                //   final url = Uri.parse(
                                //       'http://35.213.159.134/saveinsert.php');
                                //   final response =
                                //       await http.post(url, body: {
                                //     "idusersave": iduser.toString(),
                                //     "save": idcontent.toString(),
                                //     "Status_Save": 'unsave',
                                //   });
                                //   if (response.statusCode == 200) {
                                //     print('deleted bookmark!');
                                //   } else {
                                //     print('failed');
                                //   }
                                // } catch (e) {}
                                // DatabaseProvider.db.deleteBookmark(id);
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
                      );
                    }).toList(),
                  );
          }),
    );
  }
}
