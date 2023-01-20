import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinder_fordogs/pages/cards.dart';
import '../services/fire_auth.dart';
import '../services/validators.dart';
import './register.dart';
import 'dart:ui';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print(user.email.toString() + ' is logged in');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Cards()),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Firebase Authentication'),
        // ),

        backgroundColor: Colors.white,

        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login.png'), fit: BoxFit.cover),
          ),
          child: Center(
            child: ClipRect(
              child: Container(
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 3,
                      sigmaY: 3,
                    ),
                    child: Container(
                      height: 360,
                      width: 360,
                    ),
                  ),
                  Container(
                    height: 360,
                    width: 360,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                          )
                        ],
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 1.0),
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Colors.white.withOpacity(0.5),
                        //     Colors.white.withOpacity(0.2)
                        //   ],
                        //   stops: [0.0, 1.0],
                        // ),
                        borderRadius: BorderRadius.circular(20)),
                    child: FutureBuilder(
                      future: _initializeFirebase(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 100,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _emailTextController,
                                        focusNode: _focusEmail,
                                        validator: (value) =>
                                            Validator.validateEmail(
                                          email: value,
                                        ),
                                        decoration: InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          hintText: "Email",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                          password: value,
                                        ),
                                        decoration: InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          hintText: "Password",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24.0),
                                      _isProcessing
                                          ? CircularProgressIndicator()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      _focusEmail.unfocus();
                                                      _focusPassword.unfocus();

                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          _isProcessing = true;
                                                        });

                                                        User? user = await FireAuth
                                                            .signInUsingEmailPassword(
                                                          email:
                                                              _emailTextController
                                                                  .text,
                                                          password:
                                                              _passwordTextController
                                                                  .text,
                                                        );

                                                        setState(() {
                                                          _isProcessing = false;
                                                        });

                                                        if (user != null) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Cards(),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      'Sign In',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 24.0),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Register(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Register',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
