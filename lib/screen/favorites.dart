import 'dart:convert';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/search.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({
    Key? key,
  }) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late LandmarkModel landmark = LandmarkModel();
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
  bool search = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getPreferences();
    //readlandmark();
    delaydialog();
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        isLoading = true;
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
                readlandmark: () {
                  _refreshData();
                },
                getPreferences: () {
                  setState(() {
                    getPreferences();
                  });
                },
                // isFavorites: true,
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
                        child: Container(
                            // width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height * 0.7,
                            // child: MyStyle().progress(context),
                            ),
                      )
                    : landmark.landmarkId == null
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
}
