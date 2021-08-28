import 'package:flutter/material.dart';

class HeaderGuestDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFC1CFC0),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0, left: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/second.png'),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.only(left: 19.0),
            child: Column(
              children: [
                Text(
                  "Guest",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
