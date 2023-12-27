import 'package:flutter/material.dart';
import 'package:kannadtreecensus/homepage.dart';
import 'package:kannadtreecensus/signup.dart';

import 'restapi/authenticationapi.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final authentication _obj = new authentication();
  bool isLoading = false;
  bool isComplete = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
                    child: Text(
                      "TREE CENSUS KANNAD",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Image(
                    width: 200,
                    height: 200,
                    image: AssetImage('assets/images/login_avtar.png'),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 240,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        onChanged: (ValueKey) {
                          setState(() {
                            _email.text = ValueKey;
                          });
                        },
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
                            return 'Enter a valid email address';
                          } else {
                            isComplete = true;

                            return null;
                          }
                        }),

                        // obscureText: true,
                        cursorColor: const Color(0xFF3EAD44),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 238, 238, 1),
                          // border: OutlineInputBorder(),
                          // labelText: 'Email',
                          hintText: 'Email',
                          hintStyle:
                              const TextStyle(color: const Color(0xFF3EAD44)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: const Color.fromRGBO(238, 238, 238, 1)),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: const Color.fromRGBO(238, 238, 238, 1)),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 240,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (ValueKey) {
                          setState(() {
                            _password.text = ValueKey;
                          });
                        },
                        validator: ((value) {
                          // String pattern =
                          //     r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$';
                          // RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            isComplete = false;

                            return 'Enter a Password';
                          } else {
                            isComplete = true;

                            return null;
                          }
                        }),

                        // obscureText: true,
                        cursorColor: const Color(0xFF3EAD44),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 238, 238, 1),
                          // border: OutlineInputBorder(),
                          // labelText: 'Email',
                          hintText: 'Password',
                          hintStyle:
                              const TextStyle(color: const Color(0xFF3EAD44)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: const Color.fromRGBO(238, 238, 238, 1)),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: const Color.fromRGBO(238, 238, 238, 1)),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: InkWell(
                      child: const Text(
                        "No User? Sign Up",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const sign_up()));
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                    child: InkWell(
                      onTap: (() async {
                        setState(() {
                          isLoading = true;
                        });
                        if (isComplete) {
                          bool response =
                              await _obj.login(_email.text, _password.text);
                          if (response) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Aleart"),
                                // ignore: prefer_const_constructors
                                content: Text(
                                    'Please enter Right Username and Password'),
                                actions: [
                                  TextButton(
                                    // ignore: prefer_const_constructors
                                    child: Text(
                                      'Ok',
                                      style: const TextStyle(
                                          color: Color.fromRGBO(36, 59, 85, 1)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Aleart"),
                              // ignore: prefer_const_constructors
                              content: Text('Please Enter Value'),
                              actions: [
                                TextButton(
                                  // ignore: prefer_const_constructors
                                  child: Text(
                                    'Ok',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(36, 59, 85, 1)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        width: 240,
                        height: 60,
                        decoration: BoxDecoration(
                            // ignore: prefer_const_constructors
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF3EAD44),
                                const Color.fromARGB(255, 97, 215, 103)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Adagio Sans",
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
