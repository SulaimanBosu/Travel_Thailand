// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/gridview_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key? key}) : super(key: key);

  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  late GridViewModel landmark;
  List<Widget> landmarkCards = [];
  int index = 0;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late String userid = '', name = '', lastname = '', profile = '';
  late SharedPreferences preferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    readlandmark();
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
    String url =
        '${MyConstant().domain}/application/get_landmarkRecommended.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        print('Value == $result');
        for (var map in result) {
          landmark = GridViewModel.fromJson(map);

          setState(() {
            landmarkCards.add(CardView(
              landmarkModel: landmark,
              index: index,
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
    return Scaffold(
      key: scaffoldKey,
      endDrawer:
          isLoading ? null : MyDrawer().showDrawer(context, profile, name),
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
                      //icon: Icons.search,
                      icon: MdiIcons.accountDetails,
                      iconSize: 30,
                      onPressed: () {
                        if (userid.isEmpty) {
                          MyStyle().routeToWidget(context, const Login(), true);
                        } else {
                          scaffoldKey.currentState!.openEndDrawer();
                        }
                        debugPrint('Account');
                      }),
                ],
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.78,
                          child: MyStyle().progress(context)),
                    )
                  : landmark.landmarkId == null
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.78,
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
                        )

              // SliverToBoxAdapter(
              //   child: landmarkCards.isEmpty
              //       ? Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height * 0.78,
              //           child: progress(context))
              //       : Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height * 0.78,
              //           //color: Colors.grey[400],
              //           child: GridView.extent(
              //             maxCrossAxisExtent: 265,
              //             mainAxisSpacing: 20,
              //             crossAxisSpacing: 10,
              //             children: landmarkCards,
              //           ),
              //         ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
