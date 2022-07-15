import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/ProfilePage/profile.dart';
import 'package:project/widgets/popover.dart';
import 'package:resize/resize.dart';
import 'package:toast/toast.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green.shade400;
  Color redColor = Colors.red;
  Color appbarColor = Colors.red;

  Text textdetail_1(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Widget showProgress() {
    return const Center(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 15,
      ),

      //  CircularProgressIndicator(
      //   backgroundColor: Colors.white,
      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      // ),
    );
  }


    showBasicsFlash({
    BuildContext? context,
    String? text,
    Duration? duration,
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context!,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.top,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.redAccent,
                ),
                MyStyle().mySizebox(),
                Text(text!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showProgress2(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(
            animating: true,
            radius: 15,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 12.0.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 10.sp,
    // fontWeight: FontWeight.bold,
    color: Colors.black54,
    // fontStyle: FontStyle.italic,
    // fontFamily: 'FC-Minimal-Regular',
  );

  TextStyle text2 = const TextStyle(
    fontSize: 22.0,
    // fontWeight: FontWeight.bold,
    color: Colors.black45,
    // fontStyle: FontStyle.italic,
    fontFamily: 'FC-Minimal-Regular',
  );
  Text showtext_1(String title) => Text(
        title,
        style: mainH2Title,
      );

  Text showtext_2(String title) => Text(
        title,
        style: text2,
      );

  Text showTitle_2(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 24.0,
          // fontWeight: FontWeight.bold,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 1.5.vh,
      );

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text showText(String title) => Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontStyle: FontStyle.italic,
        ),
      );

  Text showTitle(String title) => Text(
        title,
        style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 28,
            fontFamily: 'FC-Minimal-Regular',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      );

  Text showTitleH2(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 24.0,
          // fontWeight: FontWeight.bold,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Text showTitleH2white(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      );

  Text showTitleCart(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black45,
          // fontStyle: FontStyle.italic,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Text showTitleH3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade300,
          fontWeight: FontWeight.bold,
        ),
      );

  confirmDialog2(
    BuildContext context,
    String imageUrl,
    String textTitle,
    String textContent,
    Widget prossedYes,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.network(
              '$imageUrl',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text(textTitle)
          ]),
          content: Text(textContent),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ตกลง"),
              onPressed: () {
                debugPrint('');
                Navigator.of(context).pop();
                // ใส่เงื่อนไขการกดตกลง
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => prossedYes);
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                // ใส่เงื่อนไขการกดยกเลิก

                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
      },
    );
  }

  confirmDialog(
    BuildContext context,
    String textTitle,
    String textContent,
    Widget prossedYes,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [Text(textTitle)]),
          content: Text(textContent),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop();
                // ใส่เงื่อนไขการกดตกลง
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => prossedYes);
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                // ใส่เงื่อนไขการกดยกเลิก

                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
      },
    );
  }

  showdialog(
    BuildContext context,
    String textTitle,
    String textContent,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    textTitle,
                    style: const TextStyle(
                      fontSize: 26.0,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.red,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                  )
                ],
              ),
              const Divider(color: Colors.black54, thickness: 1)
            ],
          ),
          content: Text(
            textContent,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22.0,
              // fontWeight: FontWeight.bold,
              color: Colors.black45,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }

  Container showlogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$namePic'), fit: BoxFit.cover),
    );
  }

  void routeToWidget(BuildContext context, Widget myWidget, bool onback) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => onback);
  }

  void bottomSheet(BuildContext context, String item, String item2, profile,
      VoidCallback onselect, String title) {
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: DefaultTextStyle(
                            child: Text(title),
                            style: const TextStyle(
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
                      MyStyle().routeToWidget(context,
                          FullImageProfile(imageProfile: profile), true);
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text(item),
                              style: const TextStyle(
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
                      onselect();
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text(item2),
                              style: const TextStyle(
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

  Widget jumpingProgress(BuildContext context) {
    return JumpingDotsProgressIndicator(
      color: Colors.red,
      fontSize: 40.0.sp,
    );
  }

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const CupertinoActivityIndicator(
                      animating: true,
                      radius: 15,
                    ),

                    // const CircularProgressIndicator(
                    //   value: null,
                    //   backgroundColor: Colors.white,
                    //   valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    //   strokeWidth: 7.0,
                    // ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: JumpingText(
                      'ดาวน์โหลด...',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  MyStyle();
}
