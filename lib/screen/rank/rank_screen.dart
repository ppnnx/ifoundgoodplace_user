import 'package:flutter/material.dart';



class RankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('ranking.', style: Theme.of(context).textTheme.bodyText1,),
        elevation: 0,
      ),
    );
  }
}