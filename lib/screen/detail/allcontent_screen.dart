import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_trending_model.dart';
import 'package:ifgpdemo/screen/rank/full_chart_content.dart';
import 'package:ifgpdemo/service/api/all_category_ranking_api.dart';
import 'package:ifgpdemo/widget/home/all_contents_widget.dart';

class AllContents extends StatelessWidget {
  final emailuser;
  final iduser;

  const AllContents({Key key, this.emailuser, this.iduser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_backspace,
                color: Color(0xFF41444b),
                size: 21,
              ),
            ),
            // create two tabs
            bottom: TabBar(
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorPadding: EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(54.0),
                color: Colors.black,
              ),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LATEST"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("TOP CHART"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: AllContentsWidget(iduser: iduser, emailuser: emailuser),
              ),

              // tab 2 : chart
              ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 36, bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 26, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(color: Colors.black)),
                            child: Text('Top Chart',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 24.0),
                        FutureBuilder(
                            future: TrendingAPI.getTrendingContent(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<TrendingModel>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext _, int index) {
                                      return FullChartWidget(
                                        rank: index + 1,
                                        data: snapshot.data[index],
                                      );
                                    });
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
