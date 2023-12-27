import 'package:flutter/material.dart';

class dosanddont extends StatelessWidget {
  dosanddont({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Do's and Don't"),
        backgroundColor: const Color(0xFF3EAD44),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do's and Don'ts",
                    style: TextStyle(
                        height: 1.2,
                        letterSpacing: 0.7,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 30,
                      bottom: 20,
                    ),
                    child: Text(
                      "Do while taking picture of tree: ",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 20,
                    ),
                    child: Text(
                      "1. Stand maximum 1-2 meters from the tree. ",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 20,
                    ),
                    child: Text(
                      "2. Take a picture of leaf of tree. ",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 40,
                      bottom: 10,
                    ),
                    child: Text(
                      "Don't: ",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 20,
                    ),
                    child: Text(
                      "1. Do not take picture too far from the tree.",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
