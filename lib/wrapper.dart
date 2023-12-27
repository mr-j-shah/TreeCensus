// // ignore_for_file: must_be_immutable, prefer_final_fields

// import 'package:flutter/material.dart';


// class Wrapper extends StatelessWidget {
//   Auth _auth = Auth();

//   Wrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<UserClass?>(
//         stream: _auth.onAuthStateChanged,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//             UserClass? user = snapshot.data;
//             if (user == null) {
//               print("=======No User===========");
//               return const LoginPage();
//             }
//             print("=======user = ${user.displayName}=====");
//             return HomePage();
//           } else {
//             return const Loading();
//           }
//         });
//   }
// }
