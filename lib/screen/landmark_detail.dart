import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/comment_model.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/full_image.dart';
import 'package:project/screen/google_map.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/landmark_search.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/buildListview_landmark.dart';
import 'package:project/widgets/comment_listview.dart';
import 'package:readmore/readmore.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_side_menu/slider_side_menu.dart';

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
  List<LandmarkModel> landmarkProvince = [];
  List<LandmarkModel> landmarktype = [];
  CommentModel commentModel = CommentModel();
  List<CommentModel> commentModels = [];
  List<String> commentdate = [];
  double screenwidth = 0;
  double screenhight = 0;
  int landmarkScore = 0;
  int index = 0;
  bool isLoading = true;
  bool isProvinceLoading = true;
  bool isTypeLoading = true;
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
  String? textComment;
  final textfieldControler = TextEditingController();
  bool isSendicon = false;
  bool isIconFaceColor = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    landmarkScore = widget.landmarkModel.landmarkScore!;
    debugPrint(
        'latitude ============ ${widget.landmarkModel.latitude.toString()}');
    getPreferences();
    // getLocation();
    isLoad();
    delay();
    _refreshComment();
    recommentlandmark();
    debugPrint(widget.landmarkModel.imageid.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  isLoad() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (landmarkProvince.isEmpty) {
        setState(() {
          isProvinceLoading = false;
        });
      }
    });
  }

  Future<void> recommentlandmark() async {
    String url = '${MyConstant().domain}/application/get_type.php';

    FormData formDataProvince = FormData.fromMap(
      {
        "id": 'province',
        "Province_name": widget.landmarkModel.provinceName,
      },
    );

    try {
      await Dio().post(url, data: formDataProvince).then((value) {
        var result = json.decode(value.data);
        //debugPrint('data == $result');
        for (var map in result) {
          LandmarkModel landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              if (landmark.landmarkId != widget.landmarkModel.landmarkId) {
                landmarkProvince.add(landmark);
                isProvinceLoading = false;
              }
            },
          );
        }
      });

      FormData formDatatype = FormData.fromMap(
        {
          "id": 'Type',
          "Type": widget.landmarkModel.type,
        },
      );

      await Dio().post(url, data: formDatatype).then((value) {
        var result = json.decode(value.data);
        //debugPrint('data == $result');
        for (var map in result) {
          LandmarkModel landmark = LandmarkModel.fromJson(map);
          setState(
            () {
              if (landmark.landmarkId != widget.landmarkModel.landmarkId) {
                landmarktype.add(landmark);
                isTypeLoading = false;
              }
            },
          );
        }
      });
    } catch (error) {
      debugPrint("??????????????????????????????????????????????????????: $error");
      MyStyle().showdialog(
          context, '?????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
      setState(
        () {
          isProvinceLoading = false;
        },
      );
    }
  }

  _refreshComment() {
    Timer timer = Timer.periodic(
      const Duration(seconds: 60),
      (Timer t) => setState(
        () {
          if (commentModel.userFirstName != null) {
            readComment();
          }
        },
      ),
    );
  }

  void delay() {
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        favorites(2);
        logLandmarkview();
        readComment();
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
              landmarkModel: widget.landmarkModel,
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
        "score_id": widget.landmarkModel.landmarkId,
        "User_id": widget.landmarkModel.landmarkId,
        "Landmark_id": widget.landmarkModel.landmarkId,
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
          MyAlertDialog().showcupertinoDialog(context, '???????????????????????????????????????????????????');
          setState(() {
            score = 0;
          });
        } else {
          setState(() {
            score = 0;
          });
          MyAlertDialog().showcupertinoDialog(context, '???????????????????????????????????????????????????');
        }
      });
    } catch (error) {
      setState(() {
        score = 0;
      });
      debugPrint("??????????????????????????????????????????????????????: $error");
      MyAlertDialog()
          .showtDialog(context, '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
    }
  }

  Future<void> logLandmarkview() async {
    String urllandmarkview =
        '${MyConstant().domain}/application/log_landmarkview.php';
    FormData landmarkview = FormData.fromMap(
      {
        "User_id": userid,
        "Landmark_id": widget.landmarkModel.landmarkId,
      },
    );
    await Dio().post(urllandmarkview, data: landmarkview).then((value) {
      var result = json.decode(value.data);
      debugPrint('landmarkview == $result');
      String success = result['success'];
      if (success == '1') {
        debugPrint('??????????????????????????????????????????????????????');
      } else {
        debugPrint('?????????????????????????????????????????????????????????');
      }
    });
  }

  Future<void> likeAnddeleteComment(int id, int commentid) async {
    String urllikeComment =
        '${MyConstant().domain}/application/like_comment.php';
    FormData likeComment = FormData.fromMap(
      {
        "id": id,
        "Comment_id": commentid,
        "User_id": userid,
        "Landmark_id": widget.landmarkModel.landmarkId,
      },
    );
    await Dio().post(urllikeComment, data: likeComment).then((value) {
      var result = json.decode(value.data);
      debugPrint('like Comment == $result');
      String success = result['success'];
      if (success == '1') {
        debugPrint('????????????????????????????????????');
      } else if (success == '0') {
        debugPrint('??????????????????????????????????????????????????????');
      } else if (success == '2') {
        debugPrint('?????? Comment ??????????????????');
      } else {
        debugPrint('?????????????????????');
      }
    });
  }

  Future<void> readComment() async {
    String urlcomment = '${MyConstant().domain}/application/get_comment.php';
    FormData getcomment = FormData.fromMap(
      {
        "Landmark_id": widget.landmarkModel.landmarkId,
        "User_id": userid,
      },
    );
    try {
      await Dio().post(urlcomment, data: getcomment).then((value) {
        var result = json.decode(value.data);
        // debugPrint('Comment Data == $result');
        commentModels.clear();
        commentdate.clear();
        for (var map in result) {
          commentModel = CommentModel.fromJson(map);
          setState(
            () {
              commentModels.add(commentModel);
              index++;
              isLoading = false;
              if (commentModel.userFirstName != null) {
                String date = MyApi().difference(commentModel.commentDate!);
                commentdate.add(date);
                // debugPrint(
                //     'UserComment ========= ${commentModel.userFirstName}');
                // debugPrint('CommentDate ========= $date');
              }
            },
          );
        }
      });
    } catch (error) {
      debugPrint("??????????????????????????????????????????????????????: $error");
      // MyStyle().showdialog(
      //     context, '?????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
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
        "Landmark_id": widget.landmarkModel.landmarkId,
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

  Future<void> addComment() async {
    String urlFavorites = '${MyConstant().domain}/application/comment_post.php';
    try {
      FormData getFavorites = FormData.fromMap(
        {
          "Comment_detail": textComment,
          "User_id": userid,
          "Landmark_id": widget.landmarkModel.landmarkId,
        },
      );
      await Dio().post(urlFavorites, data: getFavorites).then((value) {
        var result = json.decode(value.data);
        debugPrint('addComment == $result');
        String success = result['success'];
        if (success == '1') {
          setState(() {
            readComment();
          });
        } else {
          setState(() {
            MyStyle().showdialog(context, '?????????????????????', '????????????????????????????????????????????????????????????');
          });
        }
      });
    } catch (error) {
      debugPrint("??????????????????????????????????????????????????????: $error");
      MyStyle().showdialog(
          context, '?????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
    }
  }

  Future _refreshData() async {
    setState(() {
      commentModels.clear();
      landmarkProvince.clear();
      landmarktype.clear();
      isLoading = true;
      index = 0;
      readComment();
      recommentlandmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return BlurryModalProgressHUD(
      inAsyncCall: isLocation,
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
        bottomSheet: buildBottomSheet(),
        backgroundColor: Colors.white,
        body: bodywidget(context),
      ),
    );
  }

  BottomSheet buildBottomSheet() {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.white,
              width: screenwidth,
              // height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (value) => const HomeScreen(
                                  index: 4,
                                ));
                        Navigator.push(context, route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          foregroundColor: Colors.black45,
                          backgroundColor: Colors.black45,
                          radius: 21,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(20), // Image radius
                              child: CachedNetworkImage(
                                imageUrl: MyConstant().domain + profile!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        MyStyle().showProgress(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('images/iconprofile.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  Icon(
                    //   Icons.camera_alt_outlined,
                    //   size: screenwidth * 0.08,
                    //   color: Colors.black54,
                    // ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 25, right: 15),
                      color: Colors.white,
                      child: TextField(
                        // buildCounter: (
                        //   context, {
                        //   currentLength = 0,
                        //   isFocused = false,
                        //   maxLength = 150,
                        // }) =>
                        //     Text(
                        //   '$currentLength of $maxLength',
                        //   semanticsLabel: 'character count',
                        // ),
                        controller: textfieldControler,
                        autofocus: false,
                        onChanged: (value) {
                          textComment = value.trim();
                          if (value.isNotEmpty) {
                            setState(() {
                              isSendicon = true;
                            });
                          } else {
                            setState(() {
                              isSendicon = false;
                            });
                          }
                        },
                        maxLines: 5,
                        minLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: screenwidth * 0.037),
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () => setState(() {
                              isIconFaceColor = !isIconFaceColor;
                            }),
                            child: Icon(
                              Icons.tag_faces_outlined,
                              color: isIconFaceColor
                                  ? Colors.blue
                                  : Colors.black45,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          prefixIcon: Icon(
                            Icons.sms_outlined,
                            color: Colors.black54,
                            size: screenwidth * 0.05,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5.0),
                          hintStyle: TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: screenwidth * 0.03,
                            color: Colors.black54,
                          ),
                          hintText: '????????????????????????????????????????????????...',
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
                  ),
                  isSendicon
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (userid!.isEmpty) {
                                MyAlertDialog().showAlertDialog(
                                  context,
                                  '??????????????????????????????????????????????????????????????????????????????????????????????????????????????? ???????????????????????????????????????????????????????????????',
                                  '????????????',
                                  '??????????????????',
                                  () {
                                    Navigator.pop(context);
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    );
                                    Navigator.push(context, route)
                                        .then((value) {});
                                  },
                                );
                              } else {
                                if (textComment!.isNotEmpty ||
                                    textComment != '') {
                                  addComment();
                                  textfieldControler.clear();
                                  isSendicon = false;
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 5, right: 5),
                              child: Icon(
                                Icons.send_rounded,
                                size: screenwidth * 0.09,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          });
        });
  }

  Widget bodywidget(BuildContext context) {
    double lat = double.parse(widget.landmarkModel.latitude!);
    double lng = double.parse(widget.landmarkModel.longitude!);

    return Container(
      color: Colors.white,
      child: RawScrollbar(
        controller: scrollController,
        thumbColor: Colors.grey.shade300,
        isAlwaysShown: false,
        scrollbarOrientation: ScrollbarOrientation.right,
        thickness: 5,
        radius: const Radius.circular(5),
        //mainAxisMargin :25 .vh,
        //crossAxisMargin: 70,
        child: CustomScrollView(
          controller: scrollController,
          // keyboardDismissBehavior :ScrollViewKeyboardDismissBehavior.onDrag,
          scrollBehavior: const ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
          dragStartBehavior: DragStartBehavior.start,
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
            isProvinceLoading
                ? SliverToBoxAdapter(
                    child: Container(),
                  )

                // ? SliverToBoxAdapter(
                //     child: Container(
                //       width: screenwidth,
                //       height: 8.vh,
                //       child: const Center(
                //         child: CupertinoActivityIndicator(
                //           animating: true,
                //           radius: 15,
                //         ),
                //       ),
                //     ),
                //   )
                : landmarkProvince.isEmpty
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : BuildListviewLandmark(
                        screenwidth: screenwidth,
                        listLandmark: landmarkProvince,
                        index: index,
                      ),
            landmarktype.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      width: screenwidth,
                      height: 8.vh,
                      child: landmarktype.isNotEmpty
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 1.vh, top: 1.vh),
                                  child: Divider(
                                    color: Colors.grey.shade200,
                                    thickness: 10.0,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20.w, bottom: 0.5.vh),
                                  width: 100.vw,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '???????????????????????????????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.sp),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (context) =>
                                                LandmarkSearch(
                                              search:
                                                  widget.landmarkModel.type!,
                                              type: 'type',
                                            ),
                                          );
                                          Navigator.pushAndRemoveUntil(
                                              context, route, (route) => true);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '???????????????????????????',
                                              style: TextStyle(
                                                  // decoration: TextDecoration.underline,
                                                  // decorationColor:Colors.black54,
                                                  fontFamily:
                                                      'FC-Minimal-Regular',
                                                  color: Colors.red,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.red,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(bottom: 1.vh, top: 1.vh),
                                //   child: Divider(
                                //     color: Colors.grey.shade200,
                                //     thickness: 1.0,
                                //   ),
                                // ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
            isTypeLoading
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : BuildListviewLandmark(
                    screenwidth: screenwidth,
                    listLandmark: landmarktype,
                    index: index,
                  ),
            commentBar(context),
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
                              '??????????????? Comment',
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
                        commentdate: commentdate,
                        onLike: (value) {
                          debugPrint('Value ======= ${value.toString()}');
                          likeAnddeleteComment(value[0], value[1]);
                        },
                        userid: userid!,
                      ),
            commentModels.length > 3
                ? commentMore()
                : SliverToBoxAdapter(
                    child: Container(),
                  ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: screenhight * 0.11),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter commentMore() {
    return SliverToBoxAdapter(
      child: moreComment
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      moreComment = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.16),
                    width: screenwidth,
                    color: Colors.white,
                    // child: const Center(
                    //   widthFactor: 1,
                    //   heightFactor: 2,
                    child: Text(
                      '?????????????????????????????????????????????????????????',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black45,
                        fontSize: 13.0.sp,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
                // Divider(
                //   color: Colors.grey.shade200,
                //   thickness: 1,
                // ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      moreComment = true;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.16),
                    width: screenwidth,
                    color: Colors.white,
                    // child: const Center(
                    //   widthFactor: 1,
                    //   heightFactor: 2,
                    child: Text(
                      '??????????????????????????????????????????????????????????????????...',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.0.sp,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                  // const Icon(Icons.arrow_drop_down),
                ),

                // Divider(
                //   color: Colors.grey.shade200,
                //   thickness: 1,
                // ),
              ],
            ),
    );
  }

  SliverToBoxAdapter commentBar(BuildContext context) {
    return SliverToBoxAdapter(
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
                  top: 10, left: 20, right: 10, bottom: 5),
              child: Text(
                commentModel.userFirstName == null
                    ? '?????????????????????????????????????????????????????? (0)'
                    : '?????????????????????????????????????????????????????? (${commentModels.length})',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.0.sp,
                  //fontFamily: 'FC-Minimal-Regular',
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
                      context,
                      '????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                      '????????????',
                      '??????????????????',
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
                      '????????????????????????',
                    );
                  }
                },
                child: Text(
                  '????????????????????????',
                  style: TextStyle(
                    fontSize: 14.0.sp,
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
    ));
  }

  SliverToBoxAdapter openGoogleButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // GoogleMapWidget(
          //   // lat: widget.lat,
          //   // lng: widget.lng,
          //   landmarkModel: landmarkModel,
          // ),
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
                      landmarkModel: widget.landmarkModel,
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
              padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
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
                    '??????????????????????????????',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
            Stack(
              children: [
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, bottom: 10, top: 10),
                          child: Text(
                            '??????????????????????????????',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 22.0.sp,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      MyStyle().mySizebox(),
                      ReadMoreText(
                        '\t\t\t\t${widget.landmarkModel.landmarkDetail!}',
                        trimLines: 10,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '???????????????????????????????????????',
                        trimExpandedText: '  ??????????????????..',
                        colorClickableText: Colors.red,
                        moreStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0.sp,
                          // fontFamily: 'FC-Minimal-Regular',
                        ),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0.sp,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                        //textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                // SliderSideMenu(
                //   direction :Direction.RTL,
                //   childrenData: [
                //     MenuItem(
                //         const Icon(
                //           Icons.thumb_up,
                //           color: Colors.white,
                //         ),
                //         const Text(
                //           "???????????????",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //         onPressed: () {}),
                //     MenuItem(
                //         const Icon(
                //           Icons.thumb_down,
                //           color: Colors.white,
                //         ),
                //         const Text(
                //           "????????????????????????",
                //           style: TextStyle(color: Colors.white),
                //           textAlign: TextAlign.center,
                //         ),
                //         onPressed: () {})
                //   ],
                //   description: "Sample tooltip message",
                //   parentStartColor: Colors.red,
                // )
              ],
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
                        landmarkModel: widget.landmarkModel,
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
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: const BorderSide(
                    //   color: Colors.black54,
                    // ),
                  ),
                  elevation: 5,
                  child: Container(
                    width: screenwidth,
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '??????????????????????????????',
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // landmarkProvince.isEmpty
            //     ? Container()
            //     : Padding(
            //         padding: const EdgeInsets.only(bottom: 10, top: 10),
            //         child: Divider(
            //           color: Colors.grey.shade200,
            //           thickness: 10.0,
            //         ),
            //       ),
            // Padding(
            //   padding: EdgeInsets.only(left: 20.0, right: 10, bottom: 5.h),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.location_on,
            //         color: Colors.redAccent,
            //         size: 15,
            //       ),
            //       Text(
            //         ' ???????????? ${landmarkModel.districtName!}\t',
            //         style:  TextStyle(
            //           color: Colors.black54,
            //           fontSize: 14.0 .sp,
            //           fontFamily: 'FC-Minimal-Regular',
            //         ),
            //         textAlign: TextAlign.left,
            //       ),
            //       Text(
            //         ' ??????????????? ${landmarkModel.amphurName!}\t',
            //         style:  TextStyle(
            //           color: Colors.black54,
            //           fontSize: 14.0 .sp,
            //           fontFamily: 'FC-Minimal-Regular',
            //         ),
            //         textAlign: TextAlign.left,
            //       ),
            //       Text(
            //         ' ????????????????????? ${landmarkModel.provinceName!}\t',
            //         style:  TextStyle(
            //           color: Colors.black54,
            //           fontSize: 14.0 .sp,
            //           fontFamily: 'FC-Minimal-Regular',
            //         ),
            //         textAlign: TextAlign.left,
            //       ),
            //     ],
            //   ),
            // ),
            landmarkProvince.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 20.w, bottom: 2.vh, top: 2.vh),
                        width: 100.vw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '??????????????????????????????????????????????????????????????????????????????????????????',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.sp),
                            ),
                            InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (context) => LandmarkSearch(
                                    search: widget.landmarkModel.provinceName!,
                                    type: 'province',
                                  ),
                                );
                                Navigator.pushAndRemoveUntil(
                                    context, route, (route) => true);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '???????????????????????????',
                                    style: TextStyle(
                                        // decoration: TextDecoration.underline,
                                        // decorationColor:Colors.black54,
                                        fontFamily: 'FC-Minimal-Regular',
                                        color: Colors.red,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 7.h, top: 7.h),
                      //   child: Divider(
                      //     color: Colors.grey.shade200,
                      //     thickness: 1.0,
                      //   ),
                      // ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget screenwidget(BuildContext context) {
    return Stack(
      children: [
        showImage(context, widget.landmarkModel.imagePath!),
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
                                  context,
                                  '????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                                  '????????????',
                                  '??????????????????',
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
                              debugPrint('??????????????????????????????');
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
                      widget.landmarkModel.landmarkName!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '????????????????????? ${widget.landmarkModel.provinceName!}',
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
              landmarkId: widget.landmarkModel.landmarkId!,
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
          'query':
              '${widget.landmarkModel.latitude},${widget.landmarkModel.longitude}',
        },
      );
      Uint8List bytes = (await NetworkAssetBundle(
                  Uri.parse("${widget.landmarkModel.imagePath}"))
              .load("${widget.landmarkModel.imagePath}"))
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
        title:
            '?????????????????????????????????????????????????????????????????????????????????:${widget.landmarkModel.provinceName}',
        text:
            '??????????????????????????????????????????????????????????????????????????????????????? ???????????????????????????${widget.landmarkModel.landmarkName}\n\t\t\t${widget.landmarkModel.landmarkDetail}\n\n??????????????? : ????????????${widget.landmarkModel.districtName}\t\t???????????????${widget.landmarkModel.amphurName}\t\t?????????????????????${widget.landmarkModel.provinceName}\n??????????????? :Application Travel Thailand\nLocation : ${googlemapsUri.toString()}\n',
        chooserTitle: '????????????',
        filePath: file.path,
        fileType: 'image/jpg',
      );
    } catch (error) {
      debugPrint("??????????????????????????????????????????????????????: $error");
      MyStyle().showdialog(
          context, '?????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
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
                    '??????????????? $score/5',
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
                    '????????????????????????',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    score = 0;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '??????????????????',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
        });
  }
}
