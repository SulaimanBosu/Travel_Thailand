// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/popover.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class Listview extends StatefulWidget {
  final List<LandmarkModel> landmarkModel;
  final List<String> distances;
  final List<double> times;
  final int index;
  final double lat1, lng1;
  final String userId;

  const Listview({
    Key? key,
    required this.landmarkModel,
    required this.index,
    required this.distances,
    required this.times,
    required this.lat1,
    required this.lng1,
    required this.userId,
  }) : super(key: key);

  @override
  State<Listview> createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  late double screenwidth;
  late double screenhight;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              child: Slidable(
                key: Key(widget.landmarkModel[index].landmarkId!),
                // startActionPane: ActionPane(
                //   motion: const ScrollMotion(),
                //   dismissible: DismissiblePane(onDismissed: () {}),
                //   children: const [
                //     SlidableAction(
                //       onPressed: null,
                //       backgroundColor: Color(0xFFFE4A49),
                //       foregroundColor: Colors.white,
                //       icon: Icons.delete,
                //       label: 'Delete',
                //     ),
                //     SlidableAction(
                //       onPressed: null,
                //       backgroundColor: Color(0xFF21B7CA),
                //       foregroundColor: Colors.white,
                //       icon: Icons.share,
                //       label: 'Share',
                //     ),
                //   ],
                // ),
                endActionPane: ActionPane(
                  dragDismissible: true,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      autoClose: true,
                      flex: 3,
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandmarkDetail(
                              landmarkModel: widget.landmarkModel[index],
                              // lat: widget.lat1,
                              // lng: widget.lng1,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.open_with,
                      label: 'เปิด',
                    ),
                    SlidableAction(
                      autoClose: true,
                      flex: 3,
                      onPressed: (context) {
                        share(widget.landmarkModel[index]);
                      },
                      backgroundColor: const Color.fromARGB(255, 224, 2, 2),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'share',
                    ),
                  ],
                ),
                child: Container(
                  width: screenwidth,
                  height: 14.vh,
                  decoration: index % 2 == 0
                      ? const BoxDecoration(color: Colors.white)
                      : BoxDecoration(color: Colors.grey[50]),
                  child: Container(
                    padding:
                        const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('คุณคลิก index = $index');
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => LandmarkDetail(
                            landmarkModel: widget.landmarkModel[index],
                            // lat: widget.lat1,
                            // lng: widget.lng1,
                          ),
                        );
                        Navigator.push(context, route).then((value) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                          ]);
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.only(
                                start: 0.0, end: 0.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 14.vh,
                            child: Container(
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${widget.landmarkModel[index].imagePath}',
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
                            width: 57.vw,
                            height: 15.vh,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget
                                            .landmarkModel[index].landmarkName!,
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
                                        'จังหวัด ${widget.landmarkModel[index].provinceName}',
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
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                1
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                2
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                3
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                4
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! ==
                                                5
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
                                        // '234} Km. | (24hr.)',
                                        '${widget.distances[index]} Km. | (${widget.times[index].toStringAsFixed(2)}hr.)',
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 9.0.sp,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'View ${widget.landmarkModel[index].landmarkView}',
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 9.0.sp,
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
                                // const Expanded(
                                //   child: Divider(
                                //     color: Colors.black54,
                                //   ),
                                // ),
                                Expanded(
                                  //flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          //    fixedSize: const Size(100, 10),
                                          minimumSize: Size(27.vw, 8.vw),
                                          maximumSize: Size(screenwidth / 3.7,
                                              screenwidth / 10),
                                        ),
                                        onPressed: () {
                                          debugPrint(
                                              'คุณคลิก รายระเอียด = $index');
                                          MaterialPageRoute route =
                                              MaterialPageRoute(
                                            builder: (context) =>
                                                LandmarkDetail(
                                              landmarkModel:
                                                  widget.landmarkModel[index],
                                              // lat: widget.lat1,
                                              // lng: widget.lng1,
                                            ),
                                          );
                                          Navigator.push(context, route)
                                              .then((value) {
                                            SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.portraitUp,
                                            ]);
                                          });
                                        },
                                        child: Row(children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 15.sp,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'รายระเอียด',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.0.sp,
                                              fontFamily: 'FC-Minimal-Regular',
                                            ),
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          // fixedSize: const Size(80, 10),
                                          minimumSize: Size(27.vw, 8.vw),
                                          maximumSize: Size(screenwidth / 3.7,
                                              screenwidth / 10),
                                        ),
                                        onPressed: () {
                                          if (widget.userId.isEmpty) {
                                            MyAlertDialog().showAlertDialog(
                                              context,
                                              'กรุณาเข้าสู่ระบบก่อนที่จะให้ Appนำทางไปยังแหล่งท่องเที่ยว',
                                              'ตกลง',
                                              'ยกเลิก',
                                              () {
                                                Navigator.pop(context);
                                                MaterialPageRoute route =
                                                    MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login(),
                                                );
                                                Navigator.push(context, route)
                                                    .then((value) {});
                                              },
                                            );
                                          } else {
                                            navigaterLog(
                                                widget.landmarkModel[index]
                                                    .landmarkId!,
                                                widget.userId);
                                            debugPrint(
                                                'คุณคลิก นำทาง = $index');
                                            launchMapUrl(
                                                widget.landmarkModel[index]
                                                    .latitude!,
                                                widget.landmarkModel[index]
                                                    .longitude!);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.navigation_outlined,
                                          size: 15,
                                        ),
                                        label: Text(
                                          'นำทาง',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.0.sp,
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
                          // Expanded(
                          //   child: IconButton(
                          //     icon: const Icon(
                          //       Icons.favorite_border_rounded,
                          //       color: Colors.black45,
                          //       //size: 15,
                          //     ),
                          //     // ignore: unnecessary_statements
                          //     onPressed: () {},
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: widget.landmarkModel.length,
        ),
      ),
    );
  }

  Future<void> navigaterLog(String landmarkID, String userId) async {
    String url = '${MyConstant().domain}/application/navigate_post.php';

    FormData formData = FormData.fromMap(
      {
        "Landmark_id": landmarkID,
        "User_id": userId,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');
        String success = result['success'];
        if (success == '1') {
          debugPrint('บันทึกการนำทางเรียบร้อย');
        } else {
          debugPrint('ล้มเหลว');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> launchMapUrl(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);
    // var appleMapUrl1 = 'https://maps.apple.com/?q=$lat,$lng';
    var appleMapUrl = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/maps/search/',
      queryParameters: {
        'q': '$lat,$lng',
      },
    );
    var googlemapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '$lat,$lng',
      },
    );
    try {
      if (Platform.isAndroid) {
        final bool nativeAppLaunchSucceeded = await launchUrl(
          googlemapsUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (!nativeAppLaunchSucceeded) {
          await launchUrl(
            googlemapsUri,
            mode: LaunchMode.inAppWebView,
          );
        }
      } else {
        _bottomSheet(lat, lng);
      }
    } catch (error) {
      debugPrint('คุณคลิก นำทาง error = $error');
      throw ("Cannot launch Apple map");
    }
  }

  void _bottomSheet(double lat, double lng) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Popover(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: DefaultTextStyle(
                            child: Text('เลือกแผนที่'),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24.0,
                              //fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ),
                        //const Spacer(),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      var googlemapsUri = Uri(
                        scheme: 'https',
                        host: 'www.google.com',
                        path: '/maps/search/',
                        queryParameters: {
                          'api': '1',
                          'query': '$lat,$lng',
                        },
                      );
                      final bool nativeAppLaunchSucceeded = await launchUrl(
                        googlemapsUri,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                      if (!nativeAppLaunchSucceeded) {
                        await launchUrl(
                          googlemapsUri,
                          mode: LaunchMode.inAppWebView,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('Google Maps'),
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 24.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      var appleMapUrl = Uri(
                        scheme: 'https',
                        host: 'maps.apple.com',
                        path: '/maps/search/',
                        queryParameters: {
                          'q': '$lat,$lng',
                        },
                      );
                      final bool nativeAppLaunchSucceeded = await launchUrl(
                        appleMapUrl,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                      if (!nativeAppLaunchSucceeded) {
                        await launchUrl(
                          appleMapUrl,
                          mode: LaunchMode.inAppWebView,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('Apple Maps'),
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 24.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('ยกเลิก'),
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 24.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> share(LandmarkModel model) async {
    try {
      var googlemapsUri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/search/',
        queryParameters: {
          'api': '1',
          'query': '${model.latitude},${model.longitude}',
        },
      );
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse("${model.imagePath}"))
                  .load("${model.imagePath}"))
              .buffer
              .asUint8List();
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      File file = await File(
              "${directory!.path}/${DateTime.now().toIso8601String()}.jpg")
          .writeAsBytes(bytes, mode: FileMode.write);
      debugPrint('path ========>>> ${file.path.toString()}');
      debugPrint('google map ========>>> ${googlemapsUri.toString()}');
      await FlutterShare.shareFile(
        title: 'สถานที่ท่องเที่ยวของจังหวัด:${model.provinceName}',
        text:
            'มีสถานที่ท่องเที่ยวสวยๆมากมาย อย่างเช่น${model.landmarkName}\n\t\t\t${model.landmarkDetail}\n\nพิกัด : ตำบล${model.districtName}\t\tอำเภอ${model.amphurName}\t\tจังหวัด${model.provinceName}\nที่มา :Application Travel Thailand\nLocation : ${googlemapsUri.toString()}\n',
        chooserTitle: 'แชร์',
        filePath: file.path,
        fileType: 'image/jpg',
      );
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }
}
