import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifgpdemo/model/user_model.dart';
import 'package:ifgpdemo/screen/home/home_screen.dart';
import 'package:ifgpdemo/screen/main/main_screen.dart';
import 'package:ifgpdemo/screen/profile/profile_screen.dart';
import 'package:ifgpdemo/screen/register/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool showPassword = true;

  login() async {
    var url = Uri.parse("http://35.213.159.134/login.php");

    try {
      var response = await http.post(url, body: {
        "Email": _emailcontroller.text,
        "Passwordd": _passwordcontroller.text,
      });
      // print('response = ${response.body}');
      // print('email : ${_emailcontroller.text}');
      // print('password : ${_passwordcontroller.text}');

      var userdata = json.decode(response.body);

      // check Authentication.
      if (userdata == "error") {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1200),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Email or Username invalid.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
            ),
          );
      } else if (userdata['Status_User'] == "inactive") {
        return openAlertBox();
      } else {
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // preferences.setInt('id', userdata['ID_User']);
        // preferences.setString('username', userdata['Username']);
        // preferences.setString('email', userdata['Email']);

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1800),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Login Success',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.white,
                  ),
                ],
              ),
              backgroundColor: Colors.blue.shade900,
            ),
          );
        // print(userdata);
        await delay(1500);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeScreen(
              email: userdata['Email'],
              username: userdata['Username'],
              iduser: userdata['ID_User'],
              image: userdata['Image'],
            );
          }),
          (route) => false,
        );
        print('id user login : ${userdata['ID_User']}');
      }
    } catch (e) {}
  }

  // delay
  Future<void> delay(int millisec) async {
    // print('delay start');
    await Future.delayed(Duration(milliseconds: millisec));
    // print('delay end');
  }

  @override
  void initState() {
    super.initState();
    _emailcontroller.addListener(() => setState(() {}));
    delay(1500);
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 70),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 100),
                    // text
                    Container(
                      height: 70.0,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back",
                            style: GoogleFonts.lora(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "Log in and continued",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 80),
                    // textfield email + password
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // email
                          TextFormField(
                            validator: (value) {
                              final pattern =
                                  r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                              final regExp = RegExp(pattern);

                              if (value.isEmpty) {
                                return "please enter your email";
                              } else if (!regExp.hasMatch(value)) {
                                return "please enter a valid email";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: _emailcontroller,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,
                                  size: 20, color: Colors.black),
                              suffixIcon: _emailcontroller.text.isEmpty
                                  ? Container(width: 0)
                                  : GestureDetector(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      onTap: () => _emailcontroller.clear(),
                                    ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                              labelText: "Email",
                              hintText: "name@example.com",
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            autocorrect: false,
                            cursorColor: Colors.black,
                          ),
                          SizedBox(height: 21),

                          // password
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter your password";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: _passwordcontroller,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,
                                  size: 20, color: Colors.black),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                child: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 18,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                              labelText: "Password",
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            autocorrect: false,
                            cursorColor: Colors.black,
                            obscureText: showPassword,
                          ),
                          SizedBox(height: 60),

                          // login button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                login();
                              }

                              print('login');
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                elevation: 0.8,
                                minimumSize: Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // goto sign up
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyle(color: Colors.black54)),
                          SizedBox(width: 7),
                          GestureDetector(
                              onTap: () {
                                print("goto Sign up");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return RegisterScreen();
                                  }),
                                  (route) => false,
                                );
                              },
                              child: Text("Sign Up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    // decoration: TextDecoration.combine(
                                    //     [TextDecoration.underline]),
                                  ))),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0))),
            contentPadding: EdgeInsets.only(top: 15.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Account Suspended",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 30.0),
                    child: Center(
                      child: Text(
                        "admin suspend account that violate the rules.",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0)),
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
