import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/bookmark/bookmark_screen.dart';
import 'package:ifgpdemo/screen/detail/allcontent_screen.dart';
import 'package:ifgpdemo/screen/favorite/favorite_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:ifgpdemo/screen/rank/full_chart_author.dart';
import 'package:ifgpdemo/screen/search/search_screen.dart';
import 'package:ifgpdemo/widget/home/author_widget.dart';
import 'package:ifgpdemo/widget/home/categories_widget.dart';
import 'package:ifgpdemo/widget/home/contents_widget.dart';
import 'package:ifgpdemo/widget/map_widget.dart';
import 'package:ifgpdemo/widget/ranking/all_rank_widget.dart';
import 'package:ifgpdemo/widget/ranking/group_btn_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final email;
  final username;
  final iduser;
  final image;

  const HomeScreen(
      {Key key,
      this.email = "Guest",
      this.username = " ",
      this.iduser,
      this.image})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String email = "";

  // Future signInCheck() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // widget.email = preferences.getString('Email');
  //   // setState(() {
  //   //   email = preferences.getString('Email');
  //   //   print(email);
  //   // });
  // }

  // Future signout() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.remove('Email');
  // }

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
          // leading: IconButton(
          //   icon: Icon(
          //     CupertinoIcons.placemark,
          //     size: 20,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     print('search loction.');
          //   },
          // ),
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

        // drawer menu
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // header
              Container(
                // color: Colors.white,
                height: 200,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.email == "Guest" || widget.image == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(
                                Icons.face,
                                color: Colors.black,
                              ),
                              radius: 40,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://35.213.159.134/uploadimages/${widget.image}'),
                              radius: 40,
                            ),
                      SizedBox(height: 12),
                      Container(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              Text(widget.email),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              widget.email == "Guest"
                  ? ListTile(
                      leading: Icon(
                        CupertinoIcons.rocket_fill,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          // ListTile(
                          //   leading: Icon(
                          //     CupertinoIcons.home,
                          //     color: Colors.black,
                          //     size: 20,
                          //   ),
                          //   title: Text(
                          //     'home',
                          //     style: TextStyle(color: Colors.black),
                          //   ),
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => HomeScreen()));
                          //   },
                          // ),
                          SizedBox(height: 5),
                          ListTile(
                            leading: Icon(
                              Icons.face,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            name: widget.username,
                                            id: widget.iduser,
                                          )));
                            },
                          ),
                          SizedBox(height: 5),
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.bookmark,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text('Bookmark',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookmarkScreen()));
                            },
                          ),
                          SizedBox(height: 5),
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.heart,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text('Favorite',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavoriteScreen(
                                            iduser: widget.iduser,
                                          )));
                            },
                          ),

                          Divider(
                            color: Colors.black26,
                          ),

                          ListTile(
                            leading: Icon(
                              CupertinoIcons.multiply_circle,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              print('logout');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),

        // drawer: Drawer(
        //   child: ListView(
        //   children: <Widget>[
        //     UserAccountsDrawerHeader(
        //       decoration: BoxDecoration(color: Colors.white),
        //       accountName: Text(
        //         widget.username,
        //         style: TextStyle(color: Colors.black),
        //       ),
        //       accountEmail: Text(
        //         widget.email,
        //         style: TextStyle(color: Colors.black),
        //       ),
        //       currentAccountPicture: CircleAvatar(
        //         backgroundColor: Colors.amber.shade100,
        //         child: Icon(Icons.face, color: Colors.black,),

        //       ),
        //     ),
        //     widget.email == "Guest"
        //         ? ListTile(
        //             leading: Icon(
        //               CupertinoIcons.rocket_fill,
        //               color: Colors.black,
        //             ),
        //             title: Text(
        //               'Login',
        //               style: TextStyle(color: Colors.black, fontSize: 14),
        //             ),
        //             onTap: () {
        //               print('logout');
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => LoginScreen()));
        //             },
        //           )
        //         : ListTile(
        //             leading: Icon(
        //               CupertinoIcons.flame_fill,
        //               color: Colors.black,
        //             ),
        //             title: Text(
        //               'logout',
        //               style: TextStyle(color: Colors.black),
        //             ),
        //             onTap: () {
        //               print('logout');
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => HomeScreen()));
        //             },
        //           )
        //   ],
        // )),

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
              child: AuthorWidget(),
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
            SizedBox(height: 8),

            // (head). ranking
            // buildheadjusttext('ranking'),
            // SizedBox(height: 12),
            // AllRankWidget(),
            // GroupButton(),
            SizedBox(height: 14),
            // (head). map
            // buildheadjusttext('map'),
            // MapWidget(),
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
                            builder: (context) => FullChartAuthor()));
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
