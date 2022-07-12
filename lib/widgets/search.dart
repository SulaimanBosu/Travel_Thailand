import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/model/province_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.onClose}) : super(key: key);
  final VoidCallback onClose;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<LandmarkModel> landmarkModels = [];
  List<LandmarkModel> item = [];
  LandmarkModel landmarkModel = LandmarkModel();
  // TextEditingController textControllor = TextEditingController();
  late ProvinceModel model;
  List<ProvinceModel> provinceModel = [];

  @override
  void initState() {
    readlandmark();
    province();
    setState(() {
      item = landmarkModels;
    });

    super.initState();
  }

  Future<void> province() async {
    String urlprovince = '${MyConstant().domain}/application/get_province.php';
    FormData formData = FormData.fromMap(
      {
        "Groupby": "p.Province_id",
      },
    );
    await Dio().post(urlprovince, data: formData).then((value) {
      var result = json.decode(value.data);
      //debugPrint('Province == $result');
      for (var map in result) {
        model = ProvinceModel.fromJson(map);
        setState(() {
          provinceModel.add(model);
        });
      }
      debugPrint('Province == ${provinceModel.length}');
    });
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          landmarkModel = LandmarkModel.fromJson(map);
          landmarkModels.add(landmarkModel);
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: landmarkModels.isEmpty
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                // final landmarkItem = landmarkModels[index];
                return ListTile(
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
                );
              }),
    );
  }

  void searchLandmark(String query) {
    setState(() {
      item = landmarkModels
          .where((landmark) =>
              landmark.landmarkName!.toLowerCase().contains(query) ||
              landmark.districtName!.toLowerCase().contains(query) ||
              landmark.amphurName!.toLowerCase().contains(query) ||
              landmark.provinceName!.toLowerCase().contains(query))
          .toList();
    });
    // setState(() => landmarkModels = item);
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
              child: Container(
                height: 36.0,
                width: double.infinity,
                child: CupertinoTextField(
                  // toolbarOptions: const ToolbarOptions(
                  //     copy: true, cut: true, paste: true, selectAll: true),
                  onChanged: ((value) {
                    searchLandmark(value);
                    if (value.isEmpty) setState(() => readlandmark());
                  }),
                  onSubmitted: (value) {
                    MyStyle().routeToWidget(
                        context,
                        SearchBarWidget(
                          provinceModel: provinceModel,
                          searchValue: value,
                        ),
                        true);
                  },
                  //controller: textControllor,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  placeholder: 'ค้นหาแหล่งท่องเที่ยว',
                  placeholderStyle: const TextStyle(
                    color: Color(0xffC4C6CC),
                    fontSize: 14.0,
                    fontFamily: 'Brutal',
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 6.0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xffC4C6CC),
                    ),
                  ),
                  suffix: InkWell(
                    onTap: () {
                      widget.onClose();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: Icon(
                        Icons.close,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffF0F1F5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    Key? key,
    required this.provinceModel,
    required this.searchValue,
  }) : super(key: key);
  final List<ProvinceModel> provinceModel;
  final String searchValue;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
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

  @override
  void initState() {
    getPreferences();
    super.initState();
    searchAll(widget.searchValue);
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
      setState(() {
        // delaydialog();
      });
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
          : MyDrawer().showDrawer(context, profile!, name!, lastname!, email!,
              widget.provinceModel),
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
                        isLoading
                            ? ''
                            : landmark.landmarkId == null
                                ? 'ไม่พบแหล่งท่องเที่ยว'
                                : 'พบแหล่งท่องเที่ยวทั้งหมด ${landmarkCards.length.toString()}',
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
