import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late LandmarkModel landmark= LandmarkModel();
  List<Widget> landmarkCards = [];
  int index = 0;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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

  @override
  void initState() {
    getPreferences();
    readlandmark();
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
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/post_Favorites.php';
    FormData formData = FormData.fromMap(
      {
        "id": 3,
        "User_id": userid,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');

        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              landmarkCards.add(CardView(
                landmarkModel: landmark,
                index: index,
              ));
              index++;
              isLoading = false;
            },
          );
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
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
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: isLoading
          ? null
          : MyDrawer().showDrawer(
              context,
              profile!,
              name!,
              lastname!,email!
            ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            _refreshData();
          },
          child: CustomScrollView(
            slivers: [
              SliverappBar().appbar(context, screenwidth, userid!, scaffoldKey),
              // SliverAppBar(
              //   brightness: Brightness.light,
              //   backgroundColor: Colors.white,
              //   title: Text(
              //     'Travel Thailand',
              //     style: TextStyle(
              //         color: Colors.redAccent,
              //         fontSize: screenwidth * 0.055,
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: -1.2),
              //   ),
              //   centerTitle: false,
              //   floating: true,
              //   actions: [
              //     CircleButton(
              //       icon: Icons.search,
              //       iconSize: 30,
              //       onPressed: () => debugPrint('search'),
              //     ),
              //     CircleButton(
              //       icon: MdiIcons.facebookMessenger,
              //       iconSize: 30,
              //       onPressed: () => debugPrint('facebookMessenger'),
              //     ),
              //     CircleButton(
              //       icon: MdiIcons.accountDetails,
              //       iconSize: 30,
              //       onPressed: () {
              //         if (userid!.isEmpty) {
              //           MyStyle().routeToWidget(context, const Login(), true);
              //         } else {
              //           scaffoldKey.currentState!.openEndDrawer();
              //         }
              //         debugPrint('Account');
              //       },
              //     ),
              //   ],
              // ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: MyStyle().progress(context)),
                    )
                  : landmark.landmarkId == null
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
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
}
