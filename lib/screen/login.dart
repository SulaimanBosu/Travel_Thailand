// ignore_for_file: unnecessary_string_interpolations
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/register.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email, password, imageProfile;
  bool statusRedEye = true;
  late UserModel usermodel;
  final _email = TextEditingController();
  final _password = TextEditingController();
  late FocusNode myFocusEmail;
  late FocusNode myFocusPassword;

  @override
  void initState() {
    super.initState();
    myFocusEmail = FocusNode();
    myFocusPassword = FocusNode();
  }

  @override
  void dispose() {
    myFocusEmail.dispose();
    myFocusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            buildContent(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                          index: 0,
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                          context, route, (route) => true);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                CircleButton(
                  icon: MdiIcons.facebookMessenger,
                  iconSize: 30,
                  onPressed: () => debugPrint('facebookMessenger'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyStyle().showTitle('ลงชื่อเข้าใช้'),
              MyStyle().mySizebox(),
              const SizedBox(
                width: 8.0,
                height: 16.0,
              ),
              const SizedBox(
                width: 8.0,
                height: 16.0,
              ),
              emailForm(),
              const SizedBox(
                width: 8.0,
                height: 16.0,
              ),
              passwordForm(),
              const SizedBox(
                width: 8.0,
                height: 16.0,
              ),
              loginButton(),
              const SizedBox(
                width: 8.0,
                height: 16.0,
              ),
              forgot(),
              const SizedBox(
                width: 8.0,
                height: 46.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              // onChanged: (value) => user = value.trim(),
              controller: _email,
              focusNode: myFocusEmail,
              autofocus: true,
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
                labelText: 'Email : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              obscureText: statusRedEye,
              //  onChanged: (value) => password = value.trim(),
              controller: _password,
              focusNode: myFocusPassword,
              autofocus: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: statusRedEye
                        ? const Icon(
                            Icons.remove_red_eye,
                            color: Colors.black54,
                          )
                        : const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.black54,
                          ),
                    onPressed: () {
                      setState(() {
                        statusRedEye = !statusRedEye;
                      });
                    }),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'Password : ',
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget loginButton() => Container(
        width: 300.0,
        // ignore: deprecated_member_use
        child: RaisedButton(
          color: Colors.black26,
          onPressed: () async {
            //  await SQLiteHelper().deleteAllData();
            email = _email.value.text;
            password = _password.value.text;
            if (email.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกอีเมลล์ด้วยค่ะ');
              myFocusEmail.requestFocus();
            } else if (password.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกรหัสผ่านด้วยค่ะ');

              myFocusPassword.requestFocus();
            } else {
              checkUser();
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<void> checkUser() async {
    String url = '${MyConstant().domain}/application/login_post.php';
    FormData formData = FormData.fromMap(
      {
        "id": '1',
        "Email": email,
        "Password": password,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) async {
        var result = json.decode(value.data);
        String success = result['success'];
        String message = result['message'];
        debugPrint('Value == $result');
        if (success == '1') {
          String userID = result['UserID'];
          String emailformsql = result['Email'];
          String firstname = result['first_name'];
          String lastname = result['last_name'];
          String gender = result['Gender'];
          String phone = result['Phone'];
          imageProfile = result['Image_profile'];
          SharedPreferences preferences = await SharedPreferences.getInstance();

          preferences.setString('User_id', userID);
          preferences.setString('Email', emailformsql);
          preferences.setString('Password', password);
          preferences.setString('first_name', firstname);
          preferences.setString('last_name', lastname);
          preferences.setString('Gender', gender);
          preferences.setString('Phone', phone);
          preferences.setString('Image_profile', imageProfile);
          usermodel = UserModel.fromJson(result);

          usermodel.userId = userID;
          usermodel.email = emailformsql;
          usermodel.name = firstname;
          usermodel.lastname = lastname;
          usermodel.gender = gender;
          usermodel.phone = phone;
          usermodel.file = imageProfile;

          debugPrint('UserID == $userID');
          debugPrint('emailformsql == $emailformsql');
          debugPrint('first_name == $firstname');
          debugPrint('last_name == $lastname');
          debugPrint('gender == $gender');
          debugPrint('success == $success');
          debugPrint('message == $message');
          debugPrint('Image_profile == $imageProfile');

          routeToHome(usermodel);
          // dialog(context, usermodel);
        } else if (success == '2') {
          debugPrint('message == $message');
          MyStyle()
              .showdialog(context, 'คำเตือน', 'อีเมลล์หรือรหัสผ่านไม่ถูกต้อง');
        } else {
          MyStyle()
              .showdialog(context, 'คำเตือน', 'ไม่พบบัญชีผู้ใช้ $email ในระบบ');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> dialog(BuildContext context, UserModel userModel) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.black54,
                ),
                MyStyle().mySizebox(),
                MyStyle().showTitle_2('การแจ้งเตือน'),
              ]),
              const Divider(
                color: Colors.black54,
              ),
              showImage(context),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${userModel.name}\n${userModel.lastname}\n${userModel.phone}\n${userModel.userId}\n',
                overflow: TextOverflow.ellipsis,
                style: MyStyle().text2,
              ),
            ],
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  Container showImage(context) {
    return Container(
      child: CircleAvatar(
        radius: 90,
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(2), // Border radius
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(88), // Image radius
              child: CachedNetworkImage(
                imageUrl: MyConstant().domain + imageProfile,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    MyStyle().showProgress(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void routeToHome(UserModel userModel) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const HomeScreen(
        index: 0,
      ),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget forgot() {
    return Column(
      children: [
        const Text(
          'หรือ',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const HomeScreen(
                    index: 0,
                  ),
                );
                Navigator.pushAndRemoveUntil(context, route, (route) => true);
              },
              child: const Text(
                'ลืมรหัสผ่าน',
                style: TextStyle(
                  fontSize: 22.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              ),
            ),
            const SizedBox(
              width: 2.0,
            ),
            const Text(
              '/',
              style: TextStyle(
                fontSize: 22.0,
                //fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'FC-Minimal-Regular',
              ),
            ),
            const SizedBox(
              width: 2.0,
            ),
            InkWell(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const Register(),
                );
                Navigator.pushAndRemoveUntil(context, route, (route) => true);
              },
              child: const Text(
                'สมัครสมาชิก',
                style: TextStyle(
                  fontSize: 22.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
