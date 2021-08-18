import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/author_trending_model.dart';
import 'package:ifgpdemo/screen/author_profile/author_profile_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:ifgpdemo/service/api/author_ranking_api.dart';

class AuthorWidget extends StatefulWidget {
  final userid;
  final useremail;
  final userimg;

  const AuthorWidget({Key key, this.userid, this.useremail, this.userimg})
      : super(key: key);

  @override
  _AuthorWidgetState createState() => _AuthorWidgetState();
}

class _AuthorWidgetState extends State<AuthorWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthorTrendingAPI.getTrendingAuthor(),
      builder: (BuildContext context,
          AsyncSnapshot<List<AuthorTrendingModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _, int index) {
                final author = snapshot.data[index];

                return GestureDetector(
                  onTap: () {
                    if (widget.userid != author.iduser) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthorProfileScreen(
                                    useremail: widget.useremail,
                                    userimage: widget.userimg,
                                    profileid: widget.userid,
                                    idauthor: author.iduser,
                                    nameauthor: author.username,
                                  )));
                    } else if (widget.userid == author.iduser) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    id: widget.userid,
                                    email: widget.useremail,
                                    image: widget.userimg,
                                  )));
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10000.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                'http://35.213.159.134/avatar/${author.image}',
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
                                radius: 36.0,
                                backgroundColor: Colors.black12,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          author.username,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
