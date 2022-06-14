import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/model/comment_model.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/comment_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandmarkDetail extends StatefulWidget {
  const LandmarkDetail({Key? key, required this.landmarkModel})
      : super(key: key);
  final LandmarkModel landmarkModel;

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late SharedPreferences preferences;
  String? userid = '',
      name = '',
      lastname = '',
      profile = '',
      phone = '',
      gender = '',
      email = '';

  @override
  void initState() {
    landmarkModel = widget.landmarkModel;
    landmarkScore = landmarkModel.landmarkScore!;
    getPreferences();
    readComment();
    delaydialog();

    debugPrint(landmarkModel.imageid.toString());
    // TODO: implement initState
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        getFavorites();
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

  Future<void> getFavorites() async {
    String urlFavorites =
        '${MyConstant().domain}/application/post_Favorites.php';
    FormData getFavorites = FormData.fromMap(
      {
        "id": 2,
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
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            _refreshData();
          },
          child: CustomScrollView(
            slivers: [
              Container(
                child: SliverToBoxAdapter(
                  child: Container(
                    width: screenwidth,
                    height: screenhight * 0.48,
                    child: screenwidget(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                        child: Divider(
                          color: Colors.black54,
                          thickness: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'รายละเอียด',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 24.0,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                              textAlign: TextAlign.left,
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
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10, top: 10),
                        child: Divider(
                          color: Colors.black54,
                          thickness: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 10, bottom: 10),
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
              ),
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
                        ),
            ],
          ),
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
                              setState(() {
                                isFavorites = !isFavorites;
                              });
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

  Container showImage(BuildContext context, String imageURL) {
    return Container(
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
    );
  }
}
