import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:kannadtreecensus/models/user.dart';

// ignore: camel_case_types
class treeformapi {
  Future<Map<String, dynamic>> gettreecount(String email) async {
    Map<String, dynamic> data = {};
    String count = "";
    String personalTreeConut = "";
    User c = User.fromJson(await await SessionManager().get("data"));
    email = c.email.toString();
    final res = await http.get(Uri.parse(
        "https://incipienttechnologies.in/gettreecount.php?email=$email"));

    print("https://incipienttechnologies.in/gettreecount.php?email=$email");
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(res.body);
      data = json.decode(res.body);
      count = data["count"];
      personalTreeConut = data["usertree"];
      print(count);
      print(personalTreeConut);
    }
    return data;
  }

  Future<void> dataentry(
      String treeid,
      String height,
      String latitude,
      String longitude,
      String date,
      String diameter,
      String harmfulprac,
      String health,
      String owner,
      String botanical,
      String local,
      String landmark,
      String user) async {
    final res = await http.post(
      Uri.parse('https://incipienttechnologies.in/treeform.php'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(
        <String, dynamic>{
          'treeid': treeid,
          'height': height,
          'latitude': latitude,
          'longitude': longitude,
          'date': date,
          'daimeter': diameter,
          'harmprac': harmfulprac,
          'health': health,
          'owner': owner,
          'botanical': botanical,
          'local': local,
          'landmark': landmark,
          'user': user
        },
      ),
    );
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print("Success");
    } else {
      print("Fail");
    }
  }
}
