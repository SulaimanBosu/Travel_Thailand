// ignore_for_file: unnecessary_string_interpolations
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/screen/register.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email, password, imageProfile;
  bool statusRedEye = true;
  bool statusRedEyenewPassword = true;
  bool statusRedEyeconfirmNewPassword = true;
  late UserModel usermodel;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailresetPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();
  late FocusNode myFocusEmail;
  late FocusNode myFocusPassword;
  bool isResetPassword = false;

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

  Future<void> checkEmailAndUpdatePassword(
      String id, String _email, String _password) async {
    String url = '${MyConstant().domain}/application/login_post.php';
    FormData formData = FormData.fromMap(
      {
        "id": id,
        "Email": _email,
        id == '2' ? '' : "Password": _password,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) async {
        var result = json.decode(value.data);
        String success = result['success'];
        debugPrint('Value == $result');
        if (success == '1') {
          Random random = Random();
          int i = random.nextInt(1000000);
          String newPassword = '$i';
          String email = result['Email'];
          String name = result['User_first_name'];
          sendAndResetPassword(
              firstName: name, email: email, message: newPassword);
        } else if (success == '0') {
          setState(() {
            isResetPassword = false;
          });
          debugPrint("reset password success");
          // MyAlertDialog().showcupertinoDialog(context, 'รีเซ็ตรหัสผ่านสำเร็จ');
          MyStyle().showdialog(context, 'แจ้งเตือน',
              'รีเซ็ตรหัสผ่านของท่านแล้ว\nโปรดตรวจสอบรหัสผ่านใหม่ในอีเมลล์ของท่าน');
          _emailresetPassword.clear();
        } else if (success == '2') {
          setState(() {
            isResetPassword = false;
          });
          _emailresetPassword.clear();
          MyAlertDialog().showcupertinoDialog(
              context, 'อีเมลล์ $_email ยังไม่ได้ลงทะเบียน');
        } else if (success == '3') {
          setState(() {
            isResetPassword = false;
          });
          MyAlertDialog().showcupertinoDialog(context, 'รีเซ็ตรหัสผ่านล้มเหลว');
        } else if (success == '4') {
          setState(() {
            isResetPassword = false;
          });
          MyStyle()
              .showdialog(context, 'แจ้งเตือน', 'เปลี่ยนรหัสผ่านเรียบร้อย');
          // MyStyle().showBasicsFlash(
          //   context: context,
          //   text: 'เปลี่ยนรหัสผ่านเรียบร้อย',
          //   duration: const Duration(seconds: 5),
          //   flashStyle: FlashBehavior.floating,
          // );
          password = newPassword.text;
          // checkUser();
        } else if (success == '5') {
          setState(() {
            isResetPassword = false;
          });
          MyAlertDialog()
              .showcupertinoDialog(context, 'เปลี่ยนรหัสผ่านล้มเหลว');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      setState(() {
        isResetPassword = false;
      });
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  void sendAndResetPassword({
    required String firstName,
    required String email,
    required String message,
  }) async {
    String serviceId = 'service_92fghrr';
    String templateId = 'template_nd04fvr';
    String userid = 'LrzLoxKR7vqW5NWBU';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userid,
        'template_params': {
          'user_name': firstName,
          'user_email': email,
          'user_subject': 'รีเซ็ตรหัสผ่าน',
          'user_message': 'รหัสผ่านใหม่ของคุณคือ $message',
        }
      }),
    );
    debugPrint('response ====== ${response.body}');

    if (response.body == 'OK') {
      checkEmailAndUpdatePassword('3', email, message);
    } else {
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isResetPassword
            ? Stack(
                children: [
                  Stack(
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
                            icon: const Icon(Icons.arrow_back_ios_new_outlined),
                          ),
                          CircleButton(
                            icon: MdiIcons.facebookMessenger,
                            iconSize: 30,
                            onPressed: () => debugPrint('facebookMessenger'),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 100.vw,
                      height: 100.vh,
                      color: Colors.transparent,
                      child: const CupertinoActivityIndicator(
                        animating: true,
                        radius: 15,
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
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
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      CircleButton(
                        icon: MdiIcons.facebookMessenger,
                        iconSize: 30,
                        onPressed: () => debugPrint('facebookMessenger'),
                        color: Colors.black,
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
              keyboardType: TextInputType.emailAddress,
              // onChanged: (value) => user = value.trim(),
              controller: _email,
              focusNode: myFocusEmail,
              //  autofocus: true,
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
              keyboardType: TextInputType.text,
              obscureText: statusRedEye,
              //  onChanged: (value) => password = value.trim(),
              controller: _password,
              focusNode: myFocusPassword,
              // autofocus: true,
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
          String imageCoverPage = result['Image_CoverPage'];
          SharedPreferences preferences = await SharedPreferences.getInstance();

          preferences.setString('User_id', userID);
          preferences.setString('Email', emailformsql);
          preferences.setString('Password', password);
          preferences.setString('first_name', firstname);
          preferences.setString('last_name', lastname);
          preferences.setString('Gender', gender);
          preferences.setString('Phone', phone);
          preferences.setString('Image_profile', imageProfile);
          preferences.setString('Image_CoverPage', imageCoverPage);
          usermodel = UserModel.fromJson(result);

          usermodel.userId = userID;
          usermodel.email = emailformsql;
          usermodel.name = firstname;
          usermodel.lastname = lastname;
          usermodel.gender = gender;
          usermodel.phone = phone;
          usermodel.file = imageProfile;
          usermodel.imagecoverPage = imageCoverPage;

          debugPrint('UserID == $userID');
          debugPrint('emailformsql == $emailformsql');
          debugPrint('first_name == $firstname');
          debugPrint('last_name == $lastname');
          debugPrint('gender == $gender');
          debugPrint('success == $success');
          debugPrint('message == $message');
          debugPrint('Image_profile == $imageProfile');
          debugPrint('Image_CoverPage == $imageCoverPage');
          newPassword.clear();
          confirmNewPassword.clear();
          Navigator.pop(context);
          routeToHome(usermodel);
          // dialog(context, usermodel);
        } else if (success == '2') {
          debugPrint('message == $message');
          MyStyle()
              .showdialog(context, 'คำเตือน', 'อีเมลล์หรือรหัสผ่านไม่ถูกต้อง');
        } else if (success == '0') {
          editPasswordDialog();
          // MyStyle().showdialog(context, 'คำเตือน', 'กรุณาเปลี่ยนรหัสผ่านใหม่');
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

  void routeToHome(UserModel userModel) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const HomeScreen(
        index: 0,
      ),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  editPasswordDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'เปลี่ยนรหัสผ่าน',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          //  fontWeight: FontWeight.bold,
                          color: Colors.red,
                          // fontStyle: FontStyle.italic,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                      )
                    ],
                  ),
                  const Divider(color: Colors.black54, thickness: 1),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'กรุณาเปลี่ยนรหัสผ่านใหม่',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.red,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                    overflow: TextOverflow.fade,
                  )
                ],
              ),
              content: Container(
                height: 20.vh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: 90.vw,
                      child: TextField(
                        autofocus: true,
                        obscureText: statusRedEyenewPassword,
                        keyboardType: TextInputType.text,
                        controller: newPassword,
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
                                  statusRedEyenewPassword =
                                      !statusRedEyenewPassword;
                                });
                              }),
                          prefixIcon: const Icon(
                            Icons.lock_open,
                            color: Colors.black54,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 22.0,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            // fontStyle: FontStyle.italic,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                          labelText: 'รหัสผ่านใหม่ : ',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: 90.vw,
                      child: TextField(
                        obscureText: statusRedEyeconfirmNewPassword,
                        keyboardType: TextInputType.text,
                        controller: confirmNewPassword,
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
                                  statusRedEyeconfirmNewPassword =
                                      !statusRedEyeconfirmNewPassword;
                                });
                              }),
                          prefixIcon: const Icon(
                            Icons.lock_open,
                            color: Colors.black54,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 22.0,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            // fontStyle: FontStyle.italic,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                          labelText: 'ยืนยันรหัสผ่านใหม่ : ',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        if (newPassword.text.isNotEmpty &&
                            confirmNewPassword.text.isNotEmpty) {
                          if (newPassword.text == confirmNewPassword.text) {
                            checkEmailAndUpdatePassword(
                                '4', _email.text, newPassword.text);
                            setState(() {
                              isResetPassword = true;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'กรุณากรอกรหัสผ่านให้ตรงกันด้วยค่ะ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'กรุณากรอกรหัสผ่านให้ครบถ้วนด้วยค่ะ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width: 30.vw,
                          height: 4.vh,
                          child: Text(
                            'เปลี่ยนรหัสผ่าน',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width: 30.vw,
                          height: 4.vh,
                          child: Text(
                            'ยกเลิก',
                            style:
                                TextStyle(color: Colors.red, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          });
        });
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
                showdialog();
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

  showdialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lock_reset_rounded,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'รีเซ็ตรหัสผ่าน',
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.red,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                  )
                ],
              ),
              const Divider(color: Colors.black54, thickness: 1),
              const SizedBox(
                height: 16,
              ),
              Text(
                'กรอกอีเมลล์ของท่าน เพื่อรีเซ็ตรหัสผ่าน',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  //  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                overflow: TextOverflow.fade,
              )
            ],
          ),
          content: Container(
            width: 90.vw,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailresetPassword,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'อีเมลล์ : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    if (_emailresetPassword.text.isEmpty ||
                        _emailresetPassword.text == '') {
                      MyAlertDialog()
                          .showtDialog(context, 'กรุณากรอกอีเมลล์ด้วยค่ะ');
                      Navigator.pop(context);
                    } else {
                      checkEmailAndUpdatePassword(
                          '2', _emailresetPassword.text, '');
                      setState(() {
                        isResetPassword = true;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 5,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30.vw,
                      height: 4.vh,
                      child: Text(
                        'รีเซ็ต',
                        style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 5,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30.vw,
                      height: 4.vh,
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }
}
