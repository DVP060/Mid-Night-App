import 'package:flutter/material.dart';
import 'package:food_delivery/view/home/location.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/login/welcome_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';

import '../../common/globs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => StarupViewState();
}

class StarupViewState extends State<StartupView> {
  static String PREFKEY = 'isLogin';
  getLogin(context) {
    Timer(Duration(seconds: 3), () async {
      final _pref = await SharedPreferences.getInstance();
      var isLogin = _pref.getBool(PREFKEY);
      if (isLogin != null) {
        if (isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LocationIdentifier()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView("")),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView("")),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLogin(context);
  }

  void goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    // welcomePage();
  }

  // void welcomePage() {
  //   if (Globs.udValueBool(Globs.userLogin)) {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => const MainTabView()));
  //   } else {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => const WelcomeView()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/logo1 (1).png",
            width: media.width * 0.55,
            height: media.width * 0.55,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
