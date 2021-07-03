import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/author_trending_model.dart';
import 'package:ifgpdemo/service/api/author_ranking_api.dart';

class AuthorWidget extends StatelessWidget {
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

                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'http://35.213.159.134/uploadimages/${author.image}'),
                        radius: 36.0,
                      ),
                      SizedBox(height: 8),
                      Text(
                        author.username,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
