import 'dart:convert';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/list_view.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class Landmark extends StatefulWidget {
  const Landmark({
    Key? key,
  }) : super(key: key);

  @override
  State<Landmark> createState() => _LandmarkState();
}

class _LandmarkState extends State<Landmark> {
  List<LandmarkModel> landmarks = [];
  List<LandmarkModel> loadmorel = [];
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
  int limit = 10;
  int offset = 0;
  ScrollController scrollController = ScrollController();
  bool hasmore = true;

  @override
  void initState() {
    readlandmark();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        readlandmark();
      }
    });
    isLoad();
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
        isdata = true;
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
    if (hasmore != false) {
      String url = '${MyConstant().domain}/application/get_landmark.php';
      // Location location = Location();
      // LocationData locationData = await location.getLocation();
      // location.enableBackgroundMode(enable: true);
      // lat1 = locationData.latitude!;
      // lng1 = locationData.longitude!;
      lat1 = 13.602307598833875;
      lng1 = 100.626533;
      debugPrint('latitude ============ ${lat1.toString()}');
      debugPrint('longitude ============ ${lng1.toString()}');

      FormData formData = FormData.fromMap(
        {
          "Limit": limit,
          "Offset": offset,
        },
      );

      try {
        await Dio().post(url, data: formData).then((value) {
          var result = json.decode(value.data);
          loadmorel.clear();
          for (var map in result) {
            landmarkModel = LandmarkModel.fromJson(map);
            setState(
              () {
                loadmorel.add(landmarkModel);
                lat2 = double.parse(landmarkModel.latitude!);
                lng2 = double.parse(landmarkModel.longitude!);
                distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
                var myFormat = NumberFormat('#0.00', 'en_US');
                distanceString = myFormat.format(distance);
                distances.add(distanceString);
                time = MyApi().calculateTime(distance);
                times.add(time);
                isLoading = false;
                isdata = true;
                index++;
                offset++;
              },
            );
          }
        });

        setState(() {
          if (loadmorel.length < limit) {
            hasmore = false;
          }
          // offset += 10;
          landmarks.addAll(loadmorel);
          debugPrint('Page ============ ${offset.toString()}');
        });
      } catch (error) {
        debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
        MyStyle().showdialog(
            context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
        isLoading = false;
        isdata = true;
      }
    } else {
      setState(() {
        MyStyle().showBasicsFlash(
          context: context,
          text: 'ไม่พบข้อมูล',
          duration: const Duration(seconds: 3),
          flashStyle: FlashBehavior.floating,
        );
      });
    }
  }

  Future<void> readlandmark2() async {
    if (hasmore != false) {
      String url = '${MyConstant().domain}/application/get_landmark.php';
      // Location location = Location();
      // LocationData locationData = await location.getLocation();
      // location.enableBackgroundMode(enable: true);
      // lat1 = locationData.latitude!;
      // lng1 = locationData.longitude!;
      lat1 = 13.602098;
      lng1 = 100.624933;
      debugPrint('latitude ============ ${lat1.toString()}');
      debugPrint('longitude ============ ${lng1.toString()}');

      FormData formData = FormData.fromMap(
        {
          "Limit": limit,
          "Offset": offset,
        },
      );

      try {
        await Dio().post(url, data: formData).then((value) {
          var result = json.decode(value.data);
          // loadmorel.clear();
          for (var map in result) {
            landmarkModel = LandmarkModel.fromJson(map);
            setState(
              () {
                landmarks.add(landmarkModel);
                lat2 = double.parse(landmarkModel.latitude!);
                lng2 = double.parse(landmarkModel.longitude!);
                distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
                var myFormat = NumberFormat('#0.00', 'en_US');
                distanceString = myFormat.format(distance);
                distances.add(distanceString);
                time = MyApi().calculateTime(distance);
                times.add(time);
                isLoading = false;
                isdata = true;
                index++;
                offset++;
              },
            );
          }
        });

        setState(() {
          if (landmarks.length == landmarkModel.landmarkCount) {
            hasmore = false;
          }
          // offset += 10;
          // landmarks.addAll(loadmorel);
          //debugPrint('Page ============ ${offset.toString()}');
        });
      } catch (error) {
        debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
        MyStyle().showdialog(
            context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
        isLoading = false;
        isdata = true;
      }
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
      offset = 0;
      hasmore = true;
      readlandmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
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
        key: scaffoldKey,
        endDrawer: search
            ? null
            : isLoading
                ? null
                : MyDrawer().showDrawer(
                    context,
                    profile!,
                    name!,
                    lastname!,
                    email!,
                  ),
        body: SafeArea(
          child: RawScrollbar(
            controller: scrollController,
            thumbColor: Colors.grey.shade300,
            isAlwaysShown: false,
            scrollbarOrientation: ScrollbarOrientation.right,
            thickness: 5,
            radius: const Radius.circular(5),
            child: CustomScrollView(
              controller: scrollController,
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
                            // width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height * 0.7,
                            // child: MyStyle().progress(context),
                            ),
                      )
                    : landmarks.isEmpty
                        ? !search
                            ? SliverToBoxAdapter(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
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
                                    color: Colors.white,
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
                                    color: Colors.white,
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
                                lat1: lat1,
                                lng1: lng1,
                                userId: userid!,
                                hasmore: hasmore,
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
