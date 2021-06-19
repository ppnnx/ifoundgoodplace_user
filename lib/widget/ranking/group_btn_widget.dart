import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/rank/full_chart_author.dart';
import 'package:ifgpdemo/screen/rank/full_chart_content.dart';


class GroupButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      // color: Colors.white,
      padding: EdgeInsets.only(left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FullChartContent()));
            },
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  Text(
                    'ALL',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    'CATEGORIES',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Text('/', style: TextStyle(color: Colors.black, fontSize: 32),),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FullChartAuthor()));
            },
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'POPULAR',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    'AUTHORS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}