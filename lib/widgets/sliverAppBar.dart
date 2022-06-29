import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/search_widget.dart';

class SliverappBar {
  Widget appbar(
      BuildContext context,
      double screenwidth,
      String? userid,
      var scaffoldKey,
      bool isLoading,
      VoidCallback onPressed,
      bool search,
      VoidCallback onTap) {
        TextEditingController controller = TextEditingController();
    return SliverAppBar(
      backgroundColor: Colors.white,
      flexibleSpace: !search
          ? null
          : FlexibleSpaceBar(
              background: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
                    child: Container(
                      height: 36.0,
                      width: double.infinity,
                      child: CupertinoTextField(
                        controller: controller,
                        onChanged: ((value) {
                          debugPrint('controller ===== ${controller.text}');
                        }),
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        placeholder: 'ค้นหาแหล่งท่องเที่ยว',
                        placeholderStyle: const TextStyle(
                          color: Color(0xffC4C6CC),
                          fontSize: 14.0,
                          fontFamily: 'Brutal',
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                          child: Icon(
                            Icons.search,
                            color: Color(0xffC4C6CC),
                          ),
                        ),
                        suffix: InkWell(
                          onTap: () {
                            onTap();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 9),
                            child: Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xffF0F1F5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      brightness: Brightness.light,
      title: search
          ? null
          : Text(
              'Travel Thailand',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: screenwidth * 0.05,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2),
            ),
      centerTitle: false,
      floating: true,
      actions: search
          ? null
          : [
              CircleButton(
                  icon: Icons.search,
                  iconSize: 30,
                  onPressed: () {
                    if (!isLoading) {
                      if (userid == '') {
                        MyStyle().routeToWidget(context, const Login(), true);
                      } else {
                        onPressed();
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
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => const SearchWidget(),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => false);
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
