import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/author_trending_model.dart';
import 'package:ifgpdemo/model/content_trending_model.dart';
import 'package:ifgpdemo/service/api/all_category_ranking_api.dart';
import 'package:ifgpdemo/service/api/author_ranking_api.dart';
import 'package:ifgpdemo/widget/ranking/chart_author.dart';
import 'package:ifgpdemo/widget/ranking/chart_content.dart';

class AllRankWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: CarouselSlider(
            items: <Widget>[
              // all category
              Container(
                  height: 400,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  // padding: EdgeInsets.only(top: 10, left: 16, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 24, bottom: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'all category',
                               style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),

                        // fetch data
                        Expanded(
                          child: FutureBuilder(
                              future: TrendingAPI.getTrendingContent(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<TrendingModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 3,
                                      itemBuilder: (BuildContext _, int index) {
                                        return ChartContent(
                                          rank: index + 1,
                                          data: snapshot.data[index],
                                        );
                                      });
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                      ],
                    ),
                  )),

              // popular author
              Container(
                  height: 400,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 24, bottom: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'popular author',
                              style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),

                        // fetch data
                        Expanded(
                          child: FutureBuilder(
                              future: AuthorTrendingAPI.getTrendingAuthor(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AuthorTrendingModel>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 3,
                                      itemBuilder: (BuildContext _, int index) {
                                        return ChartAuthor(
                                          rank: index + 1,
                                          data: snapshot.data[index],
                                        );
                                      });
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )),
            ],
            options: CarouselOptions(
              height: 480,
              autoPlay: false,
              viewportFraction: 0.9,
              enableInfiniteScroll: false,
              initialPage: 0,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            )),
      ),
    );
  }
}
