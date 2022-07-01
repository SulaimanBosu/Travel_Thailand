import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);
  final VoidCallback onClose;
  // final void Function(List) callback;
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final List<LandmarkModel> landmarks = [];
  final List<LandmarkModel> landmarksPopular = [];
  bool isLoadding = true;
  double screenwidth = 0;
  double screenhight = 0;
  TextEditingController textControllor = TextEditingController();

  @override
  void initState() {
    readlandmark();
    readlandmarkPopular();
    super.initState();
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          LandmarkModel landmarkModel = LandmarkModel.fromJson(map);
          setState(() {
            landmarks.add(landmarkModel);
            // isLoadding = false;
          });
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> readlandmarkPopular() async {
    String url = '${MyConstant().domain}/application/getJSON_popular.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          LandmarkModel landmarkModel = LandmarkModel.fromJson(map);
          setState(() {
            landmarksPopular.add(landmarkModel);
            isLoadding = false;
          });
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
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            //   margin: EdgeInsets.only(top: 40),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: SearchableList<LandmarkModel>.sliver(
                        textInputType: TextInputType.text,
                        initialList: textControllor.text.isEmpty
                            ? landmarksPopular
                            : landmarks,
                        builder: (LandmarkModel landmarkModel) => LandmarkItem(
                          landmarkModel: landmarkModel,
                        ),
                        searchFieldEnabled: true,
                        displayClearIcon: false,
                        searchTextController: textControllor,
                        filter: _landmarkList,
                        emptyWidget: isLoadding
                            ? MyStyle().showProgress()
                            : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.error_outline),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('ไม่พบแหล่งท่องเที่ยว')
                                  ],
                                ),
                            ),
                        onItemSelected: (LandmarkModel item) {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) =>
                                LandmarkDetail(landmarkModel: item),
                          );
                          Navigator.pushAndRemoveUntil(
                              context, route, (route) => true);
                        },
                        inputDecoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.search_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              if (textControllor.text.isEmpty) {
                                widget.onClose();
                              } else {
                                setState(() {
                                  textControllor.clear();
                                });
                              }

                              //Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Icon(
                                Icons.close,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                          hintText: "ค้นหาแหล่งท่องเที่ยว",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool onTab = false;
    setState(() {
      widget.onClose();
    });
    return onTab;
  }

  List<LandmarkModel> _landmarkList(String searchTerm) {
    return textControllor.text.isEmpty
        ? landmarksPopular.toList()
        : landmarks
            .where(
              (element) =>
                  element.landmarkName!.toLowerCase().contains(searchTerm) ||
                  element.districtName!.toLowerCase().contains(searchTerm) ||
                  element.amphurName!.toLowerCase().contains(searchTerm) ||
                  element.provinceName!.toLowerCase().contains(searchTerm),
            )
            .toList();
  }
}

class LandmarkItem extends StatefulWidget {
  const LandmarkItem({Key? key, required this.landmarkModel}) : super(key: key);
  final LandmarkModel landmarkModel;

  @override
  State<LandmarkItem> createState() => _LandmarkItemState();
}

class _LandmarkItemState extends State<LandmarkItem> {
  double screenwidth = 0;
  double screenhight = 0;

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: Container(
        width: screenwidth,
        height: screenhight * 0.16,
        child: Container(
          padding: const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
          child: GestureDetector(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) =>
                    LandmarkDetail(landmarkModel: widget.landmarkModel),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Container(
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        imageUrl: '${widget.landmarkModel.imagePath}',
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
                      margin: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                Container(
                  //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                  //   padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width * 0.488,
                  height: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.landmarkModel.landmarkName!,
                              overflow: TextOverflow.ellipsis,
                              style: MyStyle().mainTitle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'จังหวัด ${widget.landmarkModel.provinceName}',
                              overflow: TextOverflow.ellipsis,
                              style: MyStyle().mainH2Title,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star,
                              size: 15,
                              color: widget.landmarkModel.landmarkScore! >= 1
                                  ? Colors.orange
                                  : Colors.grey),
                          Icon(Icons.star,
                              size: 15,
                              color: widget.landmarkModel.landmarkScore! >= 2
                                  ? Colors.orange
                                  : Colors.grey),
                          Icon(Icons.star,
                              size: 15,
                              color: widget.landmarkModel.landmarkScore! >= 3
                                  ? Colors.orange
                                  : Colors.grey),
                          Icon(Icons.star,
                              size: 15,
                              color: widget.landmarkModel.landmarkScore! >= 4
                                  ? Colors.orange
                                  : Colors.grey),
                          Icon(Icons.star,
                              size: 15,
                              color: widget.landmarkModel.landmarkScore! == 5
                                  ? Colors.orange
                                  : Colors.grey),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'View ${widget.landmarkModel.landmarkView}',
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 10.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black54,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                //  fixedSize: const Size(100, 10),
                                maximumSize:
                                    Size(screenwidth / 3.7, screenhight / 10),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 15,
                              ),
                              label: const Text(
                                'รายระเอียด',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(80, 10),
                                // maximumSize: Size(screenwidth / 4.5,
                                //     screenhight / 15),
                                maximumSize:
                                    Size(screenwidth / 3.7, screenhight / 10),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.navigation_outlined,
                                size: 15,
                              ),
                              label: const Text(
                                'นำทาง',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
