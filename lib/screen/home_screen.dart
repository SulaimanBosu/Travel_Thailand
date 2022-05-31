import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/favorites.dart';
import 'package:project/screen/landmark.dart';
import 'package:project/screen/popular.dart';
import 'package:project/screen/profile.dart';
import 'package:project/screen/recommend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> listwidgets = [];
  String userid = '', name = '', lastname = '', profile = '';
  late SharedPreferences preferences;
  late UserModel userModel;
  int indexPage = 0;
  bool isDelay = false;

  @override
  void initState() {
    // userid == '' ? indexPage = 3 : indexPage = 0;
    listwidgets.add(const Recommend());
    listwidgets.add(const Popular());
    listwidgets.add(const Favorites());
    listwidgets.add(const Landmark());
    listwidgets.add(const Profile());

    //getPreferences();
    checkUser();
    super.initState();
  }

  // void delaydialog() {
  //   Future.delayed(const Duration(milliseconds: 10000), () {
  //     setState(() {
  //       isDelay = true;
  //       // userid.isEmpty ? indexPage = 3 : indexPage = 0;
  //     });
  //   });
  // }

  // Future<void> getPreferences() async {
  //   preferences = await SharedPreferences.getInstance();
  //   userModel.userId = preferences.getString('User_id')!;
  //   userModel.name = preferences.getString('first_name')!;
  //   userModel.lastname = preferences.getString('last_name')!;
  //   userModel.file = preferences.getString('Image_profile')!;
  // }

  Future checkUser() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
  }

  BottomNavigationBarItem recommend() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.recommend,
        size: 30,
      ),
      label: 'แนะนำ',
    );
  }

  BottomNavigationBarItem popular() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.star,
        size: 30,
      ),
      // ignore: deprecated_member_use
      label: 'ยอดฮิต',
    );
  }

  BottomNavigationBarItem favorites() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite,
        size: 30,
      ),
      // ignore: deprecated_member_use
      label: 'รายการโปรด',
    );
  }

    BottomNavigationBarItem allLandmark() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.add_location_alt_outlined,
        size: 30,
      ),
      // ignore: deprecated_member_use
      label: 'ทั้งหมด',
    );
  }

  BottomNavigationBarItem showprofile() {
    return const BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.accountDetails,
          size: 30,
        ),
        label: 'โปรไฟล์');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
    //  isDelay
          // ? Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height * 0.78,
          //     child: MyStyle().progress(context))
          // : 
          listwidgets[indexPage],
      bottomNavigationBar: showBottomNavigationBar(),
    );
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black54,
        // selectedFontSize: 16,
        // selectedFontSize: 24,

        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          recommend(),
          popular(),
          favorites(),
          allLandmark(),
          showprofile(),
        ],
      );
}
