import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifgpdemo/model/db_user.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:ifgpdemo/screen/main/main_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  bool showPassword = true;
  bool showConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    usernamecontroller.addListener(() => setState(() {}));
    emailcontroller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 70),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // back button
              // Container(
              //   child: InkWell(
              //     child: Icon(
              //       Icons.keyboard_backspace,
              //       color: Colors.black,
              //       size: 20,
              //     ),
              //     onTap: () {
              //       print('back');
              //       // Navigator.pop(context);
              //     },
              //   ),
              // ),
              SizedBox(height: 30),
              // text
              Container(
                height: 70.0,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create your account",
                      style: GoogleFonts.lora(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Sign up and get started",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // textfield username + email + password + confirm
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // username
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter your email";
                        } else if (value.length < 4) {
                          return "Username must be at least 4 characters";
                        }

                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: usernamecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.face, size: 20, color: Colors.black),
                        suffixIcon: usernamecontroller.text.isEmpty
                            ? Container(width: 0)
                            : GestureDetector(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onTap: () => usernamecontroller.clear(),
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
                        labelText: "Username",
                        // hintText: "name@example.com",
                        // hintStyle: TextStyle(
                        //   fontSize: 12.0,
                        //   fontWeight: FontWeight.w500,
                        //   color: Colors.black.withOpacity(0.7),
                        // ),
                        labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      autocorrect: false,
                      cursorColor: Colors.black,
                    ),
                    SizedBox(height: 21),

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
                      controller: emailcontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email, size: 20, color: Colors.black),
                        suffixIcon: emailcontroller.text.isEmpty
                            ? Container(width: 0)
                            : GestureDetector(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onTap: () => emailcontroller.clear(),
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
                          color: Colors.black.withOpacity(0.7),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.7),
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
                      controller: passwordcontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock, size: 20, color: Colors.black),
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
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      autocorrect: false,
                      cursorColor: Colors.black,
                      obscureText: showPassword,
                    ),
                    SizedBox(height: 21),

                    // confirm password
                    TextFormField(
                      validator: (value) {
                        if (value != passwordcontroller.value.text) {
                          return "Password don't match, please try again";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: confirmpasswordcontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock, size: 20, color: Colors.black),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                          child: Icon(
                            showConfirmPassword
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
                        labelText: "Confirm Password",
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      autocorrect: false,
                      cursorColor: Colors.black,
                      obscureText: showConfirmPassword,
                    ),
                    SizedBox(height: 32),

                    // regis button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          register();
                          // UserDB userDB = UserDB(
                          //   email: emailcontroller.text.trim(),
                          // );

                          // var result =
                          //     Provider.of<UserProvider>(context, listen: false)
                          //         .createUser(userDB);
                          // if (result != 'OK') {
                          //   print(result);
                          // } else {
                          //   print('Successfully');
                          // }
                        }

                        print('register');
                      },
                      child: Text(
                        'Register',
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

              // goto Login
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(color: Colors.black54)),
                    SizedBox(width: 7),
                    GestureDetector(
                        onTap: () {
                          print("goto Login");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }),
                            (route) => false,
                          );
                        },
                        child: Text("Login",
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
          ),
        ),
      ),
    );
  }

  register() async {
    final url = Uri.parse("http://35.213.159.134/register.php");
    final response = await http.post(url, body: {
      "Username": usernamecontroller.text,
      "Email": emailcontroller.text,
      "Passwordd": passwordcontroller.text,
    });

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      if (result == "error") {
        print("This email already exists.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'username or email already exists',
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
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Account successfully created.',
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
        await delay(1700);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }),
          (route) => false,
        );
      }

      return result;
    } else {
      return 'error';
    }
  }

  // delay
  Future<void> delay(int millisec) async {
    print('delay start');
    await Future.delayed(Duration(milliseconds: millisec));
    print('delay end');
  }
}
