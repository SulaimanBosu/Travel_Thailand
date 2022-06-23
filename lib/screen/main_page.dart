import 'package:flutter/material.dart';
import 'package:project/screen/recommend.dart';
import 'package:project/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

    bool isLoading = true;
  String? userid = '',
      name = '',
      lastname = '',
      profile = '',
      phone = '',
      gender = '',
      email = '';
  late SharedPreferences preferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late double screenwidth;
  late double screenhight;


    @override
  void initState() {
    getPreferences();
    super.initState();
  }

  Future<void> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: Recommend(),
      
    );
  }
}