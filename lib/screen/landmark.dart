import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/list_view.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class Landmark extends StatefulWidget {
  const Landmark({Key? key, required this.provinceModel}) : super(key: key);
  final List<ProvinceModel> provinceModel;
  @override
  State<Landmark> createState() => _LandmarkState();
}

class _LandmarkState extends State<Landmark> {
  List<LandmarkModel> landmarks = [];
  late LandmarkModel landmarkModel;
  List<String> distances = [];
  List<double> times = [];
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
  double lat1 = 0, lng1 = 0, lat2 = 0, lng2 = 0, distance = 0;
  late String distanceString;
  int index = 0;
  double time = 0;
  late double screenwidth;
  late double screenhight;
  bool isdata = false;
  bool search = false;

  @override
  void initState() {
    readlandmark();
    isLoad();
    // getLocation();
    getPreferences();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      readlandmark();
    });
  }

  isLoad() {
    Future.delayed(const Duration(milliseconds: 20000), () {
      if (isdata == false) {
        isLoading = false;

        MyStyle().showdialog(
            context, 'ล้มเหลว', 'ดาวน์โหลดข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง');
      }
    });
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
    Location location = Location();
    LocationData locationData = await location.getLocation();
    //location.enableBackgroundMode(enable: true);
    lat1 = locationData.latitude!;
    lng1 = locationData.longitude!;

    debugPrint('latitude ============ ${lat1.toString()}');
    debugPrint('longitude ============ ${lng1.toString()}');
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
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
            isdata = true;
            index++;
          });
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      isLoading = false;
      isdata = true;
      //delaydialog();
    }
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

  Future _refreshData() async {
    setState(() {
      isLoading = true;
      landmarks.clear();
      distances.clear();
      times.clear();
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
      endDrawer: search
          ? null
          : isLoading
              ? null
              : MyDrawer().showDrawer(context, profile!, name!, lastname!,
                  email!, widget.provinceModel),
      body: SafeArea(
        child: CustomScrollView(
          shrinkWrap: true,
          primary: false,
          physics: const BouncingScrollPhysics(),
          slivers: [
            search
                ? SliverToBoxAdapter(child: Container())
                : isLoading
                    ? SliverappBar().appbar(
                        context,
                        screenwidth,
                        userid!,
                        scaffoldKey,
                        true,
                        (() => setState(() {
                              search = true;
                            })),
                        search,
                      )
                    : SliverappBar().appbar(
                        context,
                        screenwidth,
                        userid!,
                        scaffoldKey,
                        false,
                        (() => setState(() {
                              search = true;
                            })),
                        search,
                      ),
            CupertinoSliverRefreshControl(
              onRefresh: _refreshData,
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: MyStyle().progress(context)),
                  )
                : landmarks.isEmpty
                    ? !search
                        ? SliverToBoxAdapter(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: const Center(
                                child: Text(
                                  'ไม่พบแหล่งท่องเที่ยว',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 24.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.amber,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Search(
                                  onClose: () {
                                    setState(() {
                                      search = false;
                                    });
                                  },
                                )),
                          )
                    : search
                        ? SliverToBoxAdapter(
                            child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.amber,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Search(
                                  onClose: () {
                                    setState(() {
                                      search = false;
                                    });
                                  },
                                )),
                          )
                        : Listview(
                            landmarkModel: landmarks,
                            distances: distances,
                            times: times,
                            index: index,
                            lat1: lat1,
                            lng1: lng1,
                            userId: userid!,
                          ),
          ],
        ),
      ),
    );
  }
}
