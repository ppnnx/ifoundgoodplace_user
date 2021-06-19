import 'package:flutter/material.dart';

class WriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print('publish');
            },
            child: Text("publish", style: TextStyle(color: Colors.blue.shade900),),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(24.0),
        physics: BouncingScrollPhysics(),
        children: [
          TextFormField(
            cursorColor: Colors.blue.shade900,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "type somthing..",
              hintStyle: TextStyle(fontSize: 15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 500,
          ),
        ],
      ),
    );
  }
}
