import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:kannadtreecensus/models/user.dart';

class authentication {
  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('https://incipienttechnologies.in/login.php'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(
        <String, dynamic>{
          'username': email,
          'password': password,
        },
      ),
    );
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print("Success");
      Map<String, dynamic> resposne = jsonDecode(res.body);
      if (resposne["status"] == "success") {
        print(resposne["image"]);
        await SessionManager().set(
            "data",
            User(
                name: resposne["name"],
                email: resposne["email"],
                mobile: resposne["mobile"]));

        return true;
      }
      return false;
    } else {
      print("Fail");
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String mobile,
    required String email,
    required String password,
  }) async {
    print("----Sign Up-----");
    print("Name :: $name");
    print("Mobile :: $mobile");
    print("Email :: $email");
    print("Passwprd :: $password");
    final response = await http.post(
      Uri.parse('https://incipienttechnologies.in/signup.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        <String, dynamic>{
          'name': name,
          'mobile': mobile,
          'email': email,
          'password': password,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"] == "Success") {
        return true;
      } else {
        print("Fail");
        return false;
      }
    } else {
      print("Fail");
      return false;
    }
  }
}
