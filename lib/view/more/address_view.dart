import 'package:flutter/material.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common/globs.dart';
import 'package:food_delivery/common/service_call.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/more/addresses_view.dart';
import 'package:food_delivery/view/on_boarding/on_boarding_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({super.key});

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  int _radiovalue = 0;
  int _selectedValue = 1;
  Map<int, String> dropdownItems = {};
  Map<int, String> areasMap = {};
  String area_str = "";
  _fetchAreas() async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/getAreas_api");
    try {
      var response = await http.get(url);
      String key = "";
      List address = [];
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          key = key;
          // isCatOrPro = value;
          // print("$key" + isCatOrPro.toString());
          // print(value);
          address = value;
          setState(() {});
        });
        areasMap = address.fold({}, (Map<int, String> map, area) {
          map[area['count']] = area['area_name'].toString();
          return map;
        });

        print(areasMap);
        setState(() {});
      } else {
        print("no data found");
      }
    } catch (error) {
      print("error $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  TextEditingController Name = TextEditingController();

  TextEditingController txtMobile = TextEditingController();
  TextEditingController landmark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/img/btn_back.png",
                      width: 20, height: 20),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    "Add Address",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 46,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Name",
              hintText: "firstname",
              controller: Name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "phoneNumber",
              controller: txtMobile,
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "LandMark",
              hintText: "Enter LandMark",
              controller: landmark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Address type: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _radiovalue,
                      onChanged: (value) {
                        setState(() {
                          _radiovalue = value!;
                        });
                      },
                    ),
                    Text(
                      "Home", // Display asterisks or any other representation for password
                      style: TextStyle(fontSize: 16),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _radiovalue,
                      onChanged: (value) {
                        setState(() {
                          _radiovalue = value!;
                        });
                      },
                    ),
                    Text(
                      "Office", // Display asterisks or any other representation for password
                      style: TextStyle(fontSize: 16),
                    ),
                    Radio(
                      value: 2,
                      groupValue: _radiovalue,
                      onChanged: (value) {
                        setState(() {
                          _radiovalue = value!;
                        });
                      },
                    ),
                    Text(
                      "Other", // Display asterisks or any other representation for password
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Area: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButton<int>(
                  value: _selectedValue,
                  onChanged: (int? newValue) {
                    print('Selected value: $newValue');
                    if (newValue != null) {
                      setState(() {
                        _selectedValue = newValue;
                        print(areasMap[newValue]);
                        area_str = areasMap[newValue]!;
                        setState(() {});
                        print('Updated selected value: $_selectedValue');
                      });
                    }
                  },
                  items: areasMap.entries.map<DropdownMenuItem<int>>(
                      (MapEntry<int, String> entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "Save",
                onPressed: () async {
                  String value = (_radiovalue == 0)
                      ? "Home"
                      : (_radiovalue == 1)
                          ? "Office"
                          : (_radiovalue == 2)
                              ? "Other"
                              : "";
                  print(value);
                  print(area_str);
                  final _pref = await SharedPreferences.getInstance();
                  int? cusId = _pref.getInt('cusId');
                  var headers = {'Content-Type': 'application/json'};
                  var request = http.Request('POST',
                      Uri.parse('https://dvp.pythonanywhere.com/add/address'));
                  request.body = json.encode({
                    "name": Name.text,
                    "phone": txtMobile.text,
                    "landmark": landmark.text,
                    "area": area_str,
                    "type": value,
                    "cusId": cusId
                  });
                  request.headers.addAll(headers);
                  // Assuming $e and $p are defined somewhere in your code
                  try {
                    print("datacomes1");
                    http.StreamedResponse response = await request.send();
                    print("Data Sent");
                    if (response.statusCode == 200) {
                      print("in 200 success");
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      print("User Not Found");
                      print("Response Status Code: ${response.statusCode}");
                      var res = await http.Response.fromStream(response);
                      final result =
                          jsonDecode(res.body) as Map<String, dynamic>;
                      setState(() {});
                    }
                  } catch (e) {
                    print("Error: $e");
                  }
                }),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }

  // validation
  // void btnUpdate() {
  //   if (txtFirstName.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterFirstName, () {});
  //     return;
  //   }

  //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(txtFirstName.text)) {
  //     mdShowAlert(Globs.appName, MSG.checkFirstName, () {});
  //     return;
  //   }
  //   if (txtLastName.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterLastName, () {});
  //     return;
  //   }

  //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(txtLastName.text)) {
  //     mdShowAlert(Globs.appName, MSG.checkLastName, () {});
  //     return;
  //   }

  //   if (!txtEmail.text.isEmail) {
  //     mdShowAlert(Globs.appName, MSG.enterEmail, () {});
  //     return;
  //   }

  //   if (txtMobile.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterMobile, () {});
  //     return;
  //   }

  //   if (!RegExp(r'^[0-9]+$').hasMatch(txtMobile.text)) {
  //     mdShowAlert(Globs.appName, MSG.checkMobile, () {});
  //     return;
  //   }
  //   if (txtMobile.text.length < 10) {
  //     mdShowAlert(Globs.appName, MSG.lengthOfMobile, () {});
  //     return;
  //   }

  //   if (txtAddress.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterAddress, () {});
  //     return;
  //   }

  //   // if (txtPassword.text.length < 6) {
  //   //   mdShowAlert(Globs.appName, MSG.enterPassword, () {});
  //   //   return;
  //   // }

  //   // if (txtPassword.text != txtConfirmPassword.text) {
  //   //   mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
  //   //   return;
  //   // }

  //   endEditing();

  //   serviceCallSignUp({
  //     "firstname": txtFirstName.text,
  //     "lastname": txtLastName.text,
  //     "mobile": txtMobile.text,
  //     "email": txtEmail.text,
  //     "address": txtAddress.text,
  //     // "password": txtPassword.text,
  //     "push_token": "",
  //     "device_type": Platform.isAndroid ? "A" : "I"
  //   });
  // }

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svSignUp,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingView(),
            ),
            (route) => false);
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
