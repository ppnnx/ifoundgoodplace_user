import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_trending_model.dart';

class ChartContent extends StatelessWidget {
  final int? rank;
  final TrendingModel? data;

  const ChartContent({Key? key, this.rank, this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 375,
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          // rank
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

          // all data 
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      data!.category!,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                SizedBox(height: 6),
                  Text(
                    data!.title!,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: 6),
                  Text(
                    data!.username!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.book,
                        color: Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        data!.counterRead.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
