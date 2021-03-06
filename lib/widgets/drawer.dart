import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/ProfilePage/edit_profile.dart';
import 'package:project/model/province_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/landmark_search.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/utility/signout_process.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/popup_menu.dart';
import 'package:resize/resize.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:slider_side_menu/slider_side_menu.dart';

class MyDrawer {
  int indexValue = 0;
  Drawer showDrawer(
    BuildContext context,
    String profile,
    String name,
    String lastname,
    String email,
  ) =>
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
                            PopupMenu(
                              onselect: (value) {
                                switch (value) {
                                  case 1:
                                    MyStyle().routeToWidget(context,
                                        const HomeScreen(index: 0), true);
                                    break;
                                  case 2:
                                    MyStyle().routeToWidget(context,
                                        const HomeScreen(index: 4), true);
                                    break;
                                  case 3:
                                    MyStyle().routeToWidget(context,
                                        const HomeScreen(index: 2), true);
                                    break;
                                  case 4:
                                    MyStyle().routeToWidget(
                                        context, const Login(), true);
                                    break;
                                  default:
                                    MyStyle().routeToWidget(context,
                                        const HomeScreen(index: 0), true);
                                }

                                debugPrint('ItemMenu ==== ${value.toString()}');
                              },
                              item: [
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.home_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('?????????????????????'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(MdiIcons.accountDetails),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('?????????????????????'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.settings),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('??????????????????????????????'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 4,
                                  child: Column(
                                    children: [
                                      const Divider(thickness: 1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                ? '?????????????????????????????????'
                                                : '??????????????????????????????',
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 4,
                                                    ));
                                        Navigator.push(context, route);
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
                                            '????????????????????????????????????',
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
                              Card(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    leading: const CircleAvatar(
                                      foregroundImage:
                                          AssetImage('images/icon-regian.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: const Text(
                                      '????????????????????????????????????',
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
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    leading: const CircleAvatar(
                                      radius: 15,
                                      foregroundImage: AssetImage(
                                          'images/category-icon.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: const Text(
                                      '????????????????????????',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                    children: [
                                      itemListCategory(
                                        context,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                // shadowColor: Colors.red,
                                // shape: RoundedRectangleBorder(
                                //   side: const BorderSide(
                                //     color: Colors.red,
                                //   ),
                                //   borderRadius: BorderRadius.circular(8.0),
                                // ),
                                elevation: 0,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        '?????????????????????????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        if (provinceModel.isEmpty) {
                                          MyStyle().showdialog(
                                              context,
                                              '?????????????????????',
                                              '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
                                        } else {
                                          buildBottomPicker(context);
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.star_outline_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        '???????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 1,
                                                    ));
                                        Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.favorite_outline_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        '??????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 2,
                                                    ));
                                        Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Colors.black54,
                                      ),
                                      title: const Text(
                                        '??????????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 3,
                                                    ));
                                        Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        MdiIcons.accountDetails,
                                      ),
                                      title: const Text(
                                        '?????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 4,
                                                    ));
                                        Navigator.push(context, route);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        MdiIcons.facebookMessenger,
                                      ),
                                      title: const Text(
                                        '???????????????????????????',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (value) =>
                                                    const HomeScreen(
                                                      index: 4,
                                                    ));
                                        Navigator.push(context, route);
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
                  HorizontalSlidableButton(
                    border: Border.all(
                        width: 1,
                        color: Colors
                            .black45 //                   <--- border width here
                        ),
                    tristate: true,
                    initialPosition: SlidableButtonPosition.start,
                    isRestart: true,
                    disabledColor: Colors.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    width: 65.vw,
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
                    height: 5.vh,
                  ),
                  // signOutMenu(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget itemListCategory(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      // shadowColor: Colors.red,
      // shape: RoundedRectangleBorder(
      //   side: const BorderSide(
      //     color: Colors.red,
      //   ),
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/beach-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/mountain-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '???????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/waterfall-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '???????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/dam-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '?????????????????????????????????/??????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '?????????????????????????????????/??????????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/cafe-icon.png'),
              radius: 15,
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '???????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/national-park-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '??????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '??????????????????????????????????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/trekking-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '?????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '?????????????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/camping-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '???????????????????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/history-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????????????????????????????/??????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '???????????????????????????????????????/??????????????????????????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/masjid-icon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '??????????????????/?????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '??????????????????/?????????',
                  type: 'type',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
        ],
      ),
    );
  }

  Widget itemListregian(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      // shadowColor: Colors.red,
      // shape: RoundedRectangleBorder(
      //   side: const BorderSide(
      //     color: Colors.red,
      //   ),
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '?????????????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '1',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-south.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '2',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-central.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '??????????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '3',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-eastern.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '??????????????????????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '4',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-western.jpg'),
              radius: 15,
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '???????????????????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '5',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              foregroundImage: AssetImage('images/icon-north-east.png'),
              backgroundColor: Colors.transparent,
            ),
            title: const Text(
              '????????????????????????????????????????????????????????????????????????????????????????????????????????????',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const LandmarkSearch(
                  search: '6',
                  type: 'region',
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => true);
            },
          ),
        ],
      ),
    );
  }

  Future buildBottomPicker(
    BuildContext context,
  ) {
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
                child: head(context, provinceModel),
              ),
            ),
            _buildBottomPicker(provinceModel),
          ],
        );
      },
    );
  }

  Widget head(BuildContext context, List<ProvinceModel> province) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            '??????????????????',
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
              '????????????????????????????????????',
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
            Route route = MaterialPageRoute(
                builder: (context) => LandmarkSearch(
                      search: '${province[indexValue].provinceName}',
                      type: 'province',
                    ));
            Navigator.pushAndRemoveUntil(context, route, (route) => true);

            // MaterialPageRoute route = MaterialPageRoute(
            //     builder: (value) => LandmarkProvince(
            //           provinceModel: province,
            //           provinceName: '${province[indexValue].provinceName}',
            //         ));
            // Navigator.push(context, route);
            debugPrint('Index ===== $indexValue');
            debugPrint('????????????????????? ===== ${province[indexValue].provinceName}');
          },
          child: const Text(
            '???????????????',
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

  Widget _buildBottomPicker(List<ProvinceModel> province) {
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
              childCount: province.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(province[index].provinceName!),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // CircleAvatar(
                    //   radius: 15,
                    //   backgroundImage:
                    //       const AssetImage('images/iconprofile.png'),
                    //   foregroundImage: NetworkImage(
                    //     province[index].provinceLogo!,
                    //   ),
                    // ),
                  ],
                );
              },
              itemExtent: 35,
              onSelectedItemChanged: (int value) {
                indexValue = value;
                // debugPrint('value ==== $value');
              },
            ),
          ),
        ),
      ),
    );
  }

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
          '??????????????????????????????',
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
