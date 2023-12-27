// ignore_for_file: prefer_const_constructors_in_immutables, camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:kannadtreecensus/homepage.dart';
import 'package:kannadtreecensus/models/user.dart';

import 'login_page.dart';

// import 'package:treesensus/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kannad Treecensus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Solway',
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.green[900],
            selectionHandleColor: Colors.green[900]),
        primarySwatch: Colors.blue,
      ),
      home: splashscreen(),
    );
  }
}

class splashscreen extends StatefulWidget {
  splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  bool _islogin = false;
  bool _isconnected = false;
  void initState() {
    super.initState();
    checksession().then((value) {
      _islogin = value;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _islogin ? const HomePage() : const login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Image(
                  image: AssetImage('assets/images/kannad.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checksession() async {
    // var connectivityResult = await connectivity.checkConnectivity();
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    //   _isconnected = true;
    // }
    User c = User.fromJson(await await SessionManager().get("data"));
    dynamic id = c.email;
    if (id != null) {
      return true;
    }
    return false;
  }
}
