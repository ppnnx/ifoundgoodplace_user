import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  final idauthor;

  const CreateScreen({Key key, this.idauthor}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  File _image1;
  File _image2;
  File _image3;
  File _image4;

  final picker = ImagePicker();

  List categoryItem = List();
  String selectedCategory;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController storycontroller = TextEditingController();

  // for google map
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(18.810570, 98.952657),
    zoom: 16.0,
  );

  Widget buildmap() {
    return Container(
      margin: EdgeInsets.all(12.0),
      height: 350,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
      ),
    );
  }

  Future selectImage1(ImageSource imageSource) async {
    var pickedImage = await picker.getImage(source: imageSource);
    setState(() {
      _image1 = File(pickedImage.path);

      // if (_image1 = null) {
      //   return Text('null');
      // }
    });
  }

  Future selectImage2(ImageSource imageSource) async {
    var pickedImage = await picker.getImage(source: imageSource);
    setState(() {
      _image2 = File(pickedImage.path);
    });
  }

  Future selectImage3(ImageSource imageSource) async {
    var pickedImage = await picker.getImage(source: imageSource);
    setState(() {
      _image3 = File(pickedImage.path);
    });
  }

  Future selectImage4(ImageSource imageSource) async {
    var pickedImage = await picker.getImage(source: imageSource);
    setState(() {
      _image4 = File(pickedImage.path);
    });
  }

  Future getCategory() async {
    var url = Uri.parse('http://35.213.159.134/category.php?plus');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        categoryItem = data;
      });
    }
    // print(categoryItem);
  }

  Future addPost() async {
    var url = Uri.parse('http://35.213.159.134/ctcreate.php');
    var request = http.MultipartRequest("POST", url);
    request.fields['Title'] = titlecontroller.text;
    request.fields['Content'] = storycontroller.text;
    request.fields['ID_Category'] = selectedCategory;
    request.fields['ID_Userpost'] = widget.idauthor.toString();

    // photo 1
    var photo01 = await http.MultipartFile.fromPath('Images01', _image1.path,
        filename: _image1.path);
    request.files.add(photo01);
    // photo 2
    var photo02 = await http.MultipartFile.fromPath('Images02', _image2.path,
        filename: _image2.path);
    request.files.add(photo02);

    // photo 3
    var photo03 = await http.MultipartFile.fromPath('Images03', _image3.path,
        filename: _image3.path);
    request.files.add(photo03);

    // photo 4
    var photo04 = await http.MultipartFile.fromPath('Images04', _image4.path,
        filename: _image4.path);
    request.files.add(photo04);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(titlecontroller.text);
      print(widget.idauthor.toString());
      print(selectedCategory);
      print(photo01);
      print(photo02);
      print(photo03);
      print(photo04);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    storycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("create.", style: Theme.of(context).textTheme.bodyText1),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.multiply,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            print('close');
            Navigator.pop(context);
          },
        ),
        // actions: <Widget>[
        //   TextButton(
        //     onPressed: () {
        //       print('next');
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => WriteScreen()));
        //     },
        //     child: Text(
        //       "next",
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   )
        // ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            addPost();
          });
          // print('published');
        },
        label: Text('Publish'),
        backgroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: titlecontroller,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        showAlertTitle();
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    cursorColor: Colors.black,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 18),
                        border: InputBorder.none),
                  ),
                  SizedBox(height: 10),

////////////////////////////////// category ///////////////////////////////////
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Category',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonHideUnderline(
                      child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCategory,
                        iconSize: 30,
                        icon: (null),
                        hint: Text('category'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            selectedCategory = newValue;
                            getCategory();
                            print(selectedCategory);
                          });
                        },
                        items: categoryItem.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['Category']),
                            value: item['ID_Category'].toString(),
                          );
                        }).toList()),
                  )),

                  // DropdownButton(
                  //   isExpanded: true,
                  //   value: selectedCategory,
                  //   hint: Text('category'),
                  //   items: categoryItem.map((category) {
                  //     return DropdownMenuItem(
                  //       value: category['Category'],
                  //       child: Text(category['Category']),
                  //     );
                  //   }).toList(),
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       selectedCategory = newValue;
                  //     });
                  //   },
                  // ),
                  SizedBox(height: 26),

//////////////////////////////// image ///////////////////////////////////
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Photos',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        GridView.count(
                          padding: EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: <Widget>[
                            GestureDetector(
                              onTap: showBottomMenu1,
                              child: Container(
                                color: Colors.black12,
                                child: _image1 == null
                                    ? Icon(CupertinoIcons.add)
                                    : Image.file(
                                        _image1,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: showBottomMenu2,
                              child: Container(
                                color: Colors.black12,
                                child: _image2 == null
                                    ? Icon(CupertinoIcons.add)
                                    : Image.file(
                                        _image2,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: showBottomMenu3,
                              child: Container(
                                color: Colors.black12,
                                child: _image3 == null
                                    ? Icon(CupertinoIcons.add)
                                    : Image.file(
                                        _image3,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: showBottomMenu4,
                              child: Container(
                                color: Colors.black12,
                                child: _image4 == null
                                    ? Icon(CupertinoIcons.add)
                                    : Image.file(
                                        _image4,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

//////////////////////////////// image end ///////////////////////////////////

////////////////////////// url ////////////////////////////
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'URL Video',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'your url',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),

                  // location
                  // Container(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           'Location',
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //       SizedBox(height: 10),
                  //       buildmap(),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 60),

                  // story
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 19,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: storycontroller,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        showAlertStory();
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 100,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'type your story this here . .',
                        hintStyle: TextStyle(fontSize: 16),
                        border: InputBorder.none),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAlertTitle() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            title: Icon(CupertinoIcons.exclamationmark_circle,
                color: Colors.red.shade900, size: 50),
            content: Text(
              "Please add your title",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  Future<void> showAlertStory() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            title: Icon(CupertinoIcons.exclamationmark_circle,
                color: Colors.red.shade900, size: 50),
            content: Text(
              "plese add your story",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  // delay
  Future<void> delay(int millisec) async {
    print('delay start');
    await Future.delayed(Duration(milliseconds: millisec));
    print('delay end');
  }

//////////////////// bottom sheet for image picker ////////////////////

  // bottom sheet 1
  void showBottomMenu1() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 140,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Gallery'),
                  onTap: () {
                    selectImage1(ImageSource.gallery);
                    Navigator.of(context).pop(_image1);
                  }),
              ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    selectImage1(ImageSource.camera);
                    Navigator.of(context).pop(_image1);
                  }),
            ],
          ),
        ),
      );

  // bottom sheet 2
  void showBottomMenu2() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 140,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Gallery'),
                  onTap: () {
                    selectImage2(ImageSource.gallery);
                    Navigator.of(context).pop(_image2);
                  }),
              ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    selectImage2(ImageSource.camera);
                    Navigator.of(context).pop(_image2);
                  }),
            ],
          ),
        ),
      );

  // bottom sheet 3
  void showBottomMenu3() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 140,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Gallery'),
                  onTap: () {
                    selectImage3(ImageSource.gallery);
                    Navigator.of(context).pop(_image3);
                  }),
              ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    selectImage3(ImageSource.camera);
                    Navigator.of(context).pop(_image3);
                  }),
            ],
          ),
        ),
      );

  // bottom sheet 4
  void showBottomMenu4() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 140,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Gallery'),
                  onTap: () {
                    selectImage4(ImageSource.gallery);
                    Navigator.of(context).pop(_image4);
                  }),
              ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    selectImage4(ImageSource.camera);
                    Navigator.of(context).pop(_image4);
                  }),
            ],
          ),
        ),
      );
}
