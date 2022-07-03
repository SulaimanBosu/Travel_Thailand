import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';

typedef StringVoidFunc = void Function(String);

class SliverappBar {
  Widget appbar(
      BuildContext context,
      double screenwidth,
      String? userid,
      var scaffoldKey,
      bool isLoading,
      VoidCallback onPressed,
      bool search,
     // VoidCallback onTap,
      // StringVoidFunc onValueChanged,
     ) {
    TextEditingController textControllor = TextEditingController();
    return SliverAppBar(
      backgroundColor: Colors.white,
      // flexibleSpace: !search
      //     ? null
      //     : FlexibleSpaceBar(
      //         background: Column(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
      //               child: Container(
      //                 height: 36.0,
      //                 width: double.infinity,
      //                 child: CupertinoTextField(
      //                   // onSubmitted: (value) => onSubmit,
      //                   toolbarOptions: const ToolbarOptions(
      //                       copy: true,
      //                       cut: true,
      //                       paste: true,
      //                       selectAll: true),
      //                   onEditingComplete: onSubmit,
      //                   onChanged: onValueChanged,
      //                   //controller: textControllor,
      //                   autofocus: true,
      //                   keyboardType: TextInputType.text,
      //                   placeholder: 'ค้นหาแหล่งท่องเที่ยว',
      //                   placeholderStyle: const TextStyle(
      //                     color: Color(0xffC4C6CC),
      //                     fontSize: 14.0,
      //                     fontFamily: 'Brutal',
      //                   ),
      //                   prefix: const Padding(
      //                     padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
      //                     child: Icon(
      //                       Icons.search,
      //                       color: Color(0xffC4C6CC),
      //                     ),
      //                   ),
      //                   suffix: InkWell(
      //                     onTap: () {
      //                       onTap();
      //                     },
      //                     child: const Padding(
      //                       padding: EdgeInsets.only(right: 9),
      //                       child: Icon(
      //                         Icons.close,
      //                         color: Colors.black54,
      //                       ),
      //                     ),
      //                   ),
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     color: const Color(0xffF0F1F5),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //                 child: Container(
      //               color: Colors.white,
      //               width: MediaQuery.of(context).size.width,
      //               height: double.infinity,
      //             ))
      //           ],
      //         ),
      //       ),
      brightness: Brightness.light,
      title: search
          ? null
          // ? Text(
          //     'Travel Thailand',
          //     style: TextStyle(
          //         color: Colors.redAccent,
          //         fontSize: screenwidth * 0.05,
          //         fontWeight: FontWeight.bold,
          //         letterSpacing: -1.2),
          //   )
          : Text(
              'Travel Thailand',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: screenwidth * 0.05,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2),
            ),
      centerTitle: false,
      floating: true,
      actions: [
        search
            ? Container()
            : CircleButton(
                icon: Icons.search,
                iconSize: 30,
                onPressed: () {
                  if (!isLoading) {
                    if (userid == '') {
                      MyStyle().routeToWidget(context, const Login(), true);
                    } else {
                      onPressed();
                    }
                  } else {
                    debugPrint('search');
                  }
                }),
        search
            ? Container()
            : CircleButton(
                icon: MdiIcons.facebookMessenger,
                iconSize: 30,
                onPressed: () {
                  if (!isLoading) {
                    if (userid == '') {
                      MyStyle().routeToWidget(context, const Login(), true);
                    } else {
                      debugPrint('facebookMessenger');
                    }
                  } else {
                    debugPrint('facebookMessenger');
                  }
                }),
        search
            ? Container()
            : CircleButton(
                icon: MdiIcons.accountDetails,
                iconSize: 30,
                onPressed: () {
                  if (!isLoading) {
                    if (userid == '') {
                      MyStyle().routeToWidget(context, const Login(), true);
                    } else {
                      scaffoldKey.currentState!.openEndDrawer();
                    }
                  } else {
                    debugPrint('Account');
                  }
                },
              )
      ],
    );
  }

  SliverappBar();
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
  List<LandmarkModel> landmarkModels = [];
  List<LandmarkModel> list_landmarkModels = [];
  LandmarkModel landmarkModel = LandmarkModel();

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      landmarkModels.forEach((item) {
        if (landmarkModels.contains(query)) {
          list_landmarkModels.add(item);
        }
      });
      setState(() {
        list_landmarkModels.clear();
      });
      return;
    } else {
      setState(() {
        list_landmarkModels.clear();
      });
    }
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
          // isLoadding = false;
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

          //  AnimatedSearchBar(
          //     shadow: [
          //       BoxShadow(
          //         color: Colors.grey.shade200,
          //         blurRadius: 1,
          //        // offset: Offset(4, 8), // Shadow position
          //       ),
          //     ],
              
          //     backgroundColor: Colors.transparent,
          //     buttonColor: Colors.black45,
          //     width: MediaQuery.of(context).size.width,
          //     submitButtonColor: Colors.red,
          //     textStyle: const TextStyle(color: Colors.black54),
          //     buttonIcon: const Icon(
          //       Icons.search,
          //     ),
          //     hintText: 'ค้นหาแหล่งท่องเที่ยว',
          //     duration: const Duration(milliseconds: 700),
          //     submitIcon: const Icon(Icons.arrow_back_rounded),
          //     animationAlignment: AnimationAlignment.right,
          //     onSubmit: () {
          //       // setState(() {
          //       //   value = controller.text;
          //       // });
          //     },
          //     searchList: list,
          //     searchQueryBuilder: (query, list) => list.where((item) {
          //       return item!
          //           .toString()
          //           .toLowerCase()
          //           .contains(query.toLowerCase());
          //     }).toList(),
          //     textController: controller,
          //     overlaySearchListItemBuilder: (dynamic item) => Container(
          //       padding: const EdgeInsets.all(8),
          //       child: Text(
          //         item,
          //         style: const TextStyle(fontSize: 15, color: Colors.black),
          //       ),
          //     ),
          //     onItemSelected: (dynamic item) {
          //       controller.value = controller.value.copyWith(
          //         text: item.toString(),
          //       );
          //     },
          //     overlaySearchListHeight: 100,
          //   ),
