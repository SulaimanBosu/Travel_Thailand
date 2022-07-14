import 'dart:convert';
import 'dart:io';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_search.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/buildListview_landmark.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late LandmarkModel landmark = LandmarkModel();
  List<Widget> landmarkCards = [];
  List<LandmarkModel> imgList = [];
  List<LandmarkModel> landmarktypebeach = [];
  List<LandmarkModel> landmarktypemountain = [];
  int _current = 0;
  bool isLoadingpage = true;
  double minScele = 1.0;
  double maxScele = 4.0;
  int index = 0;
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
  double lat1 = 0, lng1 = 0;
  bool search = false;

  void doSomething(String i) {
    Navigator.pop(context);
    setState(() {});
  }

  @override
  void initState() {
    readlandmark();
    recommentlandmark();
    getPreferences();
    setState(() {});
    // getLocation();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> recommentlandmark() async {
    String url = '${MyConstant().domain}/application/get_type.php';

    FormData formData = FormData.fromMap(
      {
        "id": 'Type',
        "Type": 'ภูเขา',
      },
    );

    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        //debugPrint('data == $result');
        for (var map in result) {
          LandmarkModel landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              landmarktypemountain.add(landmark);
            },
          );
        }
      });

      FormData formDatatype = FormData.fromMap(
        {
          "id": 'Type',
          "Type": 'ทะเล',
        },
      );

      await Dio().post(url, data: formDatatype).then((value) {
        var result = json.decode(value.data);
        debugPrint('landmarktype == $result');
        for (var map in result) {
          LandmarkModel landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              landmarktypebeach.add(landmark);
            },
          );
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(
        () {},
      );
    }
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
        // debugPrint('Value == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              imgList.add(landmark);
              landmarkCards.add(CardView(
                landmarkModel: landmark,
                index: index,
                readlandmark: () {},
                getPreferences: () {
                  setState(() {
                    getPreferences();
                  });
                },
                // isFavorites: true,
              ));
              index++;
              isLoading = false;
              isLoadingpage = false;
            },
          );
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
    setState(() {
      isLoading = true;
      landmarkCards.clear();
      landmarktypebeach.clear();
      landmarktypemountain.clear();
      imgList.clear();
      index = 0;
      readlandmark();
      recommentlandmark();
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
        backgroundColor: Colors.white,
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
                  builder: (context, refreshState, pulledExtent,
                          refreshTriggerPullDistance, refreshIndicatorExtent) =>
                      const CupertinoActivityIndicator(
                    radius: 10,
                  ),
                  onRefresh: _refreshData,
                ),
                // isLoading ||
                search
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70.vw,
                          child: buildHead(),
                        ),
                      ),

                isLoading || search
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : buildRegionCard(context),

                !isLoading && !search
                    ? SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 5.vw, bottom: 1.vw, right: 5.vw),
                          alignment: Alignment.bottomLeft,
                          width: 10.vw,
                          height: 8.vh,
                          // child: Card(
                          //  // margin: const EdgeInsets.only(left: 5),
                          //   //color: Colors.green,
                          //  // shadowColor: Colors.red,
                          //   elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const Divider(
                                //   color: Colors.black26,
                                //   thickness: 2,
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 1.vw,
                                    ),
                                    Image.asset(
                                      'images/category-icon.png',
                                      scale: 2.5.vw,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 1.vw,
                                    ),
                                    Text(
                                      'หมวดหมู่',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                         // ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                // !isLoading &&
                !search
                    ? buildlist()
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),

                !isLoading && !search
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 0.2.vh, top: 1.vh),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 10.0,
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                !isLoading && !search
                    ? SliverToBoxAdapter(
                        child: Container(
                          width: screenwidth,
                          height: 8.vh,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                left: 20.w,
                                bottom: 1.0.vh,
                                top: 1.0.vh,
                                right: 5.w),
                            width: 100.vw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'อยากเที่ยวทะเลต้องที่นี่เลย..',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const LandmarkSearch(
                                        search: 'ทะเล',
                                        type: 'type',
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                        context, route, (route) => true);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'เพิ่มเติม',
                                        style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            // decorationColor:Colors.black54,
                                            fontFamily: 'FC-Minimal-Regular',
                                            color: Colors.red,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                landmarktypebeach.isEmpty || search
                    //|| isLoading
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : BuildListviewLandmark(
                        screenwidth: screenwidth,
                        listLandmark: landmarktypebeach,
                        index: index,
                      ),
                // !isLoading &&
                !search
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.vh, top: 2.vh),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 10.0,
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),

                !search
                    ? SliverToBoxAdapter(
                        child: Container(
                          width: screenwidth,
                          height: 8.vh,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                left: 20.w,
                                bottom: 0.0.vh,
                                top: 0.0.vh,
                                right: 5.w),
                            width: 100.vw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'แต่ถ้าอยากเที่ยวภูเขาต้องที่นี่เลย..',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const LandmarkSearch(
                                        search: 'ภูเขา',
                                        type: 'type',
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                        context, route, (route) => true);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'เพิ่มเติม',
                                        style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            // decorationColor:Colors.black54,
                                            fontFamily: 'FC-Minimal-Regular',
                                            color: Colors.red,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                landmarktypemountain.isEmpty || search
                    //|| isLoading
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : BuildListviewLandmark(
                        screenwidth: screenwidth,
                        listLandmark: landmarktypemountain,
                        index: index,
                      ),
                // !isLoading &&
                !search
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.vh, top: 2.vh),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 10.0,
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                //!isLoading &&
                !search
                    ? SliverToBoxAdapter(
                        child: Container(
                          width: screenwidth,
                          height: 4.5.vh,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.w, bottom: 1.0.vh),
                            width: 100.vw,
                            child: Text(
                              'แหล่งท่องเที่ยวแนะนำ',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      ),
                // isLoading
                //     ? SliverToBoxAdapter(
                //         child: Container(
                //             width: MediaQuery.of(context).size.width,
                //             height: MediaQuery.of(context).size.height * 0.7,
                //             child: MyStyle().progress(context)),
                //       )
                //     :
                landmark.landmarkId == null
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

                        // ? SliverToBoxAdapter(
                        //     child: Container(
                        //         alignment: Alignment.topCenter,
                        //         color: Colors.amber,
                        //         width: MediaQuery.of(context).size.width,
                        //         height: MediaQuery.of(context).size.height,
                        //         child: SearchWidget(
                        //           onClose: () {
                        //             setState(() {
                        //               search = false;
                        //             });
                        //           },
                        //         )),
                        //   )

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
                        : SliverGrid.extent(
                            maxCrossAxisExtent: 265,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            children: landmarkCards,
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildRegionCard(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70.vw,
          child: Card(
            margin: EdgeInsets.all(5.vw),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.redAccent,
                  margin: EdgeInsets.all(2.vw),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  elevation: 5,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 12.vw, right: 12.vw, top: 1.vh, bottom: 1.vh),
                    width: 50.vw,
                    height: 3.vh,
                    child: Text(
                      'แหล่งท่องเที่ยวแต่ละภูมิภาค',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '1',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-north.png'),
                            backgroundColor: Colors.transparent,
                            radius: 25.sp,
                          ),
                          Text(
                            'ภาคเหนือ',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '2',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-south.png'),
                            backgroundColor: Colors.transparent,
                            radius: 25.sp,
                          ),
                          Text(
                            'ภาคใต้',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '3',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-central.png'),
                            backgroundColor: Colors.transparent,
                            radius: 25.sp,
                          ),
                          Text(
                            'ภาคกลาง',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '4',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-eastern.png'),
                            backgroundColor: Colors.transparent,
                            radius: 25.sp,
                          ),
                          Text(
                            'ภาคตะวันออก',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '5',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-western.jpg'),
                            backgroundColor: Colors.transparent,
                            radius: 20.sp,
                          ),
                          Text(
                            'ภาคตะวันตก',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => const LandmarkSearch(
                            search: '6',
                            type: 'region',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                const AssetImage('images/icon-north-east.png'),
                            backgroundColor: Colors.transparent,
                            radius: 25.sp,
                          ),
                          Text(
                            'ภาคอีสาน',
                            style: TextStyle(fontSize: 11.sp),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget buildHead() {
    return
        // isLoadingpage
        //     ? Container(
        //         width: MediaQuery.of(context).size.width,
        //         height: MediaQuery.of(context).size.height,
        //         color: Colors.white,
        //         child: const CupertinoActivityIndicator(
        //           animating: true,
        //           radius: 15,
        //           color: Colors.white,
        //         ),
        //       )
        //     :
        Builder(
      builder: (context) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                //pageSnapping: true,
                height: screenhight,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                autoPlay: true,
              ),
              items: imgList
                  .map(
                    (item) => Center(
                      child: CachedNetworkImage(
                        width: 100.vw,
                        height: 40.vh,
                        imageUrl: item.imagePath!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Center(
                          child: CupertinoActivityIndicator(
                            animating: true,
                            color: Colors.black54,
                            radius: 15,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 30.0,
                          color: Colors.black54,
                        ),
                        fit: BoxFit.cover,
                        // height: height,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Positioned(
              bottom: 1.vh,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 1.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildlist() {
    return SliverToBoxAdapter(
      child: Container(
        //color: Colors.white,
        width: screenwidth,
        height: 63.vw,
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  //width: 40.vw,
                  //  height: 10 .vh,
                  margin: EdgeInsets.only(left: 2.vw, right: 2.vw),
                  child: GestureDetector(
                      onTap: () {
                        debugPrint('you click index $index');
                        Route route = MaterialPageRoute(
                          builder: (context) => LandmarkSearch(
                            search: itemList[index],
                            type: 'type',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(2), // Border radius
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(30), // Image radius
                                  child: Image.asset(imageList[index]),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.vh,
                          ),
                          Container(
                            width: 25.vw,
                            child: Text(
                              itemList[index],
                              style: TextStyle(fontSize: 12.sp),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 3.vh,
                ),
                Container(
                  //width: 40.vw,
                  //  height: 10 .vh,
                  margin: EdgeInsets.only(left: 2.vw, right: 2.vw),
                  child: GestureDetector(
                      onTap: () {
                        debugPrint('you click index $index');
                        Route route = MaterialPageRoute(
                          builder: (context) => LandmarkSearch(
                            search: itemList2[index],
                            type: 'type',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => true);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(2), // Border radius
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(30), // Image radius
                                  child: Image.asset(
                                    imageList2[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.vh,
                          ),
                          Container(
                            width: 25.vw,
                            child: Text(
                              itemList2[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
