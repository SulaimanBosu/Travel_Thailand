import 'package:cached_network_image/cached_network_image.dart';
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
                              ListTile(
                                leading: const Icon(
                                  Icons.recommend_outlined,
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
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
                                            index: 0,
                                          ));
                                  Navigator.push(context, route);
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
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
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
                                  'รายการโปรด',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
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
                                  'แหล่งท่องเที่ยวทั้งหมด',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
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
                                  'โปรไฟล์',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
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
                                  'ติดต่อเรา',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (value) => const HomeScreen(
                                            index: 4,
                                          ));
                                  Navigator.push(context, route);
                                },
                              ),
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
