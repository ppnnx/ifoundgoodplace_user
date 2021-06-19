import 'package:flutter/material.dart';
import 'package:ifgpdemo/widget/home/all_contents_widget.dart';

class AllContents extends StatelessWidget {
  final emailuser;
  final iduser;

  const AllContents({Key key, this.emailuser, this.iduser}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
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
      ),
      body: ListView(
        children: [
          AllContentsWidget(iduser: iduser, emailuser: emailuser,),
        ],
      ),
    );
  }
}
