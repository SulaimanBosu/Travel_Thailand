import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
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

class Popular extends StatefulWidget {
  const Popular({Key? key, required this.provinceModel}) : super(key: key);
  final List<ProvinceModel> provinceModel;
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

  // Future<void> getLocation() async {
  //   Location location = Location();
  //   LocationData locationData = await location.getLocation();
  //   location.enableBackgroundMode(enable: true);
  //   lat1 = locationData.latitude!;
  //   lng1 = locationData.longitude!;
  //   debugPrint('latitude ============ ${lat1.toString()}');
  //   debugPrint('longitude ============ ${lng1.toString()}');
  //   distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
  //   var myFormat = NumberFormat('#0.00', 'en_US');
  //   distanceString = myFormat.format(distance);
  //   distances.add(distanceString);

  //   time = MyApi().calculateTime(distance);
  //   // debugPrint('time min ============ ${time.toString()}');
  //   times.add(time);
  // }

  Future<void> readlandmark() async {
    // Location location = Location();
    // LocationData locationData = await location.getLocation();
    // location.enableBackgroundMode(enable: true);
    // lat1 = locationData.latitude!;
    // lng1 = locationData.longitude!;
    lat1 = 13.602098;
    lng1 = 100.624933;

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
            // times.add(10);
            // distances.add('10');

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
        //delaydialog();
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
                : popularlandmarks.isEmpty
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
                            landmarkModel: popularlandmarks,
                            distances: distances,
                            times: times,
                            index: index,
                            lat1: lat1,
                            lng1: lng1,
                            userId: userid!,
                          )
            // SliverToBoxAdapter(
            //   child: popularlandmarks.isEmpty
            //     ? Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height * 0.78,
            //         child: MyStyle().progress(context))
            //     :
            //   Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.78,
            //     // color: Colors.grey[400],
            //     child: showListLandmark(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget showListLandmark() => ListView.builder(
        padding: const EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
        itemCount: popularlandmarks.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            key: Key(popularlandmarks[index].landmarkId!),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: const [
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: const ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: Container(
              decoration: index % 2 == 0
                  ? const BoxDecoration(color: Colors.white60)
                  : BoxDecoration(color: Colors.grey[200]),
              child: Container(
                padding:
                    const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                child: GestureDetector(
                  onTap: () {
                    print('คุณคลิก index = $index');
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(
                            start: 0.0, end: 0.0),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                              imageUrl: '${popularlandmarks[index].imagePath}',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      MyStyle().showProgress(),
                              // CircularProgressIndicator(
                              //     ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      Container(
                        //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                        //   padding: EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.488,
                        height: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    popularlandmarks[index].landmarkName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyStyle().mainTitle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'จังหวัด ${popularlandmarks[index].provinceName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: MyStyle().mainH2Title,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'คะแนน ${popularlandmarks[index].landmarkScore.toString()}/5',
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Expanded(
                                  child: Text(
                                    '102 Km. | (50min) ${popularlandmarks[index].latitude}',
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.black45,
                            size: 30,
                          ),
                          // ignore: unnecessary_statements
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
