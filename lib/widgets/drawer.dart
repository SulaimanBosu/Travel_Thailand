import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/utility/signout_process.dart';
import 'package:project/widgets/icon_button.dart';

class MyDrawer {
  Drawer showDrawer(BuildContext context, String profile, String name) =>
      Drawer(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(10),
        //     bottomLeft: Radius.circular(10),
        //   ),
        // ),
        child: Stack(
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
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 40),
                              child: CircleAvatar(
                                radius: 90,
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(2), // Border radius
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          88), // Image radius
                                      child: profile =='' ? Image.asset('images/iconprofile.png') :CachedNetworkImage(
                                        imageUrl: MyConstant().domain + profile,
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
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.black54,
                              ),
                              title: const Text(
                                'Sign Out',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18.0),
                              ),
                              subtitle: const Text(
                                'ออกจากระบบ',
                                style: TextStyle(color: Colors.black54),
                              ),
                              onTap: () {
                                signOutProcess(context);
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
        OutlinedButton.icon(
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
          fontSize: 30.0,
          fontFamily: 'FC-Minimal-Regular',
        ),
      ),
    );
  }
  MyDrawer();
}
