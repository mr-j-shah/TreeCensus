// ignore_for_file: avoid_print, prefer_const_constructors, unused_field
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart';

import 'package:searchfield/searchfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'Firestore.dart';
import 'homepage.dart';
import 'restapi/treefromapi.dart';
import 'widgets/custom_form_field.dart';
import 'widgets/custom_validator.dart';
import 'package:dio/dio.dart';

late String progress;

UploadTask? task;

enum PermissionGroup {
  locationAlways,
}

class TreeForm extends StatefulWidget {
  TreeForm({Key? key, required this.email}) : super(key: key);
  String email;
  @override
  _TreeFormState createState() => _TreeFormState();
}

enum SelectedName { local, botanical, none }

class _TreeFormState extends State<TreeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool locationFetched = false;
  bool isSubmitted = false;
  bool isUpload = false;
  late Position _currentPosition;
  String _lat = "00.00000";
  String _long = "00.00000";
  final String _image = "";
  final String _latlong = "00.00000";
  String _landmark = "";
  String address = "";
  String _height = "Select";
  String diameter = "Select";
  String treeHealth = "Green";
  String harmfulPrac = "None of This";
  String ownerType = "Select";
  String botanical = "";
  String loc = "";
  String _date = "";
  String treeId = "";
  String anyotherharmfulPrac = "";
  List<String> bot = [];
  List<String> local = [];
  final TextEditingController _locController = TextEditingController(text: "");
  final TextEditingController _botController = TextEditingController(text: "");

  File? file;
  treeformapi _apiobj = treeformapi();
  String downloadlink = "";
  List<String> healths = ["Infected", "Dried", "Pale", "Green"];
  List<String> practices = [
    "Nails",
    "Boards",
    "Cut Marks",
    "Cemented or paved",
    "Any Other",
    "None of This"
  ];
  List<String> owners = [
    "Select",
    "Public",
    "Private",
  ];
  final List<String> _heightRanges = [
    "Select",
    '0-5ft',
    '5-10ft',
    '10-15ft',
    '15-20ft',
    '20-25ft',
    '25-30ft',
    '30-35ft',
    '35-40ft',
    '40-45ft',
    '45-55ft',
    '55-60ft',
    '60ft and above'
  ];
  List<bool> ui = [false, false, false, false, false];
  bool isComplete = false;
  final List<String> _diameterRanges = [
    "Select",
    '0-1ft',
    '1-2ft',
    '2-3ft',
    '3-4ft',
    '4-5ft',
    '5ft and more'
  ];

  bool validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      return true;
    }
    return false;
  }

  void extractLatLong() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      treeId = 'tree_${DateTime.now().toIso8601String()}';
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        // return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      // print(placemarks);
      Placemark place = placemarks[0];
      String add =
          '${place.street}, ${place.thoroughfare}, ${place.subLocality}';
      print(add);
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      print(formatted);
      var jsonText = await rootBundle.loadString('assets/trees.json');
      var jsonResult = json.decode(jsonText);
      for (int i = 0; i < jsonResult.length; i++) {
        bot.add(jsonResult[i]['ï»¿botanical'].toString());
        local.add(jsonResult[i]['local'].toString());
      }
      print(bot.length);
      print(local.length);
      setState(() {
        _date = formatted;
        _landmark = add;
        _lat = _currentPosition.latitude.toString();
        _long = _currentPosition.longitude.toString();
        locationFetched = true;
      });
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    extractLatLong();
  }

  SelectedName _selectedName = SelectedName.none;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Tagging Form'),
        backgroundColor: const Color(0xFF3EAD44),
        actions: [
          IconButton(
              onPressed: () {
                extractLatLong();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: locationFetched == false
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green[900],
              ),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  isSubmitted == true
                      // ignore: sized_box_for_whitespace
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green[800],
                            ),
                          ),
                        )
                      : Form(
                          key: _formKey,
                          autovalidateMode: _autovalidateMode,
                          child: Column(
                            children: [
                              CustomFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _date = val;
                                  });
                                  print(_date);
                                },
                                labelText: "Date",
                                initialValue: locationFetched == false
                                    ? 'Fetching Date....'
                                    : _date,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _landmark = val;
                                  });
                                  print(_landmark);
                                },
                                labelText: "Landmark",
                                initialValue: locationFetched == false
                                    ? 'Fetching Landmark....'
                                    : _landmark,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _lat = val;
                                  });
                                  print(_lat);
                                },
                                labelText: "Latitude",
                                initialValue: locationFetched == false
                                    ? 'Fetching Latitude....'
                                    : _lat,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _long = val;
                                  });
                                  print(_long);
                                },
                                labelText: "Longitude",
                                initialValue: locationFetched == false
                                    ? 'Fetching Longitude....'
                                    : _long,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: DropdownButtonFormField(
                                  dropdownColor: Colors.green[50],
                                  decoration: InputDecoration(
                                    labelText: "Height",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Cannot Be Empty"),
                                    HeightValidator(),
                                  ]),
                                  hint: const Text("Select height"),
                                  value: _height,
                                  elevation: 1,
                                  isExpanded: true,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  onChanged: (val) {
                                    print(val);
                                    setState(() {
                                      _height = val.toString();
                                      ui[0] = true;
                                    });
                                  },
                                  items: _heightRanges.map((fname) {
                                    return DropdownMenuItem(
                                      child: Text(fname),
                                      value: fname,
                                    );
                                  }).toList(),
                                ),
                              ),
                              ui[0]
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('Botanical Name'),
                                            leading: Radio(
                                              value: SelectedName.botanical,
                                              groupValue: _selectedName,
                                              onChanged: (SelectedName? value) {
                                                setState(() {
                                                  _selectedName = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Local Name'),
                                            leading: Radio(
                                              value: SelectedName.local,
                                              groupValue: _selectedName,
                                              onChanged: (SelectedName? value) {
                                                setState(() {
                                                  _selectedName = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (_selectedName == SelectedName.botanical)
                                  ? Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: SearchField(
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            suggestions: bot
                                                .map(
                                                  (e) => SearchFieldListItem<
                                                      String>(
                                                    e,
                                                    item: e,
                                                  ),
                                                )
                                                .toList(),
                                            searchInputDecoration:
                                                InputDecoration(
                                              labelText: "Botanical Name",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                  errorText: "Cannot Be Empty"),
                                            ]),
                                            onSuggestionTap: (val) {
                                              print(val.item);
                                              setState(() {
                                                botanical = val.item.toString();
                                                ui[1] = true;
                                              });
                                              bool check =
                                                  bot.contains(val.item);
                                              print(check);
                                              if (check == true) {
                                                print("contains");
                                                int index = bot.indexOf(
                                                    val.item.toString());
                                                setState(() {
                                                  _locController.text =
                                                      local[index];
                                                  loc = local[index];
                                                });
                                                print(local);
                                              }
                                            },
                                            maxSuggestionsInViewPort: 6,
                                            itemHeight: 50,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: TextFormField(
                                            controller: _locController,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              labelText: "Local Name",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                  errorText: "Cannot Be Empty"),
                                            ]),
                                            onChanged: (val) {
                                              print(val);
                                              setState(() {
                                                loc = val.toString();
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                              (_selectedName == SelectedName.local)
                                  ? Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: SearchField(
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            suggestions: local
                                                .map(
                                                  (e) => SearchFieldListItem<
                                                      String>(
                                                    e,
                                                    item: e,
                                                  ),
                                                )
                                                .toList(),
                                            searchInputDecoration:
                                                InputDecoration(
                                              labelText: "Local Name",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                  errorText: "Cannot Be Empty"),
                                            ]),
                                            onSuggestionTap: (val) {
                                              print(val.item);
                                              setState(() {
                                                loc = val.item.toString();
                                                ui[1] = true;
                                              });
                                              bool check =
                                                  local.contains(val.item);
                                              print(check);
                                              if (check == true) {
                                                print("contains");
                                                int index = local.indexOf(
                                                    val.item.toString());
                                                setState(() {
                                                  _botController.text =
                                                      bot[index];
                                                  botanical = bot[index];
                                                });
                                                print(local);
                                              }
                                            },
                                            maxSuggestionsInViewPort: 6,
                                            itemHeight: 50,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: TextFormField(
                                            controller: _botController,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              labelText: "Botanical Name",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                  errorText: "Cannot Be Empty"),
                                            ]),
                                            onChanged: (val) {
                                              print(val);
                                              setState(() {
                                                botanical = val.toString();
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 5,
                              ),
                              const SizedBox(height: 5),
                              ui[0]
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: DropdownButtonFormField(
                                        dropdownColor: Colors.green[50],
                                        decoration: InputDecoration(
                                          labelText: "Diameter",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Cannot Be Empty"),
                                          HeightValidator(),
                                        ]),
                                        hint: const Text("Select Diameter"),
                                        value: diameter,
                                        elevation: 0,
                                        isExpanded: true,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            diameter = val.toString();
                                            ui[2] = true;
                                          });
                                        },
                                        items: _diameterRanges.map((fname) {
                                          return DropdownMenuItem(
                                            child: Text(fname),
                                            value: fname,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 5,
                              ),
                              ui[2]
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: DropdownButtonFormField(
                                        dropdownColor: Colors.green[50],
                                        decoration: InputDecoration(
                                          labelText: "Ownership Type",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Cannot Be Empty"),
                                          HeightValidator(),
                                        ]),
                                        hint: const Text("Select Owner Type"),
                                        value: ownerType,
                                        elevation: 0,
                                        isExpanded: true,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            ui[3] = true;
                                            ui[4] = true;
                                            isComplete = true;
                                            ownerType = val.toString();
                                          });
                                        },
                                        items: owners.map((fname) {
                                          return DropdownMenuItem(
                                            child: Text(fname),
                                            value: fname,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              ui[3]
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: DropdownButtonFormField(
                                        dropdownColor: Colors.green[50],
                                        decoration: InputDecoration(
                                          labelText: "Tree Health",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Cannot Be Empty"),
                                          HeightValidator(),
                                        ]),
                                        hint: const Text("Select tree health"),
                                        value: treeHealth,
                                        elevation: 0,
                                        isExpanded: true,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            treeHealth = val.toString();
                                          });
                                        },
                                        items: healths.map((fname) {
                                          return DropdownMenuItem(
                                            child: Text(fname),
                                            value: fname,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              ui[4]
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: DropdownButtonFormField(
                                        dropdownColor: Colors.green[50],
                                        decoration: InputDecoration(
                                          labelText: "Harmful Practices",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Cannot Be Empty"),
                                          HeightValidator(),
                                        ]),
                                        hint: const Text(
                                            "Select harmful practices"),
                                        value: harmfulPrac,
                                        elevation: 0,
                                        isExpanded: true,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            harmfulPrac = val.toString();
                                          });
                                        },
                                        items: practices.map((fname) {
                                          return DropdownMenuItem(
                                            child: Text(fname),
                                            value: fname,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              harmfulPrac == "Any Other"
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              "Any Other Harmful practices",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                          ),
                                        ),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "Cannot Be Empty"),
                                        ]),
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            anyotherharmfulPrac =
                                                val.toString();
                                          });
                                        },
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              isComplete
                                  ? isUpload
                                      ? Container(
                                          padding: EdgeInsets.all(15),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        15),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green[700]),
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                  const TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              child: const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                harmfulPrac == "Any Other"
                                                    ? _submitAnyother(context,
                                                        anyotherharmfulPrac)
                                                    : _submit(context, _image);
                                                // Navigator.pushReplacement(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         HomePage(user: widget.user),
                                                //   ),
                                                // );
                                              },
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: MaterialButton(
                                              minWidth: double.infinity,
                                              height: 60,
                                              onPressed: () {
                                                file == null
                                                    ? _getimage()
                                                    : uploadFile();
                                              },
                                              color: Colors.orange,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Text(
                                                file == null
                                                    ? "Click an image"
                                                    : "Upload Image",
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Container(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  void _submitAnyother(BuildContext context, String s) async {
    try {
      setState(() {
        isSubmitted = true;
      });
      if (validateForm()) {
        print("Submitting");
        print(_lat);
        print(_long);
        print(_height);
        print(_landmark);
        await _apiobj.dataentry(treeId, _height, _lat, _long, _date, diameter,
            s, treeHealth, ownerType, botanical, loc, _landmark, widget.email);
        // Tree treeData = Tree(
        //   treeId: 'tree_${DateTime.now().toIso8601String()}',
        //   height: _height,
        //   latitude: _lat,
        //   longitude: _long,
        //   landmark: _landmark,
        //   date: _date,
        //   diameter: diameter,
        //   harmPrac: s,
        //   health: treeHealth,
        //   ownerType: ownerType,
        //   botanical: botanical,
        //   local: loc,
        // );

        // DatabaseMethods db = DatabaseMethods();

        // await db.addTreeData(treeData, widget.user.uid, widget.user.totalTrees);
        // print(widget.graph);
        // setState(() {
        //   isSubmitted = false;
        //   widget.graph[ownerType.toLowerCase()] += 1;
        //   widget.graph['height'][_height] += 1;
        //   widget.graph[treeHealth] += 1;
        // });
        // print(widget.graph);
        // await db.updateGraphData(widget.graph);
        // ignore: use_build_context_synchronously
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Submission Aleart"),
                  content: Text('Tree Added Sucessfully!!'),
                  actions: [
                    TextButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ));
      } else {
        setState(() {
          _autovalidateMode = AutovalidateMode.always;
          isSubmitted = false;
        });
      }
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(() {
        isSubmitted = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isSubmitted = false;
      });
    }
  }

  void _submit(BuildContext context, String image) async {
    print("Unidentify");
    if (isUpload) {
      try {
        setState(() {
          isSubmitted = true;
        });
        if (validateForm()) {
          print("Submitting");
          print(_lat);
          print(_long);
          print(_height);
          print(_landmark);
          await _apiobj.dataentry(
              treeId,
              _height,
              _lat,
              _long,
              _date,
              diameter,
              harmfulPrac,
              treeHealth,
              ownerType,
              botanical,
              loc,
              _landmark,
              widget.email);
          // Tree treeData = Tree(
          //   treeId: 'tree_${DateTime.now().toIso8601String()}',
          //   height: _height,
          //   latitude: _lat,
          //   longitude: _long,
          //   landmark: _landmark,
          //   date: _date,
          //   diameter: diameter,
          //   harmPrac: harmfulPrac,
          //   health: treeHealth,
          //   ownerType: ownerType,
          //   botanical: botanical,
          //   local: loc,
          // );

          // DatabaseMethods db = DatabaseMethods();

          // await db.addTreeDataUnIdentify(
          //     treeData, widget.user.uid, widget.user.totalTrees, downloadlink);
          // print(widget.graph);
          // setState(() {
          //   isSubmitted = false;
          //   widget.graph[ownerType.toLowerCase()] += 1;
          //   widget.graph['height'][_height] += 1;
          //   widget.graph[treeHealth] += 1;
          // });
          // print(widget.graph);
          // await db.updateGraphData(widget.graph);
          // ignore: use_build_context_synchronously
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Submission Aleart"),
                    content: Text('Tree Added Sucessfully!!'),
                    actions: [
                      TextButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ));
        } else {
          setState(() {
            _autovalidateMode = AutovalidateMode.always;
            isSubmitted = false;
          });
        }
      } on FirebaseException catch (e) {
        print(e.toString());
        setState(() {
          isSubmitted = false;
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          isSubmitted = false;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          //45064C
          // backgroundColor: Color(0xFFF45064C),
          title: Text('Submission Error'),
          content: Text('Please Upload a Image of Trees'),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  uploadFile() async {
    String uploadurl = "https://incipienttechnologies.in/uploadtreeimage.php";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(file!.path, filename: treeId
            //show only filename from path
            ),
      },
    );

    final response = await Dio().post(
      uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          // ignore: prefer_interpolation_to_compose_strings
          progress = "$sent" +
              " Bytes of " "$total Bytes - " +
              percentage +
              " % uploaded";

          //update the progress
        });
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = response.data;
      print(res);
      if (res["success"] && !res["error"]) {
        print("inside block");
        setState(() {
          isUpload = true;
        });
      }
      print(response.toString());
    } else {
      print("Error during connection to server.");
    }
  }

  Future<void> _getimage() async {
    PickedFile? pickedfile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 30);

    setState(() {
      file = File(pickedfile!.path);
      file?.rename('tree_${DateTime.now().toIso8601String()}');
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );

    return result!;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
