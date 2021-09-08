import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/category_model.dart';
import 'package:ifgpdemo/screen/category/category_screen.dart';
import 'package:ifgpdemo/service/api/categories_api.dart';

class CategoriesWidget extends StatefulWidget {
  final iduser;
  final emailuser;
  final imguser;

  const CategoriesWidget({Key? key, this.iduser, this.emailuser, this.imguser})
      : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CatergoriesAPI.getCatergories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final category = snapshot.data![index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                    name: category.name,
                                    idcategory: category.id,
                                    useremail: widget.emailuser,
                                    userid: widget.iduser,
                                    userimg: widget.imguser,
                                  )));
                      print(category.name);
                      print(category.id);
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 33, bottom: 6, top: 4, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.name!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.black,
                              size: 19,
                            )
                          ],
                        )),
                  );
                });
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
