
import 'package:flutter/material.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  //  exit(0);

 MaterialPageRoute route = MaterialPageRoute(builder: (value) => const Login());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
