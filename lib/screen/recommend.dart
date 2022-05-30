// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/model_landmarkRecommended.dart';
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
  List<LandmarkRecommended> landmarkRecommendeds = [];
  late LandmarkRecommended landmark;
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
          landmark = LandmarkRecommended.fromJson(map);

          setState(() {
            landmarkRecommendeds.add(landmark);
            landmarkCards.add(createCard(context, landmark, index));
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
        delaydialog();
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
                          routeToWidget(context, const Login());
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
                          child: progress(context)),
                    )
                  : landmarkCards.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.78,
                            child: const Center(
                              child: Text(
                                'ไม่มีรายการแนะนำ',
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

  void routeToWidget(BuildContext context, Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => true);
  }

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        GridView.extent(
          maxCrossAxisExtent: 265,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          children: landmarkCards,
        ),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const CircularProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      'ดาวน์โหลด...',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget createCard(
    BuildContext context,
    LandmarkRecommended landmarkRecommended,
    int index,
  ) {
    String imageURL = landmarkRecommended.imagePath!;
    return GestureDetector(
      onTap: () {
        debugPrint('you click index $index');
        // MaterialPageRoute route = MaterialPageRoute(
        //   builder: (context) => ShopInfo(
        //     shopModel: infomationShopModels[index],
        //  ),
        // );
        //   Navigator.push(context, route);
      },
      // ignore: avoid_unnecessary_containers
      child: Card(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showImage(context, imageURL),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyStyle().mySizebox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          landmarkRecommended.landmarkName!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'จังหวัด ${landmarkRecommended.provinceName}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16.0,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'คะแนน ${landmarkRecommended.landmarkScore}/5',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                        Text(
                          'View ${landmarkRecommended.landmarkView}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16.0,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container showImage(BuildContext context, String imageURL) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.width * 0.30,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          imageUrl: imageURL,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              MyStyle().showProgress(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(0),
      ),
    );
  }
}
