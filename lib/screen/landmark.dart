import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class Landmark extends StatefulWidget {
  const Landmark({Key? key}) : super(key: key);

  @override
  State<Landmark> createState() => _LandmarkState();
}

class _LandmarkState extends State<Landmark> {
  List<LandmarkModel> landmarks = [];
  late LandmarkModel landmarkModel;
  List<String> distances = [];
  List<double> times = [];
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late String userid = '', name = '', lastname = '', profile = '';
  late SharedPreferences preferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late double lat1, lng1, lat2, lng2, distance;
  late String distanceString;
  int index = 0;
  double time = 0;

  @override
  void initState() {
    readlandmark();
    //getLocation(index);
    getPreferences();
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        readlandmark();
      });
    });
  }

  Future<void> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
  }

  Future<void> readlandmark() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    lat1 = locationData.latitude!;
    lng1 = locationData.longitude!;
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        // print('Value == $result');
        for (var map in result) {
          landmarkModel = LandmarkModel.fromJson(map);
          setState(() {
            landmarks.add(landmarkModel);
            // debugPrint('latitude ============ ${lat1.toString()}');
            // debugPrint('longitude ============ ${lng1.toString()}');
            lat2 = double.parse(landmarkModel.latitude!);
            lng2 = double.parse(landmarkModel.longitude!);

            distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
            var myFormat = NumberFormat('#0.00', 'en_US');
            distanceString = myFormat.format(distance);
            distances.add(distanceString);

            time = MyApi().calculateTime(distance);
            // debugPrint('time min ============ ${time.toString()}');
            times.add(time);
            isLoading = false;
            index++;
          });
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        isLoading = false;
        //delaydialog();
      });
    }
  }

  // Future<void> getLocation(int index) async {
  //   Location location = Location();
  //   LocationData locationData = await location.getLocation();
  //   location.enableBackgroundMode(enable: true);
  //   lat1 = locationData.latitude!;
  //   lng1 = locationData.longitude!;

  //   debugPrint('latitude ============ ${lat1.toString()}');
  //   debugPrint('longitude ============ ${lng1.toString()}');
  //   lat2 = double.parse(landmarks[index].latitude!);
  //   lng2 = double.parse(landmarks[index].longitude!);
  //   distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
  //   var myFormat = NumberFormat('#0.00', 'en_US');
  //   distanceString = myFormat.format(distance);
  //   distances.add(distanceString);
  //   debugPrint('distance ============ ${distances[3].toString()}');
  //   // return distance;
  // }

  Future _refreshData() async {
    landmarks.clear();
    setState(() {
      isLoading = true;
      readlandmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer:
          isLoading ? null : MyDrawer().showDrawer(context, profile, name),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            _refreshData();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title: const Text(
                  'Travel Thailand',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.2),
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  CircleButton(
                    icon: Icons.search,
                    iconSize: 30,
                    onPressed: () => debugPrint('search'),
                  ),
                  CircleButton(
                    icon: MdiIcons.facebookMessenger,
                    iconSize: 30,
                    onPressed: () => debugPrint('facebookMessenger'),
                  ),
                  CircleButton(
                    icon: MdiIcons.accountDetails,
                    iconSize: 30,
                    onPressed: () {
                      if (userid == '') {
                        MyStyle().routeToWidget(context, const Login(), true);
                      } else {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      debugPrint('Account');
                    },
                  )
                ],
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.78,
                          child: MyStyle().progress(context)),
                    )
                  : landmarks.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.78,
                            child: const Center(
                              child: Text(
                                'ไม่พบรายการ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 24.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ),
                          ),
                        )
                      : Listview(
                          landmarkModel: landmarks,
                          distances: distances,
                          times: times,
                          index: index,
                        )
            ],
          ),
        ),
      ),
    );
  }
}
