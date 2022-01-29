import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/category_model.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/model/content_trending_model.dart';
import 'package:ifgpdemo/service/api/all_category_ranking_api.dart';
import 'package:http/http.dart' as http;

class FullChartContent extends StatefulWidget {
  @override
  _FullChartContentState createState() => _FullChartContentState();
}

class _FullChartContentState extends State<FullChartContent> {
  List? categoryItem = List as List?;
  List<Categories> categories = [];
  List<Contents> content = [];

  String? selectedCategory;

  Future getCategory() async {
    var url = Uri.parse('http://35.213.159.134/category.php?plus');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        categoryItem = data;
      });
    } else {
      throw Exception('error');
    }
    // print(categoryItem);
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
            size: 19,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    'Top Chart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: TrendingAPI.getTrendingContent(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TrendingModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext _, int index) {
                    return FullChartWidget(
                      rank: index + 1,
                      data: snapshot.data![index],
                    );
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FullChartWidget extends StatelessWidget {
  final int? rank;
  final TrendingModel? data;

  const FullChartWidget({Key? key, this.rank, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 375,
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      padding: EdgeInsets.only(
        left: 22,
        right: 16,
        top: 10,
        bottom: 16,
      ),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    data!.category!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  data!.title!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  data!.username!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.book,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      data!.counterRead.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 18),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'http://35.213.159.134/uploadimages/${data!.images01}',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 80,
                        width: 80,
                        color: Colors.black12,
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
