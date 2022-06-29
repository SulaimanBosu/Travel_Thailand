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
  const SearchWidget({Key? key}) : super(key: key);

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
    debugPrint('textControllor == ${textControllor.value.text}');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          //   margin: EdgeInsets.only(top: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                CupertinoTextField(
                  toolbarOptions: const ToolbarOptions(copy: true,cut: true,paste: true,selectAll: true),
                  onSubmitted:(value) => _landmarkList,
                  controller: textControllor,
                  onChanged: ((value) {
                    textControllor.text = value;
                    debugPrint('controller ===== ${textControllor.text}');
                  }),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  placeholder: 'ค้นหาแหล่งท่องเที่ยว',
                  placeholderStyle: const TextStyle(
                    color: Color(0xffC4C6CC),
                    fontSize: 14.0,
                    fontFamily: 'Brutal',
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xffC4C6CC),
                    ),
                  ),
                  suffix: InkWell(
                    onTap: () {},
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
                // const SizedBox(height: 20,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SearchableList<LandmarkModel>.sliver(
                      initialList: textControllor.text.isEmpty
                          ? landmarksPopular
                          : landmarks,
                      builder: (LandmarkModel landmarkModel) => LandmarkItem(
                        landmarkModel: landmarkModel,
                      ),
                      displayClearIcon: false,
                      searchFieldEnabled: true,
                      searchTextController: textControllor,
                      filter: _landmarkList,
                      emptyWidget: isLoadding
                          ? MyStyle().showProgress()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.error_outline),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('ไม่พบแหล่งท่องเที่ยว')
                              ],
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
                        suffixIcon: InkWell(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (value) => const HomeScreen(
                                      index: 0,
                                    ));
                            Navigator.pushAndRemoveUntil(
                                context, route, (route) => false);
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
                        hintText: "Search landmark",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
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
    );
  }

  List<LandmarkModel> _landmarkList(String searchTerm) {
    return landmarks
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
