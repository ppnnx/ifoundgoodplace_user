import 'package:flutter/material.dart';


class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('map.', style: Theme.of(context).textTheme.bodyText1,),
        elevation: 0,
      ),
    );
  }
}