import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandmarkSearch extends StatefulWidget {
  const LandmarkSearch({
    Key? key,
    required this.type,
    required this.search,
  }) : super(key: key);
  final String type;
  final String search;
  @override
  State<LandmarkSearch> createState() => _LandmarkSearchState();
}

class _LandmarkSearchState extends State<LandmarkSearch> {
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
  bool typeprovince = false;
  bool typeregion = false;
  String regionName = '';

  @override
  void initState() {
    getPreferences();
    delaydialog();
    setRegionName();
    if (widget.type == 'province') {
      setState(() {
        typeprovince = true;
      });
    } else {
      if (widget.type == 'region') {
        setState(() {
          typeregion = true;
        });
      } else {
        setState(() {
          typeprovince = false;
          typeregion = false;
        });
      }
    }
    super.initState();
  }

  void setRegionName() {
    if (widget.search == '1' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคเหนือ';
      });
    } else if (widget.search == '2' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคใต้';
      });
    } else if (widget.search == '3' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคกลาง';
      });
    } else if (widget.search == '4' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคตะวันออก';
      });
    } else if (widget.search == '5' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคตะวันตก';
      });
    } else if (widget.search == '6' && widget.type == 'region') {
      setState(() {
        regionName = 'ภาคตะวันออกเฉียงเหนือ';
      });
    }
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        isLoading = true;
        searchlandmark();
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

  Future<void> searchlandmark() async {
    String url = '${MyConstant().domain}/application/get_type.php';

    FormData formDataProvince = FormData.fromMap(
      {
        "id": widget.type,
        "Province_name": widget.search,
      },
    );
    FormData formDataRegion = FormData.fromMap(
      {
        "id": widget.type,
        "Region_id": widget.search,
      },
    );

    FormData formDatatype = FormData.fromMap(
      {
        "id": widget.type,
        "Type": widget.search,
      },
    );
    try {
      await Dio()
          .post(url,
              data: typeprovince
                  ? formDataProvince
                  : typeregion
                      ? formDataRegion
                      : formDatatype)
          .then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');
        for (var map in result) {
          landmark = LandmarkModel.fromJson(map);
          setState(
            () {
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
              lastname!,
              email!,
            ),
      body: SafeArea(
        child: CustomScrollView(
          shrinkWrap: true,
          primary: false,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.black54,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        typeprovince
                            ? 'แหล่งท่องเที่ยวจังหวัด ${widget.search}'
                            : typeregion
                                ? 'แหล่งท่องเที่ยว$regionName'
                                : 'แหล่งท่องเที่ยวประเภท${widget.search}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0,
                          fontFamily: 'FC-Minimal-Regular',
                          // overflow:TextOverflow.fade,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CircleButton(
                        icon: MdiIcons.accountDetails,
                        iconSize: 30,
                        onPressed: () {
                          if (!isLoading) {
                            if (userid == '') {
                              MyStyle()
                                  .routeToWidget(context, const Login(), true);
                            } else {
                              scaffoldKey.currentState!.openEndDrawer();
                            }
                          } else {
                            debugPrint('Account');
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    : SliverGrid.extent(
                        maxCrossAxisExtent: 265,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        children: landmarkCards,
                      ),
          ],
        ),
      ),
    );
  }
}
