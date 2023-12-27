// ignore_for_file: unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:kannadtreecensus/models/user.dart';

import 'dos_and_dont.dart';
import 'login_page.dart';
import 'restapi/treefromapi.dart';
import 'tree_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  String treecount = "";
  String personalTreecount = "";
  int public = 0;
  int private = 0;
  String _name = "";
  String _email = "";
  bool dataFetching = true;

  Map<String, dynamic> gData = {};
  final treeformapi _obj = treeformapi();

  @override
  void initState() {
    super.initState();
    getdata();
    treecountfun();
  }

  treecountfun() async {
    Map<String, dynamic> trees = await _obj.gettreecount(_email.toString());
    setState(() {
      treecount = trees["count"];
      personalTreecount = trees["usertree"];
      dataFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF3EAD44),
      ),
      body: dataFetching
          // ignore: prefer_const_constructors
          ? Center(
              // ignore: prefer_const_constructors
              child: CircularProgressIndicator(
                color: const Color(0xFF3EAD44),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    width: width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 1.5,
                      color: Colors.green[50],
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Tree Count: ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green),
                            ),
                            Center(
                              child: Text(
                                treecount,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    width: width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 1.5,
                      color: Colors.green[50],
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "User Tree Count: ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green),
                            ),
                            Center(
                              child: Text(
                                personalTreecount,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          "STEPS TO TAG A TREE",
                          style: TextStyle(
                              height: 1.2,
                              letterSpacing: 0.7,
                              fontFamily: 'Solway',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 1: Make a team of 3 volunteers.",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontFamily: 'Solway',
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 2: First member will have paint and a brush.",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 3: Second member will have measuring tape to measure size of bark of a tree. ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 4: Third person will operate the mobile application. ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "[All the volunteers are supposed to install Tree Cenus and Plantnet Application in their mobile phones] ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          "HOW TO TAG A TREE",
                          style: TextStyle(
                              height: 1.2,
                              letterSpacing: 0.7,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        // ignore: prefer_const_constructors
                        child: Text(
                          "Step 1: Stand near the tree and tap on tree form which is shown on the navigation bar in the application. ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              height: 1.2, fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 2: It will automatically take your latitude, longitude, date and landmark.",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 3: Fill the height parameter from the form. ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 4: Select one of the option local name or botanical name from the radio button. If you will insert the local name you will automatically get botanical. If you are not able to identify the species then go to plant net app and point the camera towards the leaf for bark of tree and take a picture. The plant net application will give you botanical name. You will then enter this name in our tree census app. ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 5: Then enter size of bark of tree with the help of measuring tape. ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 6: Then enter the property where the tree situated (Private or Public). ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 7: Then enter the health, and harmful practices on the tree with the help of drop down menu. ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Step 8: Finally upload the image of the tree and tap on submit button.",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "[Now apply the round strap on the tree with the help of paint and brush]",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "[Again to the next tree and then tap on tree form and again follow same steps]",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800]),
              accountName: Text(_name.toString()),
              accountEmail: Text(_email.toString()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/login_avtar.png'),
                radius: 70,
              ),
            ),
            // //
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text(
                'Tree Form',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TreeForm(
                          email: _email.toString(),
                        )));
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text(
                "Do's and Dont's",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => dosanddont(),
                ));
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                await SessionManager().destroy();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const login(),
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> getdata() async {
    User c = User.fromJson(await await SessionManager().get("data"));
    setState(() {
      _name = c.name.toString();
      _email = c.email.toString();
    });
  }
}
