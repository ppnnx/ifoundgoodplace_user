import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'bookmark.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 19,
            ),
            onPressed: () {
              print('back');
              Navigator.pop(context);
            },
          )),
    );
  }
}
