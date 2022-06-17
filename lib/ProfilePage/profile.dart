import 'dart:async';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/ProfilePage/edit_profile.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/utility/signout_process.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/popover.dart';
import 'package:project/widgets/sliverAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

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
      password = '';
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
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
    password = preferences.getString('Password')!;
    debugPrint('User id ====> $userId');
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
    return
        // BlurryModalProgressHUD(
        //   inAsyncCall: isLoading,
        //   blurEffectIntensity: 2,
        //   progressIndicator: const CupertinoActivityIndicator(
        //     animating: true,
        //     radius: 15,
        //   ),
        //   dismissible: false,
        //   opacity: 0.3,
        //   color: Colors.white,
        //   child:
        Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      endDrawer: isLoading
          ? null
          : MyDrawer().showDrawer(context, file, name, lastname, email),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            isLoading
                ? SliverappBar()
                    .appbar(context, screenwidth, userId, scaffoldKey, true)
                : onData == false
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverappBar().appbar(
                        context, screenwidth, userId, scaffoldKey, false),
            isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.84,
                        child: MyStyle().progress(context)),
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
                                      navigateSecondPage(const EditProfile());
                                      // _bottomSheet();
                                      // showBottomsheet();
                                      // navigateSecondPage(const EditImagePage());
                                    },
                                    child: Stack(
                                      children: [
                                        // showImage(context),
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
    );
  }

  Widget userprofile() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 90,
        backgroundColor: Colors.red,
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

  //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  Container showImage(context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: file.isNotEmpty
          ? UserProfileAvatar(
              avatarUrl: MyConstant().domain + file,
              onAvatarTap: () {
                navigateSecondPage(const EditProfile());
              },
              avatarSplashColor: Colors.red,
              radius: 90,
              isActivityIndicatorSmall: true,
              avatarBorderData: AvatarBorderData(
                borderColor: Colors.redAccent,
                borderWidth: 2.0,
              ),
            )
          : const CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage('images/iconprofile.png'),
            ),
    );
  }

  Future showBottomsheet(String getValue, String title) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      //enableDrag:true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.95,
          color: Colors.white70,
          child: editform(),
        );
      },
    );
  }

  Widget editform() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'ชื่อ : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'นามสกุล : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'เบอร์โทร : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'อีเมลล์ : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'รหัสผ่าน : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'รหัสผ่านใหม่ : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 300.0,
                child: TextField(
                  // onChanged: (value) => user = value.trim(),
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    labelText: 'ยืนยันรหัสผ่านใหม่ : ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
              width: screenwidth * 0.8,
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
                      style: const TextStyle(fontSize: 16, height: 1.4),
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
                            child: Text('เลือกรูปภาพ'),
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
                              child: Text('ถ่ายภาพ'),
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
                              child: Text('เลือกที่มีอยู่'),
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

  void _handleFABPressed() {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Column(
            children: [
              _buildListItem(
                context,
                title: const Text('Total Task'),
                leading: const Icon(Icons.check_circle_outline),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              _buildListItem(
                context,
                title: const Text('Due Soon'),
                leading: const Icon(Icons.inbox),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              _buildListItem(
                context,
                title: const Text('Completed'),
                leading: const Icon(Icons.check_circle),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              _buildListItem(
                context,
                title: const Text('Working On'),
                leading: const Icon(Icons.flag),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    Widget? title,
    Widget? leading,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 10.0,
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
        children: [
          if (leading != null) leading,
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                child: title,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              ),
            ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget progress() {
    return Center(
      child: BlurryModalProgressHUD(
        inAsyncCall: isLoading,
        blurEffectIntensity: 4,
        // progressIndicator: SpinKitFadingCircle(
        // color: Colors.redAccent,
        // size: 90.0,
        // ),
        dismissible: false,
        opacity: 0.4,
        color: Colors.black87,
        child: const Scaffold(),
      ),
    );
  }
}
