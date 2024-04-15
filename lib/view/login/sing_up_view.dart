import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/login_view.dart';
import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_textfield.dart';
import '../on_boarding/on_boarding_view.dart';
import 'package:http/http.dart' as http;

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  // TextEditingController txtAddress = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  // TextEditingController txtPassword = TextEditingController();
  // TextEditingController txtConfirmPassword = TextEditingController();
  String err = "";

  _login(BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://dvp.pythonanywhere.com/api_data/'));
    request.body = json.encode({
      "firstname": txtFName.text,
      "lastname": txtLName.text,
      "email": txtEmail.text,
      "phone": txtMobile.text,
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
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginView(txtEmail.text)),
        );
      } else {
        // If the request is unsuccessful, print the status code
        // and navigate to the login screen
        print("User Not Found");
        print("Response Status Code: ${response.statusCode}");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        print(result);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Image.asset(
                'assets/img/logo1 (1).png',
                height: 70,
                width: 70,
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text("$err"),
              Text(
                "Add your details to sign up",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "First Name",
                controller: txtFName,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Last Name",
                controller: txtLName,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Mobile No",
                controller: txtMobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 25,
              ),
              // RoundTextfield(
              //   hintText: "Address",
              //   controller: txtAddress,
              // ),
              const SizedBox(
                height: 25,
              ),
              // RoundTextfield(
              //   hintText: "Password",
              //   controller: txtPassword,
              //   obscureText: true,
              // ),
              //  const SizedBox(
              //   height: 25,
              // ),
              // RoundTextfield(
              //   hintText: "Confirm Password",
              //   controller: txtConfirmPassword,
              //   obscureText: true,
              // ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                  title: "Sign Up",
                  onPressed: () {
                    btnSignUp();
                    _login(context);
                    //  Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const OTPView(),
                    //       ),
                    //     );
                  }),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(""),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Action
  void btnSignUp() {
    if (txtFName.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterName, () {});
      return;
    }

    if (txtLName.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterName, () {});
      return;
    }

    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtMobile.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterMobile, () {});
      return;
    }

    // if (txtAddress.text.isEmpty) {
    //   mdShowAlert(Globs.appName, MSG.enterAddress, () {});
    //   return;
    // }

    // if (txtPassword.text.length < 6) {
    //   mdShowAlert(Globs.appName, MSG.enterPassword, () {});
    //   return;
    // }

    // if (txtPassword.text != txtConfirmPassword.text) {
    //   mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
    //   return;
    // }

    endEditing();
  }

  //TODO: ServiceCall

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
