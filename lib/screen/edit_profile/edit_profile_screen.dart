import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernamecontroller;
  TextEditingController email;
  bool editMode = false;
  Timer _timer;
  double _progress;
  File _profilepic;
  String profileimg = " ";
  final picker = ImagePicker();

  _selectprofilepic() async {
    var pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 1920,
    );

    setState(() {
      if (pickedImage != null) {
        profileimg = pickedImage.path;
        _profilepic = File(pickedImage.path);
        print(json.encode(profileimg));
      } else {
        print('No image selected.');
        return;
      }
    });
  }

  // Future editusername() async {
  //   final url = Uri.parse('http://35.213.159.134/profileedit.php');
  //   final response = await http.post(url, body: {
  //     "ID_User": widget.user.iduser.toString(),
  //     "Username": usernamecontroller.text,
  //   });

  //   if (response.statusCode == 200) {
  //     print('success');
  //   } else {
  //     print('failed');
  //   }
  // }

  Future editprofile() async {
    final Uri url = Uri.parse('http://35.213.159.134/profileedit.php');
    int i = Random().nextInt(1000);
    String nameAvatar = 'avatar$i.jpg';

    try {
      var request = http.MultipartRequest("POST", url);
      request.fields['ID_User'] = widget.user.iduser.toString();
      request.fields['Username'] = usernamecontroller.text;

      request.files.add(await http.MultipartFile.fromPath(
          'Image', _profilepic.path,
          filename: nameAvatar));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Uploaded!');
        // progress between doing
        _progress = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(milliseconds: 100),
            (Timer timer) async {
          EasyLoading.showProgress(_progress,
              status: '${(_progress * 100).toStringAsFixed(0)}%');
          _progress += 0.03;

          if (_progress >= 1) {
            EasyLoading.showSuccess('Done');
            _timer?.cancel();
            EasyLoading.dismiss();
            await delay();
            Navigator.of(context).pop(true);
          }
          // else {
          //   EasyLoading.showError('Failed');
          //   _timer?.cancel();
          //   EasyLoading.dismiss();
          // }
        });
      } else {}
      // var avatar = await http.MultipartFile.fromPath('Image', _profilepic.path,
      //     filename: nameAvatar, );
      // request.files.add(avatar);

      // http.StreamedResponse response = await request.send();
      // print(response.statusCode);
      // print(widget.user.iduser.toString());
    } catch (e) {}
  }

  Future delay() async {
    await Future.delayed(Duration(milliseconds: 2000));
  }

  @override
  void initState() {
    usernamecontroller = TextEditingController();
    email = TextEditingController(text: '');
    if (widget.user != null) {
      usernamecontroller.text = widget.user.username;
      email.text = widget.user.email;
    } else {
      widget.user.username = widget.user.username;
      widget.user.email = widget.user.email;
    }
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              editprofile();
              // editusername();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.blue.shade900,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    widget.user.image == null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: _profilepic == null
                                ? AssetImage('assets/second.png')
                                : FileImage(File(_profilepic.path)),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: _profilepic == null
                                ? NetworkImage(
                                    'http://35.213.159.134/avatar/${widget.user.image}')
                                : FileImage(File(_profilepic.path)),
                          ),
                    TextButton(
                      onPressed: () {
                        _selectprofilepic();
                      },
                      child: Text(
                        'Change profile picture',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // username
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              // email
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
