import 'dart:convert';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
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

class TestLandmark extends StatefulWidget {
  const TestLandmark({
    Key? key,
  }) : super(key: key);

  @override
  State<TestLandmark> createState() => _TestLandmarkState();
}

class _TestLandmarkState extends State<TestLandmark> {
  List<LandmarkModel> landmarks = [];
  List<LandmarkModel> loadmorelandmarks = [];
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
  int page = 0;
  ScrollController _scrollController = ScrollController();
  bool hasmore = true;
  bool loadData = false;

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });
    super.initState();
  }

  Future _loadData() async {
    if (loadData) return;
    loadData = true;

    String url = '${MyConstant().domain}/application/get_landmark.php';
    lat1 = 13.602098;
    lng1 = 100.624933;
    debugPrint('latitude ============ ${lat1.toString()}');
    debugPrint('longitude ============ ${lng1.toString()}');

    FormData formData = FormData.fromMap(
      {
        "Limit": 10,
        "Offset": page,
      },
    );

    await Dio().post(url, data: formData).then((value) {
      var result = json.decode(value.data);
      loadmorelandmarks.clear();
      for (var map in result) {
        landmarkModel = LandmarkModel.fromJson(map);
        setState(
          () {
            loadmorelandmarks.add(landmarkModel);

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
            // page++;
          },
        );
      }
    });

    setState(() {
      // limit = limit + 10;
      loadData = false;
      if (loadmorelandmarks.length < limit) {
        hasmore = false;
      } else {
        page += 10;
        landmarks.addAll(loadmorelandmarks);
        debugPrint('Page ============ ${page.toString()}');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  Future<void> recommentlandmark(int limit, int offset) async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
    // Location location = Location();
    // LocationData locationData = await location.getLocation();
    //location.enableBackgroundMode(enable: true);
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
        //debugPrint('data == $result');
        for (var map in result) {
          landmarkModel = LandmarkModel.fromJson(map);
          setState(
            () {
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
            },
          );
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      isLoading = false;
      isdata = true;
    }
  }

  Future<void> loadmoreLandmark(int limit, int offset) async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
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
        for (var map in result) {
          final landmarkmore = LandmarkModel.fromJson(map);
          setState(
            () {
              loadmorelandmarks.add(landmarkmore);
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
            },
          );
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      // MyStyle().showdialog(
      //     context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      isLoading = false;
      isdata = true;
    }
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
      limit = 10;
      page = 0;
      recommentlandmark(limit, page);
      // readlandmark();
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
            thumbColor: Colors.grey.shade300,
            isAlwaysShown: false,
            scrollbarOrientation: ScrollbarOrientation.right,
            thickness: 5,
            radius: const Radius.circular(5),
            child: CustomScrollView(
              controller: _scrollController,
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
                            : Container(
                                child: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (index < landmarks.length) {
                                        return Container(
                                          child: Slidable(
                                            key: Key(
                                                landmarks[index].landmarkId!),
                                            // startActionPane: ActionPane(
                                            //   motion: const ScrollMotion(),
                                            //   dismissible: DismissiblePane(onDismissed: () {}),
                                            //   children: const [
                                            //     SlidableAction(
                                            //       onPressed: null,
                                            //       backgroundColor: Color(0xFFFE4A49),
                                            //       foregroundColor: Colors.white,
                                            //       icon: Icons.delete,
                                            //       label: 'Delete',
                                            //     ),
                                            //     SlidableAction(
                                            //       onPressed: null,
                                            //       backgroundColor: Color(0xFF21B7CA),
                                            //       foregroundColor: Colors.white,
                                            //       icon: Icons.share,
                                            //       label: 'Share',
                                            //     ),
                                            //   ],
                                            // ),
                                            endActionPane: ActionPane(
                                              dragDismissible: true,
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  autoClose: true,
                                                  flex: 3,
                                                  onPressed: (context) {},
                                                  backgroundColor:
                                                      const Color(0xFF0392CF),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.open_with,
                                                  label: 'เปิด',
                                                ),
                                                SlidableAction(
                                                  autoClose: true,
                                                  flex: 3,
                                                  onPressed: (context) {},
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 224, 2, 2),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.share,
                                                  label: 'share',
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              width: screenwidth,
                                              height: 14.vh,
                                              decoration: index % 2 == 0
                                                  ? const BoxDecoration(
                                                      color: Colors.white)
                                                  : BoxDecoration(
                                                      color: Colors.grey[50]),
                                              child: Container(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                            .only(
                                                        top: 0.0, bottom: 0.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    debugPrint(
                                                        'คุณคลิก index = $index');
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .only(
                                                                start: 0.0,
                                                                end: 0.0),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: 14.vh,
                                                        child: Container(
                                                          child: Card(
                                                            semanticContainer:
                                                                true,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  '${landmarks[index].imagePath}',
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      MyStyle()
                                                                          .showProgress(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            elevation: 5,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                                                        //   padding: EdgeInsets.all(5.0),
                                                        width: 57.vw,
                                                        height: 15.vh,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    landmarks[
                                                                            index]
                                                                        .landmarkName!,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: MyStyle()
                                                                        .mainTitle,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'จังหวัด ${landmarks[index].provinceName}',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: MyStyle()
                                                                        .mainH2Title,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(Icons.star,
                                                                    size: 15,
                                                                    color: landmarks[index].landmarkScore! >=
                                                                            1
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .grey),
                                                                Icon(Icons.star,
                                                                    size: 15,
                                                                    color: landmarks[index].landmarkScore! >=
                                                                            2
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .grey),
                                                                Icon(Icons.star,
                                                                    size: 15,
                                                                    color: landmarks[index].landmarkScore! >=
                                                                            3
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .grey),
                                                                Icon(Icons.star,
                                                                    size: 15,
                                                                    color: landmarks[index].landmarkScore! >=
                                                                            4
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .grey),
                                                                Icon(Icons.star,
                                                                    size: 15,
                                                                    color: landmarks[index].landmarkScore! ==
                                                                            5
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .grey),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '234} Km. | (24hr.)',

                                                                    //overflow: TextOverflow.ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          9.0.sp,
                                                                      fontFamily:
                                                                          'FC-Minimal-Regular',
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    'View ${landmarks[index].landmarkView}',
                                                                    //overflow: TextOverflow.ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          9.0.sp,
                                                                      fontFamily:
                                                                          'FC-Minimal-Regular',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            // const Expanded(
                                                            //   child: Divider(
                                                            //     color: Colors.black54,
                                                            //   ),
                                                            // ),
                                                            Expanded(
                                                              //flex: 1,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  OutlinedButton(
                                                                    style: OutlinedButton
                                                                        .styleFrom(
                                                                      //    fixedSize: const Size(100, 10),
                                                                      minimumSize: Size(
                                                                          27.vw,
                                                                          8.vw),
                                                                      maximumSize: Size(
                                                                          screenwidth /
                                                                              3.7,
                                                                          screenwidth /
                                                                              10),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.location_on,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                15.sp,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            'รายระเอียด',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black54,
                                                                              fontSize: 12.0.sp,
                                                                              fontFamily: 'FC-Minimal-Regular',
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  OutlinedButton
                                                                      .icon(
                                                                    style: OutlinedButton
                                                                        .styleFrom(
                                                                      // fixedSize: const Size(80, 10),
                                                                      minimumSize: Size(
                                                                          27.vw,
                                                                          8.vw),
                                                                      maximumSize: Size(
                                                                          screenwidth /
                                                                              3.7,
                                                                          screenwidth /
                                                                              10),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .navigation_outlined,
                                                                      size: 15,
                                                                    ),
                                                                    label: Text(
                                                                      'นำทาง',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            12.0.sp,
                                                                        fontFamily:
                                                                            'FC-Minimal-Regular',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: hasmore
                                              ? const CupertinoActivityIndicator(
                                                  radius: 20,
                                                )
                                              : const Text('No data'),
                                        );
                                      }
                                    },
                                    childCount: landmarks.length + 1,
                                  ),
                                ),
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
