import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:ifgpdemo/screen/detail/detail_nd_screen.dart';
import 'package:ifgpdemo/service/api/search_api.dart';
import 'package:ifgpdemo/widget/home/contents_widget.dart';
import 'package:ifgpdemo/widget/search_widget.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final iduser;
  final emailuser;

  const SearchScreen({Key? key, this.iduser, this.emailuser}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Contents> contents = [];
  String query = '';

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final contents = await SearchAPI.searchContent(query);

    setState(() {
      this.contents = contents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          buildSearch(),

          // show search item
          query.isEmpty
              ? Text('')
              : Expanded(
                  child: contents.isEmpty
                      ? Text(
                          'ไม่พบบทความที่ค้นหา',
                          style: TextStyle(fontSize: 14),
                        )
                      : ListView.builder(
                          itemCount: contents.length,
                          itemBuilder: (context, index) {
                            final content = contents[index];

                            return GestureDetector(
                              child: BuildContents(
                                contents: content,
                              ),
                              onTap: () async {
                                try {
                                  final url = Uri.parse(
                                      'http://35.213.159.134/counterread.php');
                                  final response = await http.post(url, body: {
                                    "ID_Content": content.idcontent.toString(),
                                    "Click": '1',
                                  });
                                  if (response.statusCode == 200) {
                                    print('success');
                                  }
                                } catch (e) {}

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailSCRN(
                                              contents: content,
                                              iduser: widget.iduser,
                                              emailuser: widget.emailuser,
                                              count: content.counterread! + 1,
                                            )));
                              },
                            );
                          })),
        ],
      )),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        onChanged: searchTitle,
      );

  Future searchTitle(String query) async {
    final contents = await SearchAPI.searchContent(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.contents = contents;
    });
  }
}

class BuildItems extends StatelessWidget {
  const BuildItems({
    Key? key,
    required this.content,
  }) : super(key: key);

  final Contents content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 25, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title!,
                    style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    content.username!,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 14),
                ],
              )),
          Divider(),
        ],
      ),
    );
  }
}
