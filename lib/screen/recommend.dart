// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/search_widget.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key? key, required this.provinceModel}) : super(key: key);
  final List<ProvinceModel> provinceModel;
  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  late LandmarkModel landmark = LandmarkModel();
  List<LandmarkModel> landmarkModels = [];
  List<LandmarkModel> item = [];
  List<Widget> landmarkCards = [];
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
  String searchValue = '';

  void doSomething(String i) {
    Navigator.pop(context);
    setState(() {});
  }

  @override
  void initState() {
    readlandmark();
    getPreferences();
    readlandmarkSearch();
    setState(() {
      item = landmarkModels;
    });
    // getLocation();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

  Future<void> readlandmarkSearch() async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        // debugPrint('Value == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          landmarkModels.add(landmark);
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> searchAll(String search) async {
    String url = '${MyConstant().domain}/application/search.php';
    FormData formData = FormData.fromMap(
      {
        "searchQuery": search,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);

        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);

          setState(() {
            landmarkCards.add(CardView(
              landmarkModel: landmark,
              index: index,
              readlandmark: () {},
              getPreferences: () {
                setState(() {
                  getPreferences();
                });
              },
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

  Future<void> readlandmark() async {
    String url =
        '${MyConstant().domain}/application/get_landmarkRecommended.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        // debugPrint('Value == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          setState(() {
            landmarkCards.add(CardView(
              landmarkModel: landmark,
              index: index,
              readlandmark: () {},
              getPreferences: () {
                setState(() {
                  getPreferences();
                });
              },
              // isFavorites: false,
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
    setState(() {
      isLoading = true;
      landmarkCards.clear();
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
            isLoading
                ? SliverappBar().appbar(
                    context,
                    screenwidth,
                    userid!,
                    scaffoldKey,
                    true,
                    (() => setState(() {
                          readlandmarkSearch();
                          search = true;
                        })),
                    search, () {
                    setState(() {
                      search = false;
                    });
                  }, (value) {
                    setState(() {
                      searchValue = value;
                      searchLandmark(searchValue);
                      landmarkModels.clear();
                      //   print('searchValue ===== $searchValue');
                    });
                  }, () {})
                : SliverappBar().appbar(
                    context,
                    screenwidth,
                    userid!,
                    scaffoldKey,
                    false,
                    (() => setState(() {
                          readlandmarkSearch();
                          search = true;
                        })),
                    search, () {
                    setState(() {
                      
                      if (searchValue == '') {
                        search = false;
                        landmarkModels.clear();
                        _refreshData();
                      } else {
                        searchValue = '';
                      }
                    });
                  }, (value) {
                    setState(() {
                      searchValue = value;
                      searchLandmark(searchValue);
                        print('searchValue ===== $value');
                    });
                    // if (value.isEmpty) setState(() => readlandmarkSearch());
                    // if (value.isEmpty) setState(() => item.clear());
                  }, () {
                    setState(() {
                      print('onSubmit ===== $searchValue');
                      // searchValue = value;
                      isLoading = true;
                      landmarkCards.clear();
                      index = 0;
                      searchAll(searchValue);
                      search = false;
                    });
                  }),
            CupertinoSliverRefreshControl(
              builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) =>
                  const CupertinoActivityIndicator(
                radius: 10,
              ),
              onRefresh: _refreshData,
            ),
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
                                child: searchBar()),
                          )
                    : search
                        ? SliverToBoxAdapter(
                            child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.amber,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: searchBar()),
                          )

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

                        // ? SliverToBoxAdapter(
                        //     child: Container(
                        //         alignment: Alignment.topCenter,
                        //         color: Colors.amber,
                        //         width: MediaQuery.of(context).size.width,
                        //         height: MediaQuery.of(context).size.height,
                        //         child: Search(
                        //           onClose: () {
                        //             setState(() {
                        //               search = false;
                        //             });
                        //           },
                        //         )),
                        //   )
                        : SliverGrid.extent(
                            maxCrossAxisExtent: 265,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                            children: landmarkCards,
                          )
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Scaffold(
      body: landmarkModels.isEmpty
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                // final landmarkItem = landmarkModels[index];
                return item.isNotEmpty
                    ? ListTile(
                        onTap: () {
                          MyStyle().routeToWidget(context,
                              LandmarkDetail(landmarkModel: item[index]), true);
                        },
                        leading: CachedNetworkImage(
                          imageUrl: item[index].imagePath!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(item[index].landmarkName!),
                      )
                    : Container(
                        child: Center(
                          child: Row(children: const [
                            Icon(Icons.error_outline),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'ไม่พบแหล่งท่องเที่ยว',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 22.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                            )
                          ]),
                        ),
                      );
              }),
    );
  }

  void searchLandmark(String query) {
    setState(() {
      item = landmarkModels
          .where(
            (landmark) =>
                landmark.landmarkName!.toLowerCase().contains(query) ||
                landmark.districtName!.toLowerCase().contains(query) ||
                landmark.amphurName!.toLowerCase().contains(query) ||
                landmark.provinceName!.toLowerCase().contains(query),
          )
          .toList();
    });
    setState(() => landmarkModels = item);
  }
}
