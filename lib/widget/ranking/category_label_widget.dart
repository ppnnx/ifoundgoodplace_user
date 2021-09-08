import 'package:flutter/material.dart';

class CategoryLabel extends StatelessWidget {
  final String nameCategory;

  const CategoryLabel({Key? key, this.nameCategory = ""}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Text(
        nameCategory, 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14
        ),
      ),
    );
  }
}
