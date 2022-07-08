// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key? key, required this.provinceModel}) : super(key: key);
  final List<ProvinceModel> provinceModel;
  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  late LandmarkModel landmark = LandmarkModel();
  List<Widget> landmarkCards = [];
  List<LandmarkModel> imgList = [];
  List<LandmarkModel> landmarktype = [];
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

    FormData formDataProvince = FormData.fromMap(
      {
        "id": 'province',
        "Province_name": landmark.provinceName,
      },
    );

    try {
      // await Dio().post(url, data: formDataProvince).then((value) {
      //   var result = json.decode(value.data);
      //   //debugPrint('data == $result');
      //   for (var map in result) {
      //     LandmarkModel landmark = LandmarkModel.fromJson(map);
      //     setState(
      //       () {
      //         if (landmark.landmarkId != widget.landmark.landmarkId) {
      //           landmarkProvince.add(landmark);
      //           isProvinceLoading = false;
      //         }
      //       },
      //     );
      //   }
      // });

      FormData formDatatype = FormData.fromMap(
        {
          "id": 'Type',
          "Type": landmark.type,
        },
      );

      await Dio().post(url, data: formDatatype).then((value) {
        var result = json.decode(value.data);
        //debugPrint('data == $result');
        for (var map in result) {
          LandmarkModel landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              if (landmark.landmarkId != landmark.landmarkId) {
                landmarktype.add(landmark);
              }
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
        debugPrint('Value == $result');
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
      imgList.clear();
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
              : MyDrawer().showDrawer(
                  context,
                  profile!,
                  name!,
                  lastname!,
                  email!,
                  widget.provinceModel,
                ),
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
              builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) =>
                  const CupertinoActivityIndicator(
                radius: 10,
              ),
              onRefresh: _refreshData,
            ),
            isLoading || search
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30.vh,
                      child: buildHead(),
                    ),
                  ),
            // !isLoading
            //     ? SliverToBoxAdapter(
            //         child: Container(

            //           margin: EdgeInsets.only(top: 4.vh, bottom: 4.vh),
            //           child: Divider(
            //             color: Colors.grey.shade200,
            //             thickness: 10,
            //           ),
            //         ),
            //       )
            //     : SliverToBoxAdapter(
            //         child: Container(),
            //       ),
            landmarktype.isNotEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                        width: screenwidth,
                        height: 12.vh,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 7.h, top: 7.h),
                              child: Divider(
                                color: Colors.grey.shade200,
                                thickness: 1.0,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w, bottom: 5.h),
                              width: 100.vw,
                              child: const Text(
                                'แหล่งท่องเที่ยวประเภทเดียวกัน',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 7.h, top: 7.h),
                              child: Divider(
                                color: Colors.grey.shade200,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        )),
                  )
                : SliverToBoxAdapter(
                    child: Container(),
                  ),

            landmarktype.isNotEmpty
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : buildListviewlandmark(landmarktype, index),
            isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: MyStyle().progress(context)),
                  )
                : landmark.landmarkId == null
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
    );
  }

  Widget buildHead() {
    return isLoadingpage
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: const CupertinoActivityIndicator(
              animating: true,
              radius: 15,
              color: Colors.white,
            ),
          )
        : Builder(
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
                              height: 30.vh,
                              imageUrl: item.imagePath!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: CupertinoActivityIndicator(
                                  animating: true,
                                  color: Colors.white,
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
                              color: (Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
  }

  SliverToBoxAdapter buildListviewlandmark(
      List<LandmarkModel> listLandmark, int index) {
    return SliverToBoxAdapter(
      child: Container(
        width: screenwidth,
        height: 26.vh,
        child: ListView.builder(
          itemCount: listLandmark.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 40.vw,
              //  height: 10 .vh,
              margin: EdgeInsets.only(left: 1.5.vw, right: 1.5.vw),
              child: GestureDetector(
                onTap: () {
                  debugPrint('you click index $index');
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => LandmarkDetail(
                      landmarkModel: listLandmark[index],
                    ),
                  );
                  Navigator.push(context, route).then((value) {});
                },
                // ignore: avoid_unnecessary_containers
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  //  elevation: 5,
                  //  color: Colors.grey[300],
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          width: screenwidth,
                          height: 16.vh,
                          imageUrl: listLandmark[index].imagePath!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyStyle().mySizebox(),
                            Text(
                              listLandmark[index].landmarkName!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                              textAlign: TextAlign.start,
                            ),

                            Text(
                              'จังหวัด ${listLandmark[index].provinceName}',
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 12.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                1
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                2
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                3
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                4
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! ==
                                                5
                                            ? Colors.orange
                                            : Colors.grey),
                                  ],
                                ),
                                Text(
                                  'View ${listLandmark[index].landmarkView}',
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: screenhight * 0.01,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
