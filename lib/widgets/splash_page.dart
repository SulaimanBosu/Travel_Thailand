import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/utility/my_api.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/logo.png'),
      logoSize: 250,
      backgroundColor: Colors.white,
      showLoader: false,
      // loadingText: const Text("Loading..."),
      navigator: const HomeScreen(
        index: 0,
      ),
      durationInSeconds: 3,
    );
  }
}
