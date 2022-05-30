import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/favorites_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late FavoritesModel landmark;
  List<Widget> landmarkCards = [];
  int index = 0;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late String userid='', name = '', lastname='', profile = '';
  late SharedPreferences preferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    readlandmark();
    getPreferences();
    super.initState();
  }

  // void delaydialog() {
  //   Future.delayed(const Duration(milliseconds: 10000), () {
  //     setState(() {
  //       isLoading = true;
  //       readlandmark();
  //     });
  //   });
  // }

  Future<void> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/post_Favorites.php';
    FormData formData = FormData.fromMap(
      {
        "id": 3,
        "User_id": "U00009",
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');

        for (var map in result) {
          landmark = FavoritesModel.fromJson(map);
          setState(
            () {
              landmarkCards.add(createCard(context, landmark, index));
              index++;
              isLoading = false;
            },
          );
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      //  MyStyle().showdialog(context, 'รายการโปรด', 'ไม่พบรายการโปรด');
      // MyStyle().showdialog(
      //     context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');

      setState(
        () {
          isLoading = false;
        },
      );
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
           MyDrawer().showDrawer(context, profile, name),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            _refreshData();
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
                    icon: MdiIcons.accountDetails,
                    iconSize: 30,
                    onPressed: () {
                      if (userid=='') {
                        routeToWidget(context, const Login());
                      } else {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      debugPrint('Account');
                    },
                  ),
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
                                'ไม่มีรายการโปรด',
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
    FavoritesModel favoritesModel,
    int index,
  ) {
    String imageURL = favoritesModel.imagePath!;
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
                          favoritesModel.landmarkName!,
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
                        Expanded(
                          child: Text(
                            'จังหวัด ${favoritesModel.provinceName}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 16.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'คะแนน ${favoritesModel.landmarkScore}/5',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                        Text(
                          'View ${favoritesModel.landmarkView}',
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

  void routeToWidget(BuildContext context, Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.push(context, route,);
  }
}
