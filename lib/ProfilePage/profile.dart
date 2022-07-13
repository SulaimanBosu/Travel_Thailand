import 'dart:async';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/ProfilePage/edit_profile.dart';
import 'package:project/model/province_model.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/utility/signout_process.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/popover.dart';
import 'package:project/widgets/popup_menu.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.provinceModel,
  }) : super(key: key);
  final List<ProvinceModel> provinceModel;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserModel user;
  late String userId = '',
      name = '',
      lastname = '',
      file = '',
      phone = '',
      gender = '',
      email = '',
      password = '',
      imageCoverPage = '';
  late SharedPreferences preferences;
  bool onData = false;
  bool isLoading = true;
  final _controller = TextEditingController();
  late double screenwidth;
  late double screenhight;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // ignore: must_call_super
  void initState() {
    getPreferences();
    delaydialog();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    file = preferences.getString('Image_profile')!;
    imageCoverPage = preferences.getString('Image_CoverPage')!;
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
    password = preferences.getString('Password')!;
    debugPrint('User id ====> $userId');
    debugPrint('Profile ====> ${MyConstant().domain + file}');
    if (userId.isNotEmpty || userId != '') {
      setState(() {
        onData = true;
      });
    } else {
      setState(() {
        onData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 4,
      progressIndicator: Material(
        type: MaterialType.transparency,
        child: JumpingDotsProgressIndicator(
          color: Colors.red,
          fontSize: 80.0.sp,
        ),
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black38,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        endDrawer: isLoading
            ? null
            : MyDrawer().showDrawer(
                context,
                file,
                name,
                lastname,
                email,
              ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                actions: [
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        MyAlertDialog().showtDialog(context,
                            'ปุ่มยังไม่พร้อมใช้งาน เนื่องจากคนเขียนแอพขี้เกียจทำ รอไปก่อนน่ะ');
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenu(
                      onselect: (value) {
                        setState(() {
                          switch (value) {
                            case 1:
                              MyStyle().routeToWidget(
                                  context, const HomeScreen(index: 0), true);
                              break;
                            case 2:
                              MyStyle().routeToWidget(
                                  context, const HomeScreen(index: 4), true);
                              break;
                            case 3:
                              MyAlertDialog().showtDialog(context,
                                  'ปุ่มยังไม่พร้อมใช้งาน เนื่องจากคนเขียนแอพขี้เกียจทำ รอไปก่อนน่ะ');
                              // MyStyle().routeToWidget(
                              //     context, const HomeScreen(index: 2), true);
                              break;
                            case 4:
                              MyStyle()
                                  .routeToWidget(context, const Login(), true);
                              break;
                            default:
                              MyStyle().routeToWidget(
                                  context, const HomeScreen(index: 0), true);
                          }

                          debugPrint('ItemMenu ==== ${value.toString()}');
                        });
                      },
                      item: [
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.home_outlined,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('หน้าแรก'),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                MdiIcons.accountDetails,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('โปรไฟล์'),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.settings,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('การตั้งค่า'),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 4,
                          child: Column(
                            children: [
                              const Divider(thickness: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    name == '' || name.isEmpty
                                        ? Icons.login_outlined
                                        : Icons.logout_rounded,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    name == '' || name.isEmpty
                                        ? 'เข้าสู่ระบบ'
                                        : 'ออกจากระบบ',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.84,
                          // child: MyStyle().progress(context),
                          ),
                    )
                  : onData == false
                      ? SliverToBoxAdapter(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: const Login(),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    //  const SizedBox(height: 10,),
                                    InkWell(
                                      onTap: () {
                                        _bottomSheet();
                                        // navigateSecondPage(const EditProfile());
                                        // _bottomSheet();
                                        // showBottomsheet();
                                        // navigateSecondPage(const EditImagePage());
                                      },
                                      child: Stack(
                                        children: [
                                          showImageCoverPage(
                                            context,
                                          ),
                                          userprofile(),
                                        ],
                                      ),
                                    ),
                                    buildUserInfoDisplay(
                                      name + ' ' + lastname,
                                      'ชื่อ - สกุล',
                                      const EditProfile(),
                                    ),
                                    buildUserInfoDisplay(
                                      phone,
                                      'เบอร์โทร',
                                      const EditProfile(),
                                    ),
                                    buildUserInfoDisplay(
                                      gender,
                                      'เพศ',
                                      const EditProfile(),
                                    ),
                                    buildUserInfoDisplay(
                                      email,
                                      'อีเมลล์',
                                      const EditProfile(),
                                    ),
                                    // slideToLogout(),
                                    signOutMenu(context),
                                  ],
                                ),

                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     signOutMenu(context),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        )
            ],
          ),
          //       ),
        ),
      ),
    );
  }

  Widget userprofile() {
    return Positioned(
      top: screenhight * 0.12,
      left: 40,
      right: 40,
      child: CircleAvatar(
        radius: 93,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(2), // Border radius
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(88), // Image radius
              child: file.isEmpty
                  ? Image.asset('images/iconprofile.png')
                  : CachedNetworkImage(
                      imageUrl: MyConstant().domain + file,
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
    );
  }

  Widget showImageCoverPage(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        MyStyle().bottomSheet(context, 'ดูรูปหน้าปก', 'แก้ไข', imageCoverPage,
            () {
          navigateSecondPage(const EditProfile());
        }, 'หน้าปก');
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(
            start: 10.0, end: 10.0, bottom: 90),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CachedNetworkImage(
            imageUrl: MyConstant().domain + imageCoverPage,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                MyStyle().showProgress(),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade300,
              child: Container(
                  margin: EdgeInsets.all(15.vw),
                  child: Text(
                    'ไม่มีรูปหน้าปก',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                  )),
            ),
            fit: BoxFit.cover,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          elevation: 1,
          margin: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              width: 95.vw,
              height: screenhight * 0.055,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // showBottomsheet(getValue, title);
                      navigateSecondPage(editPage);
                    },
                    child: Text(
                      getValue,
                      style: TextStyle(fontSize: 14.sp, height: 1.4),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      navigateSecondPage(editPage);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget slideToLogout() {
    return Column(
      children: [
        SizedBox(
          height: 15.vh,
        ),
        HorizontalSlidableButton(
          border: Border.all(width: 1, color: Colors.black45),
          tristate: true,
          initialPosition: SlidableButtonPosition.start,
          isRestart: true,
          // disabledColor: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          width: 95.vw,
          height: 7.vh,
          buttonWidth: 60.0,
          color: Colors.grey.shade200,
          buttonColor: const Color(0xffd60000),
          dismissible: true,
          label: const Center(
              child: Icon(
            Icons.power_settings_new,
            color: Colors.white,
            size: 40.0,
            semanticLabel: 'Text to announce in accessibility modes',
          )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Slide to Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
          ),
          onChanged: (position) {
            if (position == SlidableButtonPosition.end) {
              signOutProcess(context);
            }
          },
        ),
        SizedBox(
          height: 3.vh,
        ),
      ],
    );
  }

  Widget signOutMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size(double.maxFinite, 60),
        ),
        onPressed: () {
          signOutProcess(context);
        },
        icon: const Icon(
          Icons.logout_sharp, color: Colors.red,
          //size: 30,
        ),
        label: const Text(
          'ออกจากระบบ',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
      ),
    );
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.pushAndRemoveUntil(context, route, (route) => true);
  }

  void _bottomSheet() {
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
                            child: Text('โปรไฟล์'),
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
                    onTap: () {
                      Navigator.pop(context);
                      navigateSecondPage(FullImageProfile(imageProfile: file));
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
                              child: Text('ดูรูปโปรไฟล์'),
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
                    onTap: () {
                      Navigator.pop(context);
                      navigateSecondPage(const EditProfile());
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
                              child: Text('แก้ไข'),
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
}

class FullImageProfile extends StatefulWidget {
  const FullImageProfile({Key? key, required this.imageProfile})
      : super(key: key);
  final String imageProfile;

  @override
  State<FullImageProfile> createState() => _FullImageProfileState();
}

class _FullImageProfileState extends State<FullImageProfile> {
  bool isLoading = true;
  double minScele = 1.0;
  double maxScele = 4.0;

  @override
  Widget build(BuildContext context) {
    return widget.imageProfile.isEmpty
        ? Image.asset('images/iconprofile.png')
        : InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: minScele,
            maxScale: maxScele,
            panEnabled: false,
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                alignment: Alignment.topRight,
                children: [
                  InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: minScele,
                    maxScale: maxScele,
                    panEnabled: false,
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: MyConstant().domain + widget.imageProfile,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              color: Colors.white,
                              radius: 15,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('images/iconprofile.png'),
                          fit: BoxFit.cover,
                          // height: height,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    top: 40,
                    right: 20,
                  ),
                ],
              ),
            ),
          );
  }
}
