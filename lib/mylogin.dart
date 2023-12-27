// // ignore_for_file: library_private_types_in_public_api

// import 'package:treesensus/backend/authentication.dart';
// import 'package:flutter/material.dart';
// import 'package:treesensus/homepage.dart';

// import 'package:treesensus/mysignup.dart';

// class MyLogin extends StatefulWidget {
//   const MyLogin({Key? key}) : super(key: key);

//   @override
//   _MyLoginState createState() => _MyLoginState();
// }

// class _MyLoginState extends State<MyLogin> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final TextEditingController _mobileNo = TextEditingController();
//   bool isComplete = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.05),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // ignore: prefer_const_constructors
//                     Text(
//                       "Welcome Back",
//                       // ignore: prefer_const_constructors
//                       style: TextStyle(
//                           fontSize: 35,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     // ignore: prefer_const_constructors
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Form(
//                       autovalidateMode: AutovalidateMode.always,
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 35, right: 35),
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               validator: (ValueKey) {
//                                 String pattern =
//                                     r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                                     r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                                     r"{0,253}[a-zA-Z0-9])?)*$";
//                                 RegExp regex = RegExp(pattern);
//                                 if (ValueKey == null ||
//                                     ValueKey.isEmpty ||
//                                     !regex.hasMatch(ValueKey)) {
//                                   isComplete = false;
//                                   return 'Enter Email Id';
//                                 } else {
//                                   isComplete = true;
//                                   return null;
//                                 }
//                               },
//                               controller: _email,
//                               style: const TextStyle(color: Colors.black),
//                               decoration: InputDecoration(
//                                   fillColor: Colors.grey.shade100,
//                                   filled: true,
//                                   hintText: "Email",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   )),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             TextFormField(
//                               controller: _password,
//                               validator: (ValueKey) {
//                                 if (ValueKey == null ||
//                                     ValueKey.isEmpty ||
//                                     ValueKey.length < 12) {
//                                   isComplete = false;
//                                   return 'Enter a Password';
//                                 } else {
//                                   isComplete = true;
//                                   return null;
//                                 }
//                               },
//                               style: const TextStyle(),
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                   fillColor: Colors.grey.shade100,
//                                   filled: true,
//                                   hintText: "Phone number",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   )),
//                             ),
//                             const SizedBox(
//                               height: 40,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Login',
//                                   style: TextStyle(
//                                       fontSize: 27,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 CircleAvatar(
//                                   radius: 30,
//                                   backgroundColor: Colors.green,
//                                   child: IconButton(
//                                       color: Colors.white,
//                                       onPressed: () async {
//                                         if (isComplete) {
//                                           if (await Login(
//                                               _email.text, _password.text)) {
//                                             Navigator.pushReplacement(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     HomePage(),
//                                               ),
//                                             );
//                                           }
//                                         }
//                                       },
//                                       icon: const Icon(
//                                         Icons.arrow_forward,
//                                       )),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 40,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Mysignup()));
//                                   },
//                                   // ignore: sort_child_properties_last
//                                   child: const Text(
//                                     "Don't have an account?",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         decoration: TextDecoration.none,
//                                         color: Colors.green,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 17),
//                                   ),
//                                   style: const ButtonStyle(),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Mysignup()));
//                                   },
//                                   child: const Text(
//                                     'Sign Up',
//                                     style: TextStyle(
//                                       decoration: TextDecoration.none,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.green,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
