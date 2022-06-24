import 'dart:ui';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/ProfilePage/edit_profile.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/utility/signout_process.dart';
import 'package:project/widgets/icon_button.dart';

class MyDrawer {
  Drawer showDrawer(BuildContext context, String profile, String name,
          String lastname, String email) =>
      Drawer(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(10),
        //     bottomLeft: Radius.circular(10),
        //   ),
        // ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SafeArea(
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back_ios_new)),
                            CircleButton(
                              icon: MdiIcons.facebookMessenger,
                              iconSize: 30,
                              onPressed: () => debugPrint('facebookMessenger'),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 40,
                        // ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 80, left: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 4,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              2), // Border radius
                                          child: ClipOval(
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(
                                                  22), // Image radius
                                              child: profile == ''
                                                  ? Image.asset(
                                                      'images/iconprofile.png')
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          MyConstant().domain +
                                                              profile,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              MyStyle()
                                                                  .showProgress(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'images/iconprofile.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$name\t\t$lastname',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 22.0,
                                            fontFamily: 'FC-Minimal-Regular',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Route route = MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfile());
                                            Navigator.push(
                                              context,
                                              route,
                                            );
                                          },
                                          child: const Text(
                                            'แก้ไขโปรไฟล์',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18.0,
                                              fontFamily: 'FC-Minimal-Regular',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0, right: 20, top: 20, bottom: 10),
                                child: Divider(color: Colors.black54),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.email_outlined),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 22.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0, right: 20, top: 10, bottom: 10),
                                child: Divider(color: Colors.black54),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: const CircleAvatar(
                                    foregroundImage:
                                        AssetImage('images/icon-regian.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: const Text(
                                    'เลือกภูมิภาค',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                  children: [
                                    itemListregian(context),
                                  ],
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: const CircleAvatar(
                                    foregroundImage:
                                        AssetImage('images/icon-regian.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: const Text(
                                    'หมวดหมู่',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20.0,
                                      fontFamily: 'FC-Minimal-Regular',
                                    ),
                                  ),
                                  children: [
                                    itemListCategory(context),
                                  ],
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                // shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.thumb_up_alt_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        'แหล่งท่องเที่ยวแนะนำ',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 0,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.star_outline_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        'แหล่งท่องเที่ยวยอดฮิต',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 1,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.favorite_outline_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        'รายการโปรด',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 2,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        'แหล่งท่องเที่ยวทั้งหมด',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 3,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        MdiIcons.accountDetails,
                                      ),
                                      title: const Text(
                                        'โปรไฟล์',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 4,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        MdiIcons.facebookMessenger,
                                      ),
                                      title: const Text(
                                        'ติดต่อเรา',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        // MaterialPageRoute route =
                                        //     MaterialPageRoute(
                                        //         builder: (value) =>
                                        //             const HomeScreen(
                                        //               index: 4,
                                        //             ));
                                        // Navigator.push(context, route);
                                      },
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
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  signOutMenu(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget itemListCategory(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      // shadowColor: Colors.red,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'ทะเล',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              selectProvince(context);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-south.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'ภูเขา',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              buildBottomPicker(context);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-central.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'น้ำตก',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-eastern.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'อ่างเก็บน้ำ/เขื่อน',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-western.jpg'),
              radius: 15,
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'คาเฟ่',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north-east.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'อุทยานแห่งชาติ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north-east.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'เดินป่า',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
                    ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north-east.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แคมป์ปิ้ง',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }

  Widget itemListregian(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      // shadowColor: Colors.red,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคเหนือ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              selectProvince(context);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-south.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคใต้',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              buildBottomPicker(context);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-central.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคกลาง',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
            // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-eastern.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคตะวันออก',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-western.jpg'),
              radius: 15,
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคตะวันตก',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north-east.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              'แหล่งท่องเที่ยวภาคตะวันออกเฉียงเหนือ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //     builder: (value) => const HomeScreen(
              //           index: 0,
              //         ));
              // Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }

  Future buildBottomPicker(BuildContext context) {
    return showCupertinoModalPopup<void>(
      barrierDismissible: true,
      useRootNavigator: true,
      semanticsDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: headBottomPicker(context),
              ),
            ),
            _buildBottomPicker(),
          ],
        );
      },
    );
  }

  Row headBottomPicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'ยกเลิก',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 24.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
        ),
        Column(
          children: const [
            Text(
              'เลือกจังหวัด',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black54,
                fontSize: 26.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'เลือก',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 24.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPicker() {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: CupertinoPicker.builder(
              useMagnifier: true,
              childCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('data'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.access_time),
                  ],
                );
              },
              itemExtent: 35,
              onSelectedItemChanged: (int value) {
                debugPrint('value ==== $value');
              },
            ),
          ),
        ),
      ),
    );
  }

  void selectProvince(BuildContext context) {
    BottomPicker(
            items: bottomPickerItem,
            itemExtent: 35,
            title: 'เลือกจังหวัด',
            titleStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 26.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
            pickerTextStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            displaySubmitButton: true,
            buttonText: 'เลือก',
            buttonTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
            selectedItemIndex: 1,
            onSubmit: (index) {
              Navigator.of(context);

              print('index ==== $index');
            },
            buttonSingleColor: Colors.red,
            closeIconColor: Colors.black54)
        .show(context);
  }

  List<Text> bottomPickerItem = [
    const Text(
      'Leonardo DiCaprio',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontFamily: 'FC-Minimal-Regular',
      ),
    ),
    const Text(
      'Johnny Depp',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontFamily: 'FC-Minimal-Regular',
      ),
    ),
    const Text(
      'Robert De Niro',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontFamily: 'FC-Minimal-Regular',
      ),
    ),
    const Text(
      'Tom Hardy',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontFamily: 'FC-Minimal-Regular',
      ),
    ),
    const Text(
      'Ben Affleck',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontFamily: 'FC-Minimal-Regular',
      ),
    ),
  ];
  Widget signOutMenu(BuildContext context) {
    return
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(10),
        //         topRight: Radius.circular(10),
        //       ),
        //       color: Colors.red.shade600),
        //   child:
        Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size(double.maxFinite, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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

  MyDrawer();
}
