import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/province_model.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/favorites.dart';
import 'package:project/screen/landmark.dart';
import 'package:project/screen/main_page.dart';
import 'package:project/screen/popular.dart';
import 'package:project/ProfilePage/profile.dart';
import 'package:project/screen/test_landmark.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> listwidgets = [];
  String? userid, name, lastname, profile;
  late SharedPreferences preferences;
  late UserModel userModel;
  late int indexPage;
  bool isDelay = false;
  late ProvinceModel model;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    indexPage = widget.index;
    delaydialog();
    province();
    listwidgets.add(const MainPage());
    listwidgets.add(const Popular());
    listwidgets.add(const Favorites());
    listwidgets.add(const Landmark());
    listwidgets.add(const Profile());
    checkUser();
    super.initState();
  }

  Future<void> province() async {
    String urlprovince = '${MyConstant().domain}/application/get_province.php';
    FormData formData = FormData.fromMap(
      {
        "Groupby": "p.Province_id",
      },
    );
    await Dio().post(urlprovince, data: formData).then((value) {
      var result = json.decode(value.data);
      //debugPrint('Province == $result');
      for (var map in result) {
        model = ProvinceModel.fromJson(map);
        setState(() {
          provinceModel.add(model);
          isDelay = true;
        });
      }
      debugPrint('Province == ${provinceModel.length}');
    });
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isDelay = true;
      });
    });
  }

  Future checkUser() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
  }

  BottomNavigationBarItem homePage() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.recommend_outlined,
        size: 30,
      ),
      label: 'หน้าหลัก',
    );
  }

  BottomNavigationBarItem popular() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.star_outline_outlined,
        size: 30,
      ),
      // ignore: deprecated_member_use
      label: 'ยอดฮิต',
    );
  }

  BottomNavigationBarItem favorites() {
    return const BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite_outline_outlined,
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
    return BottomNavigationBarItem(
        icon: profile == null
            ? const Icon(
                MdiIcons.accountDetails,
                size: 30,
              )
            : CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(2), // Border radius
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(19), // Image radius
                      child: CachedNetworkImage(
                        imageUrl: MyConstant().domain + profile!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                MyStyle().showProgress(),
                        errorWidget: (context, url, error) =>
                            Image.asset('images/iconprofile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
        label: 'โปรไฟล์');
  }

  @override
  Widget build(BuildContext context) {
    return !isDelay
        ? BlurryModalProgressHUD(
            inAsyncCall: !isDelay,
            blurEffectIntensity: 4,
            progressIndicator: Material(
              type: MaterialType.transparency,
              child: JumpingDotsProgressIndicator(
                color: Colors.red,
                fontSize: 50.0.sp,
              ),
            ),
            dismissible: false,
            opacity: 0.4,
            color: Colors.black38,
            child: Scaffold(
              body: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  // child: MyStyle().progress(context),
                  ),
            ),
          )
        : Scaffold(
            body: listwidgets[indexPage],
            bottomNavigationBar: showBottomNavigationBar(),
          );
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
        // backgroundColor: Colors.blue,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 12,
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        showUnselectedLabels: true,
        // selectedFontSize: 24,

        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          homePage(),
          popular(),
          favorites(),
          allLandmark(),
          showprofile(),
        ],
      );
}
