// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key? key}) : super(key: key);

  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  late LandmarkModel landmark = LandmarkModel();
  List<Widget> landmarkCards = [];
  int index = 0;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
  double lat1 = 0, lng1 = 0;

  @override
  void initState() {
    readlandmark();
    getPreferences();
    getLocation();
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        readlandmark();
      });
    });
  }

  Future<void> getLocation() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    lat1 = locationData.latitude!;
    lng1 = locationData.longitude!;
    debugPrint('latitude ============ ${lat1.toString()}');
    debugPrint('longitude ============ ${lng1.toString()}');
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

  Future<void> readlandmark() async {
    String url =
        '${MyConstant().domain}/application/get_landmarkRecommended.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);

          setState(() {
            landmarkCards.add(CardView(
              landmarkModel: landmark,
              index: index,
              readlandmark: () {
                // _refreshData();
              },
              // lat: lat1,
              // lng: lng1,
            ));
            index++;
            isLoading = false;
          });
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');

      setState(() {
        isLoading = false;
        // delaydialog();
      });
    }
  }

  Future _refreshData() async {
    landmarkCards.clear();
    setState(() {
      isLoading = true;
      index = 0;
      readlandmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: isLoading
          ? null
          : MyDrawer().showDrawer(context, profile!, name!, lastname!, email!),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            setState(() {
              _refreshData();
            });
          },
          child: CustomScrollView(
            slivers: [
              isLoading
                  ? SliverappBar()
                      .appbar(context, screenwidth, userid!, scaffoldKey, true)
                  : SliverappBar().appbar(
                      context, screenwidth, userid!, scaffoldKey, false),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: MyStyle().progress(context)),
                    )
                  : landmark.landmarkId == null
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: const Center(
                              child: Text(
                                'ไม่พบรายการแนะนำ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 24.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverGrid.extent(
                          maxCrossAxisExtent: 265,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          children: landmarkCards,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
