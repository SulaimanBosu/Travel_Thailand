import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';

class SliverappBar {
  Widget appbar(BuildContext context, double screenwidth, String? userid,
      var scaffoldKey, bool isLoading) {
    return SliverAppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        'Travel Thailand',
        style: TextStyle(
            color: Colors.redAccent,
            fontSize: screenwidth * 0.05,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2),
      ),
      centerTitle: false,
      floating: true,
      actions: [
        CircleButton(
            icon: Icons.search,
            iconSize: 30,
            onPressed: () {
              if (!isLoading) {
                if (userid == '') {
                  MyStyle().routeToWidget(context, const Login(), true);
                } else {
                  scaffoldKey.currentState!.openEndDrawer();
                }
              } else {
                debugPrint('search');
              }
            }),
        CircleButton(
            icon: MdiIcons.facebookMessenger,
            iconSize: 30,
            onPressed: () {
              if (!isLoading) {
                if (userid == '') {
                  MyStyle().routeToWidget(context, const Login(), true);
                } else {
                  scaffoldKey.currentState!.openEndDrawer();
                }
              } else {
                debugPrint('facebookMessenger');
              }
            }),
        CircleButton(
          icon: MdiIcons.accountDetails,
          iconSize: 30,
          onPressed: () {
            if (!isLoading) {
              if (userid == '') {
                MyStyle().routeToWidget(context, const Login(), true);
              } else {
                scaffoldKey.currentState!.openEndDrawer();
              }
            } else {
              debugPrint('Account');
            }
          },
        )
      ],
    );
  }

  SliverappBar();
}
