import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
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

class Popular extends StatefulWidget {
  const Popular({
    Key? key,
  }) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  List<LandmarkModel> popularlandmarks = [];
  late LandmarkModel landmark;
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    readlandmark();
    isLoad();

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
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
  }

  isLoad() {
    Future.delayed(const Duration(milliseconds: 15000), () {
      if (isdata == false) {
        setState(() {
          isLoading = false;
        });
        MyStyle().showdialog(
            context, 'ล้มเหลว', 'ดาวน์โหลดข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง');
      }
    });
  }

  Future<void> readlandmark() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    lat1 = locationData.latitude!;
    lng1 = locationData.longitude!;
    // lat1 = 13.602098;
    // lng1 = 100.624933;

    debugPrint('latitude ============ ${lat1.toString()}');
    debugPrint('longitude ============ ${lng1.toString()}');
    String url = '${MyConstant().domain}/application/getJSON_popular.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          setState(() {
            popularlandmarks.add(landmark);
            lat2 = double.parse(landmark.latitude!);
            lng2 = double.parse(landmark.longitude!);
            distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
            var myFormat = NumberFormat('#0.00', 'en_US');
            distanceString = myFormat.format(distance);
            distances.add(distanceString);

            time = MyApi().calculateTime(distance);
            // debugPrint('time min ============ ${time.toString()}');
            times.add(time);
            isdata = true;
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
        isdata = true;
      });
    }
  }

  Future _refreshData() async {
    setState(() {
      isLoading = true;
      popularlandmarks.clear();
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
                        child: Container(),
                      )
                    : popularlandmarks.isEmpty
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
                                landmarkModel: popularlandmarks,
                                distances: distances,
                                times: times,
                                lat1: lat1,
                                lng1: lng1,
                                userId: userid!,
                                hasmore: false,
                              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
