import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/model/comment_model.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/full_image.dart';
import 'package:project/screen/google_map.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/comment_listview.dart';
import 'package:project/widgets/google_map_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandmarkDetail extends StatefulWidget {
  const LandmarkDetail({
    Key? key,
    required this.landmarkModel,
    // required this.lat,
    // required this.lng
  }) : super(key: key);
  final LandmarkModel landmarkModel;
  // final double lat, lng;

  @override
  State<LandmarkDetail> createState() => _LandmarkDetailState();
}

class _LandmarkDetailState extends State<LandmarkDetail> {
  LandmarkModel landmarkModel = LandmarkModel();
  CommentModel commentModel = CommentModel();
  List<CommentModel> commentModels = [];
  double screenwidth = 0;
  double screenhight = 0;
  int landmarkScore = 0;
  int index = 0;
  bool isLoading = true;
  bool isFavorites = false;
  bool isLocation = false;
  bool moreComment = false;
  late SharedPreferences preferences;
  double lat = 0, lng = 0;
  String? userid = '',
      name = '',
      lastname = '',
      profile = '',
      phone = '',
      gender = '',
      email = '';
  int score = 0;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    landmarkModel = widget.landmarkModel;
    landmarkScore = landmarkModel.landmarkScore!;
    debugPrint('latitude ============ ${landmarkModel.latitude.toString()}');
    getPreferences();
    // getLocation();
    readComment();
    delaydialog();

    debugPrint(landmarkModel.imageid.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        favorites(2);
        logLandmarkview();
      });
    });
  }

  Future<void> getLocation() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    lat = locationData.latitude!;
    lng = locationData.longitude!;
    if (lat != 0 && lng != 0) {
      setState(() {
        isLocation = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoogleMapScreen(
              landmarkModel: landmarkModel,
              lat: lat,
              lng: lng,
              userId: userid!,
            ),
          ),
        ).then((value) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        });
      });
    }
    debugPrint('latitude ============ ${lat.toString()}');
    debugPrint('longitude ============ ${lng.toString()}');
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

  Future<void> addScore() async {
    String urladdScore = '${MyConstant().domain}/application/post_score.php';
    FormData addscore = FormData.fromMap(
      {
        "score_id": landmarkModel.landmarkId,
        "User_id": landmarkModel.landmarkId,
        "Landmark_id": landmarkModel.landmarkId,
        "score": score.toString(),
      },
    );
    try {
      await Dio().post(urladdScore, data: addscore).then((value) {
        var result = json.decode(value.data);
        String success = result['success'];
        int currentcore = result['Landmark_score'];
        debugPrint('landmarkScore == $currentcore');
        debugPrint('data == $result');
        debugPrint('success == $success');
        if (success == '1') {
          setState(
            () {
              landmarkScore = currentcore;
              score = 0;
            },
          );
        } else if (success == 'error') {
          MyAlertDialog().showcupertinoDialog(context, 'คุณไม่ได้ให้คะแนน');
          setState(() {
            score = 0;
          });
        } else {
          setState(() {
            score = 0;
          });
          MyAlertDialog().showcupertinoDialog(context, 'ให้คะแนนไม่สำเร็จ');
        }
      });
    } catch (error) {
      setState(() {
        score = 0;
      });
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyAlertDialog().showtDialog(context, Icons.error_outline, 'ล้มเหลว',
          'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> logLandmarkview() async {
    String urllandmarkview =
        '${MyConstant().domain}/application/log_landmarkview.php';
    FormData landmarkview = FormData.fromMap(
      {
        "User_id": userid,
        "Landmark_id": landmarkModel.landmarkId,
      },
    );
    await Dio().post(urllandmarkview, data: landmarkview).then((value) {
      var result = json.decode(value.data);
      debugPrint('landmarkview == $result');
      String success = result['success'];
      if (success == '1') {
        debugPrint('บันทึกข้อมูลสำเร็จ');
      } else {
        debugPrint('บันทึกข้อมูลล้มเหลว');
      }
    });
  }

  Future<void> readComment() async {
    String urlcomment = '${MyConstant().domain}/application/get_comment.php';
    FormData getcomment = FormData.fromMap(
      {
        "Landmark_id": landmarkModel.landmarkId,
      },
    );
    try {
      await Dio().post(urlcomment, data: getcomment).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');

        for (var map in result) {
          commentModel = CommentModel.fromJson(map);
          setState(
            () {
              commentModels.add(commentModel);
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

  Future<void> favorites(int id) async {
    String urlFavorites =
        '${MyConstant().domain}/application/post_Favorites.php';
    FormData getFavorites = FormData.fromMap(
      {
        "id": id,
        "User_id": userid,
        "Landmark_id": landmarkModel.landmarkId,
      },
    );
    await Dio().post(urlFavorites, data: getFavorites).then((value) {
      var result = json.decode(value.data);
      debugPrint('Favorites == $result');
      String success = result['success'];
      if (success == '1') {
        setState(() {
          isFavorites = true;
        });
      } else {
        setState(() {
          isFavorites = false;
        });
      }
    });
  }

  Future _refreshData() async {
    setState(() {
      commentModels.clear();
      isLoading = true;
      index = 0;
      readComment();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    final maxLines = 5;
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        color: Colors.white,
        // width: screenwidth,
        //height: maxLines * 9.0,
        child: TextField(
          //  onChanged: (value) => phone = value.trim(),
          // controller: _phone,
          // focusNode: myFocusPhone,

          maxLines: null,
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              overflow: TextOverflow.ellipsis, fontSize: screenwidth * 0.037),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade300,
            prefixIcon: Icon(
              Icons.chat_outlined,
              color: Colors.black54,
              size: screenwidth * 0.05,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
            hintStyle: TextStyle(
              overflow: TextOverflow.fade,
              fontSize: screenwidth * 0.037,
              color: Colors.black54,
            ),
            hintText: 'เขียนความคิดเห็น...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLocation
          ? Stack(
              children: [
                bodywidget(context),
                const Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 15,
                  ),
                ),
              ],
            )
          : bodywidget(context),
    );
  }

  Widget bodywidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: _refreshData,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              width: screenwidth,
              height: screenhight * 0.48,
              child: screenwidget(context),
            ),
          ),
          information(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                GoogleMapWidget(
                  // lat: widget.lat,
                  // lng: widget.lng,
                  landmarkModel: landmarkModel,
                ),
                InkWell(
                  onTap: () {
                    if (lat == 0 && lng == 0) {
                      setState(() {
                        isLocation = true;
                        getLocation();
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleMapScreen(
                            landmarkModel: landmarkModel,
                            lat: lat,
                            lng: lng,
                            userId: userid!,
                          ),
                        ),
                      ).then((value) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, bottom: 10),
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      elevation: 5,
                      child: Container(
                        width: screenwidth,
                        padding: const EdgeInsets.all(15.0),
                        child: const Text(
                          'เปิดแผนที่',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Colors.grey.shade200,
                thickness: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 5),
                    child: Text(
                      commentModel.userFirstName == null
                          ? 'ความคิดเห็นทั้งหมด (0)'
                          : 'ความคิดเห็นทั้งหมด (${commentModels.length})',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(130, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (userid!.isEmpty) {
                          MyAlertDialog().showAlertDialog(
                            Icons.error_outline_outlined,
                            context,
                            'กรุณาเข้าสู่ระบบ',
                            'กรุณาเข้าสู่ระบบก่อนที่จะให้คะแนนแหล่งเที่ยว',
                            'ตกลง',
                            () {
                              Navigator.pop(context);
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => const Login(),
                              );
                              Navigator.push(context, route).then((value) {
                                setState(() {
                                  getPreferences();
                                });
                              });
                            },
                          );
                        } else {
                          _showAlertDialog(
                            Icons.star_border_outlined,
                            context,
                            'ให้คะแนน',
                          );
                        }
                      },
                      child: const Text(
                        'ให้คะแนน',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                // indent: 10,
                // endIndent: 10,
                color: Colors.black12,
                thickness: 1,
              ),
            ],
          )),
          isLoading
              ? const SliverToBoxAdapter(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 15,
                  ),
                )
              : commentModel.userFirstName == null
                  ? SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                          widthFactor: 3,
                          heightFactor: 3,
                          child: Text(
                            'ไม่มี Comment',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ),
                      ),
                    )
                  : CommentListview(
                      commentModels: commentModels,
                      index: index,
                      moreComment: moreComment,
                    ),
          commentModels.length > 3
              ? SliverToBoxAdapter(
                  child: moreComment
                      ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  moreComment = false;
                                });
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.arrow_drop_up,
                                  ),
                                  Container(
                                    width: screenwidth,
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      widthFactor: 1,
                                      heightFactor: 2,
                                      child: Text(
                                        'Comment น้อยลง',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider(
                            //   color: Colors.grey.shade200,
                            //   thickness: 1,
                            // ),
                          ],
                        )
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  moreComment = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenwidth,
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      widthFactor: 1,
                                      heightFactor: 2,
                                      child: Text(
                                        'Comment เพิ่มเติม...',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),

                            // Divider(
                            //   color: Colors.grey.shade200,
                            //   thickness: 1,
                            // ),
                          ],
                        ),
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.red,
              width: screenwidth,
              height: screenhight * 0.09,
            ),
          )
        ],
      ),
    );
  }

  Widget information() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Divider(
                color: Colors.grey.shade200,
                thickness: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 5,
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 10, top: 10),
                      child: Text(
                        'รายละเอียด',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24.0,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  Text(
                    '\t\t\t\t${landmarkModel.landmarkDetail!}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    //textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Divider(
                color: Colors.grey.shade200,
                thickness: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10, bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 15,
                  ),
                  Text(
                    ' ตำบล ${landmarkModel.districtName!}\t',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    ' อำเภอ ${landmarkModel.amphurName!}\t',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    ' จังหวัด ${landmarkModel.provinceName!}\t',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget screenwidget(BuildContext context) {
    return Stack(
      children: [
        showImage(context, landmarkModel.imagePath!),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share),
                  color: Colors.white,
                  onPressed: () {
                    share();
                    debugPrint('share');
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: screenhight * 0.31,
          child: Stack(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  content(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          margin: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: isFavorites
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_outline_outlined),
                            color: isFavorites ? Colors.red : Colors.black54,
                            iconSize: 30,
                            onPressed: () {
                              if (userid!.isEmpty) {
                                MyAlertDialog().showAlertDialog(
                                  Icons.error_outline_outlined,
                                  context,
                                  'กรุณาเข้าสู่ระบบ',
                                  'กรุณาเข้าสู่ระบบก่อนที่จะเพิ่มรายการโปรด',
                                  'ตกลง',
                                  () {
                                    Navigator.pop(context);
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    );
                                    Navigator.push(context, route)
                                        .then((value) {
                                      setState(() {
                                        getPreferences();
                                      });
                                    });
                                  },
                                );
                              } else {
                                if (isFavorites) {
                                  favorites(0);
                                } else {
                                  favorites(1);
                                }
                                setState(() {
                                  isFavorites = !isFavorites;
                                });
                              }
                              debugPrint('รายการโปรด');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: landmarkScore >= 1
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                color: landmarkScore >= 2
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                color: landmarkScore >= 3
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                color: landmarkScore >= 4
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                color: landmarkScore == 5
                                    ? Colors.orange
                                    : Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget content() {
    return Container(
      width: screenwidth,
      height: screenhight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10, bottom: 10, top: 20),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10, bottom: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landmarkModel.landmarkName!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'จังหวัด ${landmarkModel.provinceName!}',
                      style: const TextStyle(
                        color: Colors.black54,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context, String imageURL) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImage(
              landmarkId: landmarkModel.landmarkId!,
            ),
          ),
        ).then((value) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        });
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.35,
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
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(30.0),
          // ),
          elevation: 5,
          margin: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  Future<void> share() async {
    try {
      var googlemapsUri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/search/',
        queryParameters: {
          'api': '1',
          'query': '${landmarkModel.latitude},${landmarkModel.longitude}',
        },
      );
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse("${landmarkModel.imagePath}"))
                  .load("${landmarkModel.imagePath}"))
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
      await FlutterShare.shareFile(
        title: 'สถานที่ท่องเที่ยวของจังหวัด:${landmarkModel.provinceName}',
        text:
            'มีสถานที่ท่องเที่ยวสวยๆมากมาย อย่างเช่น${landmarkModel.landmarkName}\n\t\t\t${landmarkModel.landmarkDetail}\n\nพิกัด : ตำบล${landmarkModel.districtName}\t\tอำเภอ${landmarkModel.amphurName}\t\tจังหวัด${landmarkModel.provinceName}\nที่มา :Application Travel Thailand\nLocation : ${googlemapsUri.toString()}\n',
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

  _showAlertDialog(
    IconData icon,
    BuildContext context,
    String textTitle,
  ) async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        textTitle,
                        style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 20.0,
                          color: Colors.black45,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 5,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'คะแนน $score/5',
                    style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontSize: 20.0,
                      color: Colors.black45,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              score = 1;
                              debugPrint('Score ====== $score');
                            });
                          },
                          child: Icon(Icons.star,
                              size: 30,
                              color: score >= 1 ? Colors.orange : Colors.grey),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              score = 2;
                              debugPrint('Score ====== $score');
                            });
                          },
                          child: Icon(Icons.star,
                              size: 30,
                              color: score >= 2 ? Colors.orange : Colors.grey),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              score = 3;
                              debugPrint('Score ====== $score');
                            });
                          },
                          child: Icon(Icons.star,
                              size: 30,
                              color: score >= 3 ? Colors.orange : Colors.grey),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              score = 4;
                              debugPrint('Score ====== $score');
                            });
                          },
                          child: Icon(Icons.star,
                              size: 30,
                              color: score >= 4 ? Colors.orange : Colors.grey),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              score = 5;
                              debugPrint('Score ====== $score');
                            });
                          },
                          child: Icon(Icons.star,
                              size: 30,
                              color: score >= 5 ? Colors.orange : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  onPressed: () {
                    Navigator.pop(context);
                    addScore();
                  },
                  child: const Text(
                    'ให้คะแนน',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    score = 0;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
        });
  }
}
