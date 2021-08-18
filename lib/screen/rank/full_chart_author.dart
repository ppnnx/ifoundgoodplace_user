import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/author_trending_model.dart';
import 'package:ifgpdemo/screen/author_profile/author_profile_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:ifgpdemo/service/api/author_ranking_api.dart';

class FullChartAuthor extends StatefulWidget {
  final useremail;
  final userid;
  final userimage;

  const FullChartAuthor({Key key, this.useremail, this.userid, this.userimage})
      : super(key: key);

  @override
  _FullChartAuthorState createState() => _FullChartAuthorState();
}

class _FullChartAuthorState extends State<FullChartAuthor> {
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
              size: 19,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.black)),
                    child: Text('Top Chart',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          FutureBuilder(
              future: AuthorTrendingAPI.getTrendingAuthor(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<AuthorTrendingModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext _, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.userid != snapshot.data[index].iduser) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthorProfileScreen(
                                            idauthor:
                                                snapshot.data[index].iduser,
                                            nameauthor:
                                                snapshot.data[index].username,
                                            profileid: widget.userid,
                                            useremail: widget.useremail,
                                            userimage: widget.userimage,
                                          )));
                            } else if (widget.userid ==
                                snapshot.data[index].iduser) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            id: widget.userid,
                                            email: widget.useremail,
                                            image: widget.userimage,
                                          )));
                            }
                          },
                          child: AuthorChartWidget(
                            rank: index + 1,
                            data: snapshot.data[index],
                          ),
                        );
                      });
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}

class AuthorChartWidget extends StatelessWidget {
  final int rank;
  final AuthorTrendingModel data;

  const AuthorChartWidget({Key key, this.rank, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 375,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.only(left: 32, right: 20, top: 10, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                '$rank',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: <Widget>[
                      Text(
                        data.sumread.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'read',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      imageUrl: 'http://35.213.159.134/avatar/${data.image}',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black12,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
