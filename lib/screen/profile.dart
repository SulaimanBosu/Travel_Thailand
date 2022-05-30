import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';

class Profile extends StatefulWidget {
  
  const Profile({ Key? key,}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                                      child: CachedNetworkImage(
                                        imageUrl: MyConstant().domain,
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
      
    );
  }
}