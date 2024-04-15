import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/on_boarding/startup_view.dart';
import 'package:food_delivery/view/profile/profile_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  // TextEditingController txtAddress = TextEditingController();
  // TextEditingController txtPassword = TextEditingController();
  // TextEditingController txtConfirmPassword = TextEditingController();
  String err = "";

  _sendUserId(BuildContext context) async {
    final _pref = await SharedPreferences.getInstance();
    var customer_id = _pref.getInt("cusId");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://dvp.pythonanywhere.com/getUser'));
    request.body = json.encode({
      "cusId": customer_id,
    });
    request.headers.addAll(headers);
    print(txtFName.text);
    // Assuming $e and $p are defined somewhere in your code
    try {
      print("datacomes1");
      http.StreamedResponse response = await request.send();
      print("Data Sent");
      if (response.statusCode == 200) {
        // If the request is successful (status code 200),
        // navigate to the login screen
        print("response is taken");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        print(result);
        txtFName.text = result["msg"]["firstname"];
        txtLName.text = result["msg"]["lastname"];
        txtEmail.text = result["msg"]["email"];
        txtMobile.text = result["msg"]["phone"].toString();
        setState(() {});
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ProfileView()),
        // );
      } else {
        // If the request is unsuccessful, print the status code
        // and navigate to the login screen
        print("User Not Found");
        print("Response Status Code: ${response.statusCode}");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        err = result['error'];
        setState(() {});
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyRegister()),
        // );
      }
    } catch (e) {
      // If an exception occurs during the request, print the error
      print("Error: $e");
    }
  }

  _updateUserId(BuildContext context) async {
    final _pref = await SharedPreferences.getInstance();
    var customer_id = _pref.getInt("cusId");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://dvp.pythonanywhere.com/update_customer'));
    request.body = json.encode({
      "cusId": customer_id,
      "firstname": txtFName.text,
      "lastname": txtLName.text,
      "email": txtEmail.text,
      "phone": txtMobile.text
    });
    request.headers.addAll(headers);
    print(txtFName.text);
    // Assuming $e and $p are defined somewhere in your code
    try {
      print("datacomes1");
      http.StreamedResponse response = await request.send();
      print("Data Sent");
      if (response.statusCode == 200) {
        // If the request is successful (status code 200),
        // navigate to the login screen
        print("response is taken");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        print(result);
        txtFName.text = result["msg"]["firstname"];
        txtLName.text = result["msg"]["lastname"];
        txtEmail.text = result["msg"]["email"];
        txtMobile.text = result["msg"]["phone"].toString();
        setState(() {});
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ProfileView()),
        // );
      } else {
        // If the request is unsuccessful, print the status code
        // and navigate to the login screen
        print("User Not Found");
        print("Response Status Code: ${response.statusCode}");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        err = result['error'];
        setState(() {});
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyRegister()),
        // );
      }
    } catch (e) {
      // If an exception occurs during the request, print the error
      print("Error: $e");
    }
  }

  @override
  void initState() {
    _sendUserId(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Update Profile",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const MyOrderView()));
                //   },
                //   icon: Image.asset(
                //     "assets/img/shopping_cart.png",
                //     width: 25,
                //     height: 25,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColor.placeholder,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(File(image!.path),
                        width: 100, height: 100, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
          ),
          // TextButton.icon(
          //   onPressed: () async {
          //     image = await picker.pickImage(source: ImageSource.gallery);
          //     setState(() {});
          //   },
          //   icon: Icon(
          //     Icons.edit,
          //     color: TColor.primary,
          //     size: 12,
          //   ),
          //   label: Text(
          //     "Edit Profile",
          //     style: TextStyle(color: TColor.primary, fontSize: 12),
          //   ),
          // ),
          // Text(
          //   "Hi there ${txtName.text}!",
          //   style: TextStyle(
          //       color: TColor.primaryText,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w700),
          // ),
          TextButton(
            onPressed: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainTabView()));
            },
            child: Text(
              "Back To Profile",
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "First Name",
              hintText: "Enter First Name",
              controller: txtFName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Last Name",
              hintText: "Enter Last Name",
              controller: txtLName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              read_only: true,
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
              read_only: true,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Address",
          //     hintText: "Enter Address",
          //     controller: txtAddress,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtPassword,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Confirm Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtConfirmPassword,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "Save",
                onPressed: () {
                  _updateUserId(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileView()));
                }),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }
}
