import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/popular_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  List<PopularModel> popularlandmarks = [];
  late PopularModel landmark;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late String userid='', name = '', lastname='', profile = '';
  late SharedPreferences preferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    readlandmark();
    getPreferences();
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
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
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/getJSON_popular.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        print('Value == $result');
        for (var map in result) {
          landmark = PopularModel.fromJson(map);
          setState(() {
            popularlandmarks.add(landmark);
            isLoading = false;
          });
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        isLoading = false;
        delaydialog();
      });
    }
  }

  Future _refreshData() async {
    popularlandmarks.clear();
    setState(() {
      isLoading = true;
      readlandmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer:
          isLoading ? null : MyDrawer().showDrawer(context, profile, name),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.red,
          onRefresh: () async {
            _refreshData();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title: const Text(
                  'Travel Thailand',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.2),
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  CircleButton(
                    icon: Icons.search,
                    iconSize: 30,
                    onPressed: () => debugPrint('search'),
                  ),
                  CircleButton(
                    icon: MdiIcons.facebookMessenger,
                    iconSize: 30,
                    onPressed: () => debugPrint('facebookMessenger'),
                  ),
                  CircleButton(
                    icon: MdiIcons.accountDetails,
                    iconSize: 30,
                    onPressed: () {
                      if (userid=='') {
                        routeToWidget(context, const Login());
                      } else {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      debugPrint('Account');
                    },
                  )
                ],
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.78,
                        child: progress(context),
                      ),
                    )
                  : popularlandmarks.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.78,
                            child: const Center(
                              child: Text(
                                'ไม่พบรายการ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 24.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ),
                          ),
                        )
                      : buildlistview(),
              // SliverToBoxAdapter(
              //   child: popularlandmarks.isEmpty
              //     ? Container(
              //         width: MediaQuery.of(context).size.width,
              //         height: MediaQuery.of(context).size.height * 0.78,
              //         child: progress(context))
              //     :
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 0.78,
              //     // color: Colors.grey[400],
              //     child: showListLandmark(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  SliverList buildlistview() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            child: Slidable(
              key: Key(popularlandmarks[index].landmarkId!),
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
              endActionPane: const ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 1,
                    onPressed: null,
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    flex: 1,
                    onPressed: null,
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                  SlidableAction(
                    flex: 1,
                    onPressed: null,
                    backgroundColor: Color.fromARGB(255, 224, 2, 2),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'share',
                  ),
                ],
              ),
              child: Container(
                decoration: index % 2 == 0
                    ? BoxDecoration(color: Colors.grey[100])
                    : BoxDecoration(color: Colors.grey[200]),
                child: Container(
                  padding:
                      const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('คุณคลิก index = $index');
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsetsDirectional.only(
                              start: 0.0, end: 0.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.3,
                          child: Container(
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${popularlandmarks[index].imagePath}',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        MyStyle().showProgress(),
                                // CircularProgressIndicator(
                                //     ),
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
                                      popularlandmarks[index].landmarkName!,
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
                                      'จังหวัด ${popularlandmarks[index].provinceName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: MyStyle().mainH2Title,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'คะแนน ${popularlandmarks[index].landmarkScore.toString()}/5',
                                      //overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text(
                                      '102 Km. | (50min)',
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'View ${popularlandmarks[index].landmarkView}',
                                      //overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.0,
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
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          // fixedSize: const Size(0.1, 0),
                                          ),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.location_on, color: Colors.red,
                                        //size: 30,
                                      ),
                                      label: const Text(
                                        'รายระเอียด',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          // fixedSize: const Size(0.1, 0),
                                          ),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.navigation_outlined,
                                        // size: 5,
                                      ),
                                      label: const Text(
                                        'นำทาง',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14.0,
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
                        Expanded(
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.black45,
                              size: 30,
                            ),
                            // ignore: unnecessary_statements
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: popularlandmarks.length,
      ),
    );
  }

  Widget showListLandmark() => ListView.builder(
        padding: const EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
        itemCount: popularlandmarks.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            key: Key(popularlandmarks[index].landmarkId!),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: const [
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: const ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: Container(
              decoration: index % 2 == 0
                  ? const BoxDecoration(color: Colors.white60)
                  : BoxDecoration(color: Colors.grey[200]),
              child: Container(
                padding:
                    const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                child: GestureDetector(
                  onTap: () {
                    print('คุณคลิก index = $index');
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(
                            start: 0.0, end: 0.0),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                              imageUrl: '${popularlandmarks[index].imagePath}',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      MyStyle().showProgress(),
                              // CircularProgressIndicator(
                              //     ),
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
                                    popularlandmarks[index].landmarkName!,
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
                                    'จังหวัด ${popularlandmarks[index].provinceName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: MyStyle().mainH2Title,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'คะแนน ${popularlandmarks[index].landmarkScore.toString()}/5',
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Expanded(
                                  child: Text(
                                    '102 Km. | (50min) ${popularlandmarks[index].latitude}',
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.black45,
                            size: 30,
                          ),
                          // ignore: unnecessary_statements
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        showListLandmark(),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const CircularProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      'ดาวน์โหลด...',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  void routeToWidget(BuildContext context, Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => true);
  }
}
