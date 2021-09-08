// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ifgpdemo/model/content_model.dart';
// import 'package:ifgpdemo/model/user_model.dart';
// import 'package:ifgpdemo/service/provider/bookmark_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BookmarkScreen extends StatefulWidget {
//   final iduser;

//   const BookmarkScreen({Key? key, this.iduser}) : super(key: key);
//   @override
//   _BookmarkScreenState createState() => _BookmarkScreenState();
// }

// class _BookmarkScreenState extends State<BookmarkScreen> {
//   SharedPreferences? sharedPreferences;
//   User user = User();
//   Contents content = Contents();

//   @override
//   void initState() {
//     initSharedPreferences();
//     super.initState();
//   }

//   initSharedPreferences() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       Provider.of<BookMarkProvider>(context, listen: false).loadData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var bookmark = Provider.of<BookMarkProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             'bookmark.',
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           elevation: 0.0,
//           leading: IconButton(
//             icon: Icon(
//               Icons.keyboard_backspace,
//               color: Colors.black,
//               size: 19,
//             ),
//             onPressed: () {
//               print('back');
//               Navigator.pop(context);
//             },
//           )),
//       body: widget.iduser == user.iduser
//           ? Container()
//           : Container(
//               child: Consumer<BookMarkProvider>(
//                   builder: (context, content, child) {
//                 return ListView.builder(
//                     itemCount: content.contentList.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding:
//                                   EdgeInsets.only(left: 18, right: 18, top: 10),
//                               child: Row(
//                                 children: [
//                                   // image
//                                   Container(
//                                     height: 100,
//                                     width: 100,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               'http://35.213.159.134/uploadimages/${content.contentList[index]!.image01}'),
//                                           fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   SizedBox(width: 22),

//                                   // all text
//                                   Expanded(
//                                       child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       // catergory
//                                       Container(
//                                         padding: EdgeInsets.only(
//                                             left: 8,
//                                             right: 8,
//                                             top: 6,
//                                             bottom: 6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.black,
//                                           borderRadius:
//                                               BorderRadius.circular(14.0),
//                                         ),
//                                         child: Text(
//                                           content.contentList[index]!.category!,
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 10),
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),

//                                       // title
//                                       Text(
//                                         content.contentList[index]!.title!,
//                                         style: TextStyle(
//                                             color: Colors.black, fontSize: 16),
//                                       ),
//                                       SizedBox(height: 10),

//                                       // author
//                                       Text(
//                                         content.contentList[index]!.username!,
//                                         style: TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   )),
//                                   SizedBox(width: 16.0),
//                                   GestureDetector(
//                                     onTap: () {
//                                       bookmark.contentList.contains(
//                                               content.contentList[index])
//                                           ? bookmark.removeItem(
//                                               content.contentList[index])
//                                           : bookmark.addItem(
//                                               content.contentList[index]);
//                                     },
//                                     child: bookmark.contentList.contains(
//                                             content.contentList[index])
//                                         ? Icon(
//                                             CupertinoIcons.bookmark_fill,
//                                             color: Colors.black,
//                                             size: 19,
//                                           )
//                                         : Icon(
//                                             CupertinoIcons.bookmark,
//                                             color: Colors.black,
//                                             size: 19,
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Divider(),
//                           ],
//                         ),
//                       );
//                     });
//               }),
//             ),
//     );
//   }
// }
