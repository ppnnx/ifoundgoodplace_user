import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  final idauthor;

  const CreateScreen({Key? key, this.idauthor}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  double? _lat;
  late double _lng;

  // for loading
  Timer? _timer;
  late double _progress;

  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;

  List<File?> files = [];
  File? file;

  final picker = ImagePicker();

  List? categoryItem;
  String? selectedCategory;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController storycontroller = TextEditingController();
  TextEditingController urlcontroller = TextEditingController();

  // for google map
  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location is Open');

      // check permission location
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(context, 'Share your location is close',
              'Please open share your location');
        } else {
          // find lat lng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(context, 'Location Service is not allow',
              'Please allow location service in setting');
        } else {
          // find lat lng
          findLatLng();
        }
      }
    } else {
      print('Service Location is Close');
      alertLocationService(context, 'Location Service is not allow',
          'Please allow location service in setting');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng is work!');
    Position? position = await findPosition();
    setState(
      () {
        _lat = position!.latitude;
        _lng = position.longitude;
        print('Lat = $_lat , Lng = $_lng');
      },
    );
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {}
    return null;
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(_lat!, _lng),
          infoWindow: InfoWindow(
            title: 'you are here.',
            snippet: 'Lat = $_lat, Lng = $_lng',
          ),
        ),
      ].toSet();

  alertLocationService(
    BuildContext context,
    String title,
    String subtitle,
  ) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Navigator.pop(context);
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text('OK'),
            )
          ],
        ),
      );

  // initial image files = null
  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  Future selectImage1(ImageSource imageSource) async {
    try {
      var pickedImage = await picker.pickImage(
        source: imageSource,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        _image1 = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Future selectImage2(ImageSource imageSource) async {
    try {
      var pickedImage = await picker.pickImage(
        source: imageSource,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        _image2 = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Future selectImage3(ImageSource imageSource) async {
    try {
      var pickedImage = await picker.pickImage(
        source: imageSource,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        _image3 = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Future selectImage4(ImageSource imageSource) async {
    try {
      var pickedImage = await picker.pickImage(
        source: imageSource,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        _image4 = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Future getCategory() async {
    try {
      final url = Uri.parse('http://35.213.159.134/category.php?plus');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categoryItem = data;
        });
      } else {
        print("API CATEGORY FAILED");
      }
    } catch (e) {}
    // print(categoryItem);
  }

  Future addPost() async {
    final url = Uri.parse('http://35.213.159.134/ctcreate.php');

    Map<String, String> headers = {
      "Accept": "*/*",
      "Connection": "keep-alive",
    };

    try {
      final request = http.MultipartRequest("POST", url);
      request.fields['ID_Userpost'] = widget.idauthor.toString();
      request.fields['Title'] = titlecontroller.text;
      request.fields['Content'] = storycontroller.text;
      request.fields['Link_VDO'] = urlcontroller.text;
      request.fields['ID_Category'] = selectedCategory!;
      request.fields['Latitude'] = _lat.toString();
      request.fields['Longitude'] = _lng.toString();

      // int i = Random().nextInt(1000000);
      // String nameFile = 'image$i.jpg';

      // photo 1
      var photo01 = await http.MultipartFile.fromPath(
        'Images01',
        _image1!.path,
        filename: _image1!.path,
      );
      request.files.add(photo01);
      // photo 2
      var photo02 = await http.MultipartFile.fromPath(
        'Images02',
        _image2!.path,
        filename: _image2!.path,
      );
      request.files.add(photo02);

      // photo 3
      var photo03 = await http.MultipartFile.fromPath(
        'Images03',
        _image3!.path,
        filename: _image3!.path,
      );
      request.files.add(photo03);

      // photo 4
      var photo04 = await http.MultipartFile.fromPath(
        'Images04',
        _image4!.path,
        filename: _image4!.path,
      );
      request.files.add(photo04);

      request.headers.addAll(headers);

      var response = await request.send();
      if (response.statusCode == 200) {
        print('upload ..');
        // progress between doing
        _progress = 0;
        _timer?.cancel();
        _timer = Timer.periodic(
          const Duration(milliseconds: 100),
          (Timer timer) async {
            EasyLoading.showProgress(
              _progress,
              status: '${(_progress * 100).toStringAsFixed(0)}%',
            );
            _progress += 0.03;

            if (_progress >= 1) {
              EasyLoading.showSuccess('Done');
              _timer?.cancel();
              EasyLoading.dismiss();
              await delayprogress();
              Navigator.of(context).pop(true);
            }

            // else {
            //   EasyLoading.showError('Failed');
            //   _timer?.cancel();
            //   EasyLoading.dismiss();
            // }
          },
        );
      } else {}
    } catch (e) {}
  }

  Future delayprogress() async {
    await Future.delayed(
      Duration(milliseconds: 2000),
    );
  }

  // check validate textfiled + null from image path
  void processaddstory() {
    if (_formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        print('_____# choose 4 images success!');
      } else {
        _showalertImages();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
    EasyLoading.addStatusCallback(
      (status) {
        print('EasyLoading Status $status');
        if (status == EasyLoadingStatus.dismiss) {
          _timer?.cancel();
        }
      },
    );
    initialFile();
    checkPermission();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    storycontroller.dispose();
    urlcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "create.",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.multiply,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // PUBLISH BUTTON
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // check null of images
              if (_image1 == null ||
                  _image2 == null ||
                  _image3 == null ||
                  _image4 == null) {
                // if some of images is null -> show alert box
                return _showalertImages();
              } else if (_formKey.currentState!.validate()) {
                addPost();
                print("_________# published");
              }
            },
            child: Text(
              "Publish",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).requestFocus(
                FocusNode(),
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: titlecontroller,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          showAlertTitle();
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Colors.black,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      autocorrect: false,
                    ),
                    SizedBox(height: 10),

                    // category
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
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
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  selectedCategory = newValue;
                                  getCategory();
                                  print(selectedCategory);
                                },
                              );
                            },
                            items: categoryItem!.map(
                              (item) {
                                return DropdownMenuItem(
                                  child: Text(item['Category']),
                                  value: item['ID_Category'].toString(),
                                );
                              },
                            ).toList()),
                      ),
                    ),
                    SizedBox(height: 26),

                    // image
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Photos',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
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
                                onTap: _chooseimages01,
                                child: Container(
                                  color: Colors.black12,
                                  child: _image1 == null
                                      ? Image.asset('assets/default.png')
                                      : Image.file(
                                          _image1!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _chooseimages02,
                                child: Container(
                                  color: Colors.black12,
                                  child: _image2 == null
                                      ? Image.asset('assets/default.png')
                                      : Image.file(
                                          _image2!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _chooseimages03,
                                child: Container(
                                  color: Colors.black12,
                                  child: _image3 == null
                                      ? Image.asset('assets/default.png')
                                      : Image.file(
                                          _image3!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _chooseimages04,
                                child: Container(
                                  color: Colors.black12,
                                  child: _image4 == null
                                      ? Image.asset('assets/default.png')
                                      : Image.file(
                                          _image4!,
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

                    // url
                    TextFormField(
                      controller: urlcontroller,
                      keyboardType: TextInputType.url,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'youtube.com/yourvideo',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          CupertinoIcons.arrowtriangle_right_square,
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.location,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 350,
                      child: _lat == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_lat!, _lng),
                                zoom: 16.0,
                              ),
                              mapType: MapType.normal,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              onMapCreated: (controller) {},
                              markers: setMarker(),
                            ),
                    ),

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
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          showAlertStory();
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: null,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'type your story this here . .',
                        hintStyle: TextStyle(fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 300),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showalertImages() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: ListTile(
            leading: Icon(
              CupertinoIcons.rectangle_stack_person_crop,
              color: Colors.black,
              size: 21,
            ),
            title: Text('More images'),
            subtitle: Text(
              'Please choose more images.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAlertTitle() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red.shade900,
            size: 50,
          ),
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
      },
    );
  }

  Future<void> showAlertStory() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red.shade900,
            size: 50,
          ),
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
      },
    );
  }

  // delay
  Future<void> delay(int millisec) async {
    print('delay start');
    await Future.delayed(
      Duration(milliseconds: millisec),
    );
    print('delay end');
  }

//////////////////// bottom sheet for image picker ////////////////////

  // bottom sheet 1 : select image from camera or gallery
  void _chooseimages01() => showModalBottomSheet(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
                    Navigator.of(context).pop(_image1);
                    selectImage1(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    Navigator.of(context).pop(_image1);
                    selectImage1(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  // bottom sheet 2
  void _chooseimages02() => showModalBottomSheet(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
                    Navigator.of(context).pop(_image2);
                    selectImage2(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    Navigator.of(context).pop(_image2);
                    selectImage2(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  // bottom sheet 3 : select image from camera or gallery
  void _chooseimages03() => showModalBottomSheet(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
                    Navigator.of(context).pop(_image3);
                    selectImage3(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    Navigator.of(context).pop(_image3);
                    selectImage3(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  // bottom sheet 4
  void _chooseimages04() => showModalBottomSheet(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
                    Navigator.of(context).pop(_image4);
                    selectImage4(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                  title: Text('From Camera'),
                  onTap: () {
                    Navigator.of(context).pop(_image4);
                    selectImage4(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
