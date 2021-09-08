import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/detail/allcontent_screen.dart';
import 'package:ifgpdemo/screen/home/drawer/drawer_guest_menu.dart';
import 'package:ifgpdemo/screen/home/drawer/drawer_header.dart';
import 'package:ifgpdemo/screen/home/drawer/drawer_menu.dart';
import 'package:ifgpdemo/screen/map/map_nd_scrn.dart';
import 'package:ifgpdemo/screen/rank/full_chart_author.dart';
import 'package:ifgpdemo/screen/search/search_screen.dart';
import 'package:ifgpdemo/widget/home/author_widget.dart';
import 'package:ifgpdemo/widget/home/categories_widget.dart';
import 'package:ifgpdemo/widget/home/contents_widget.dart';

class HomeScreen extends StatefulWidget {
  final email;
  final username;
  final iduser;
  final image;

  const HomeScreen(
      {Key? key,
      this.email = "Guest",
      this.username = " ",
      this.iduser,
      this.image})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '.ifoundgoodplace',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                print('search contents.');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                              iduser: widget.iduser,
                              emailuser: widget.email,
                            )));
              },
            )
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  HeaderDrawer(
                    email: widget.email,
                    useridlogin: widget.iduser,
                  ),
                  widget.email == "Guest"
                      ? MenuGuestDrawer()
                      : MenuDrawer(
                          iduser: widget.iduser,
                          emailuser: widget.email,
                          username: widget.username,
                        )
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            // (head).
            buildheadwithseeall('Latest'),
            SizedBox(height: 16),
            ContentsWidget(
              email: widget.email,
              userid: widget.iduser,
              userimg: widget.image,
            ),
            // (head). author
            buildheadwithbtn(),
            Container(
              height: 120,
              width: double.infinity,
              child: AuthorWidget(
                userid: widget.iduser,
                useremail: widget.email,
                userimg: widget.image,
              ),
            ),
            SizedBox(height: 14),
            // (head). category
            buildheadwithline('Category'),
            CategoriesWidget(
              iduser: widget.iduser,
              emailuser: widget.email,
              imguser: widget.image,
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(height: 20),

            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapSCRN(
                                  idlogin: widget.iduser,
                                  email: widget.email,
                                ))),
                    child: Icon(
                      CupertinoIcons.map,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(color: Colors.black)),
                      elevation: 0.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ));
  }

  Widget buildheadwithline(String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget buildheadwithseeall(String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 30, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        'see all',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: Colors.black,
                        size: 14,
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllContents(
                                  iduser: widget.iduser,
                                  emailuser: widget.email,
                                )));
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget buildheadwithbtn() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 30, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Author',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        'see all',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: Colors.black,
                        size: 14,
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullChartAuthor(
                                  useremail: widget.email,
                                  userid: widget.iduser,
                                  userimage: widget.image,
                                )));
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget buildheadjusttext(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 30),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
