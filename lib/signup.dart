// ignore_for_file: camel_case_types, must_be_immutable, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'restapi/authenticationapi.dart';

class sign_up extends StatefulWidget {
  const sign_up({
    super.key,
  });

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  bool isComplete = false;
  bool isUpload = false;
  final TextEditingController _name = TextEditingController();

  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final TextEditingController _email = TextEditingController();
  File? file;
  final authentication _obj = new authentication();
  String imageUrl = "";
  dynamic email;

  late String progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFF3EAD44),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _name,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      isComplete = false;
                      return 'Enter a Name';
                    } else {
                      isComplete = true;
                      return null;
                    }
                  }),
                  // enabled: false,
                  cursorColor: const Color(0xFF3EAD44),
                  // initialValue: ,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(color: const Color(0xFF3EAD44)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _mobile,
                  validator: ((value) {
                    String pattern = r"^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$";
                    RegExp regex = RegExp(pattern);
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 10 ||
                        !regex.hasMatch(value)) {
                      isComplete = false;
                      return 'Enter a Mobile Number';
                    } else {
                      isComplete = true;
                      return null;
                    }
                  }),
                  keyboardType: TextInputType.number,
                  // enabled: false,
                  cursorColor: const Color(0xFF3EAD44),
                  // initialValue: ,
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(color: const Color(0xFF3EAD44)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  validator: ((value) {
                    String pattern =
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?)*$";
                    RegExp regex = RegExp(pattern);
                    if (value == null ||
                        value.isEmpty ||
                        !regex.hasMatch(value)) {
                      isComplete = false;
                      return 'Enter a Email Id';
                    } else {
                      isComplete = true;
                      return null;
                    }
                  }),
                  // keyboardType: TextInputType.number,
                  // enabled: false,
                  cursorColor: const Color(0xFF3EAD44),
                  // initialValue: ,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(color: const Color(0xFF3EAD44)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (ValueKey) {
                    if (ValueKey == null ||
                        ValueKey.isEmpty ||
                        ValueKey.length < 8) {
                      isComplete = false;
                      return 'Enter a Password \nPassword Must gratter than 12 letters';
                    } else {
                      isComplete = true;
                      return null;
                    }
                  },
                  controller: _password,
                  style: const TextStyle(),
                  obscureText: true,
                  cursorColor: const Color(0xFF3EAD44),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(color: const Color(0xFF3EAD44)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (ValueKey) {
                    if (ValueKey == null ||
                        ValueKey.isEmpty ||
                        ValueKey != _password.text) {
                      isComplete = false;
                      return 'Confirm Password must be same with Password';
                    } else {
                      isComplete = true;
                      return null;
                    }
                  },
                  controller: _confirmpassword,
                  style: const TextStyle(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // ignore: prefer_const_constructors
                      borderSide: BorderSide(
                          color: const Color.fromRGBO(36, 59, 85, 1)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      bool res = await _obj.signUp(
                        name: _name.text,
                        mobile: _mobile.text,
                        email: _email.text,
                        password: _password.text,
                      );
                      if (res) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    // ignore: prefer_const_constructors
                    child: Text(
                      "Submit",
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
