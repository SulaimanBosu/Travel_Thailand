import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/ProfilePage/edit_email.dart';
import 'package:project/ProfilePage/edit_name.dart';
import 'package:project/ProfilePage/edit_phone.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserModel user;
  late String userId, name, lastname, file, phone, gender, email;
  late SharedPreferences preferences;
  bool onData = false;
  final _controller = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    getPreferences();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {});
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
    if (userId.isNotEmpty) {
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
    return Scaffold(
        body: !onData
            ?  const Login()     //MyStyle().progress(context)
            : Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 10,
                  ),
                  const Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(64, 105, 225, 1),
                            ),
                          ))),
                  InkWell(
                    onTap: () {
                      // showBottomsheet();
                      // navigateSecondPage(const EditImagePage());
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(2), // Border radius
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(88), // Image radius
                            child: CachedNetworkImage(
                              imageUrl: MyConstant().domain + file,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      MyStyle().showProgress(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildUserInfoDisplay(name, 'Name', const EditNameFormPage()),
                  buildUserInfoDisplay(phone,'Phone', const EditPhoneFormPage()),
                  buildUserInfoDisplay(email,'Email', const EditEmailFormPage()),

                  // Expanded(
                  //   child: buildAbout(user),
                  //   flex: 4,
                  // )
                ],
              )

        //  Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     SafeArea(
        //       child: Stack(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               IconButton(
        //                   onPressed: () => Navigator.of(context).pop(),
        //                   icon: const Icon(Icons.arrow_back_ios_new)),
        //               CircleButton(
        //                 icon: MdiIcons.facebookMessenger,
        //                 iconSize: 30,
        //                 onPressed: () => debugPrint('facebookMessenger'),
        //               ),
        //             ],
        //           ),
        //           Center(
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 Container(
        //                   padding: const EdgeInsets.only(top: 40),
        //                   child: CircleAvatar(
        //                     radius: 90,
        //                     backgroundColor: Colors.black,
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(2), // Border radius
        //                       child: ClipOval(
        //                         child: SizedBox.fromSize(
        //                           size: const Size.fromRadius(88), // Image radius
        //                           child: CachedNetworkImage(
        //                             imageUrl: MyConstant().domain,
        //                             progressIndicatorBuilder:
        //                                 (context, url, downloadProgress) =>
        //                                     MyStyle().showProgress(),
        //                             errorWidget: (context, url, error) =>
        //                                 const Icon(Icons.error),
        //                             fit: BoxFit.cover,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 ListTile(
        //                   leading: const Icon(
        //                     Icons.account_circle,
        //                     color: Colors.black54,
        //                   ),
        //                   title: const Text(
        //                     'ชื่อ',
        //                     style:
        //                         TextStyle(color: Colors.black54, fontSize: 18.0),
        //                   ),
        //                   subtitle: const Text(
        //                     'sulaiman',
        //                     style: TextStyle(color: Colors.black54),
        //                   ),
        //                   onTap: () {},
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
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
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Row(children: [
                  Expanded(
                      child: TextButton(
                          onPressed: () {
                            showBottomsheet(getValue, title);
                            //navigateSecondPage(editPage);
                          },
                          child: Text(
                            getValue,
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ))),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  )
                ]))
          ],
        ),
      );

  Widget buildAbout(UserModel user) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          //  navigateSecondPage(EditDescriptionFormPage());
                        },
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.email!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ))))),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
