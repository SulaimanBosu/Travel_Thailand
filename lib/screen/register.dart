// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/icon_button.dart';
import 'package:project/widgets/popover.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late double screenWidth;
  late double screenHight;
  late String name, lastname, phone, email, password, conpassword;
  bool statusRedEyepassword = true;
  bool statusRedEyeconpassword = true;
  File? file, coverPagefile;
  var gender;
  final picker = ImagePicker();
  // bool uploadStatus = true;
  final fileName = 'No File Selected';
  late UserModel userModel;
  final _name = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _conpassword = TextEditingController();
  late FocusNode myFocusName;
  late FocusNode myFocusLastname;
  late FocusNode myFocusPhone;
  late FocusNode myFocusEmail;
  late FocusNode myFocusPassword;
  late FocusNode myFocusConpassword;
  bool isLoading = false;
  bool isProfile = true;

  @override
  void initState() {
    super.initState();
    myFocusName = FocusNode();
    myFocusLastname = FocusNode();
    myFocusPhone = FocusNode();
    myFocusEmail = FocusNode();
    myFocusPassword = FocusNode();
    myFocusConpassword = FocusNode();
  }

  @override
  void dispose() {
    myFocusName.dispose();
    myFocusLastname.dispose();
    myFocusPhone.dispose();
    myFocusEmail.dispose();
    myFocusPassword.dispose();
    myFocusConpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black54,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
        actions: [
          CircleButton(
            icon: MdiIcons.facebookMessenger,
            iconSize: 30,
            onPressed: () => debugPrint('facebookMessenger'),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading ? progress(context) : buildContent(context),
    );
  }

  SafeArea buildContent(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            showImageCoverPage(context),
                            showImage(context),
                          ],
                        ),
                        MyStyle().mySizebox(),
                        nameForm(),
                        MyStyle().mySizebox(),
                        lastnameForm(),
                        MyStyle().mySizebox(),
                        phoneForm(),
                        MyStyle().mySizebox(),
                        radio(),
                        MyStyle().mySizebox(),
                        emailForm(),
                        MyStyle().mySizebox(),
                        passwordForm(),
                        MyStyle().mySizebox(),
                        conpasswordForm(),
                        MyStyle().mySizebox(),
                        registerButton(context),
                        MyStyle().mySizebox(),
                        MyStyle().mySizebox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SafeArea buildContent(BuildContext context) {
  //   final fileName = file != null ? basename(file!.path) : 'No File Selected';
  //   return SafeArea(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           Stack(
  //             children: [
  //               //showImageCoverPage(context),
  //               showImage(context),
  //             ],
  //           ),
  //           // OutlinedButton(
  //           //   style: OutlinedButton.styleFrom(
  //           //     fixedSize: const Size(170, 35),
  //           //     shape: RoundedRectangleBorder(
  //           //       borderRadius: BorderRadius.circular(12),
  //           //     ),
  //           //   ),
  //           //   onPressed: () {
  //           //     _bottomSheet(context);
  //           //     //_showPicker(context);
  //           //   },
  //           //   child: Row(
  //           //     mainAxisAlignment: MainAxisAlignment.center,
  //           //     children: [
  //           //       const Icon(
  //           //         Icons.add_a_photo,
  //           //         color: Colors.black54,
  //           //       ),
  //           //       const SizedBox(
  //           //         width: 10,
  //           //       ),
  //           //       Text(
  //           //         file == null ? 'เพิ่มรูปภาพ' : 'เปลี่ยนรูปโปรไฟล์',
  //           //         style: const TextStyle(
  //           //           fontSize: 16.0,
  //           //           color: Colors.black54,
  //           //           fontFamily: 'FC-Minimal-Regular',
  //           //         ),
  //           //       ),
  //           //     ],
  //           //   ),
  //           // ),
  //           // // SizedBox(height: 8),
  //           // Text(
  //           //   fileName,
  //           //   overflow: TextOverflow.ellipsis,
  //           //   style: TextStyle(
  //           //     //fontWeight: FontWeight.bold,
  //           //     fontSize: 16.0,
  //           //     color: file == null ? Colors.redAccent : Colors.black54,
  //           //     fontFamily: 'FC-Minimal-Regular',
  //           //   ),
  //           //   textAlign: TextAlign.center,
  //           // ),
  //           MyStyle().mySizebox(),
  //           nameForm(),
  //           MyStyle().mySizebox(),
  //           lastnameForm(),
  //           MyStyle().mySizebox(),
  //           phoneForm(),
  //           MyStyle().mySizebox(),
  //           radio(),
  //           MyStyle().mySizebox(),
  //           emailForm(),
  //           MyStyle().mySizebox(),
  //           passwordForm(),
  //           MyStyle().mySizebox(),
  //           conpasswordForm(),
  //           MyStyle().mySizebox(),
  //           registerButton(context),
  //           MyStyle().mySizebox(),
  //           MyStyle().mySizebox(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget showImage(context) {
    return Positioned(
      top: screenHight * 0.12,
      left: 40,
      right: 40,
      child: Center(
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isProfile = true;
                });
                _bottomSheet(context);
              },
              child: CircleAvatar(
                radius: 93,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2), // Border radius
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(88), // Image radius
                      child: file == null
                          ? const CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  AssetImage('images/addimages1.png'),
                            )
                          : CircleAvatar(
                              radius: 24, backgroundImage: FileImage(file!)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isProfile = true;
                  });
                  _bottomSheet(context);
                },
                child: ClipOval(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                )),
              ),
              right: 10,
              bottom: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget showImageCoverPage(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(
              start: 30.0, end: 30.0, bottom: screenHight * 0.12),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Card(
            color: Colors.red,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: coverPagefile != null
                ? Image.file(
                    coverPagefile!,
                    fit: BoxFit.cover,
                  )
                : Image.asset('images/addimages1.png'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            elevation: 0,
            margin: const EdgeInsets.all(0),
          ),
        ),
        Positioned(
          child: InkWell(
            onTap: () {
              setState(() {
                isProfile = false;
              });
              _bottomSheet(context);
            },
            child: ClipOval(
                child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[300],
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 20,
              ),
            )),
          ),
          right: 50,
          top: screenHight * 0.185,
        ),
      ],
    );
  }

  // //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  // Container showImage(context) {
  //   return Container(
  //     padding:
  //         const EdgeInsetsDirectional.only(start: 10.0, end: 10.0, bottom: 10),
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: MediaQuery.of(context).size.width * 0.6,
  //     child: Container(
  //         child: file == null
  //             ? const CircleAvatar(
  //                 radius: 24,
  //                 backgroundImage: AssetImage('images/addimages1.png'),
  //               )
  //             : CircleAvatar(radius: 24, backgroundImage: FileImage(file!))),
  //   );
  // }

  void _bottomSheet(BuildContext context) {
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
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: DefaultTextStyle(
                            child: Text('เลือกรูปภาพ'),
                            style: TextStyle(
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
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
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
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('ถ่ายภาพ'),
                              style: TextStyle(
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
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
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
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('เลือกที่มีอยู่'),
                              style: TextStyle(
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //ดึงรูปภาพจากมือถือมาใส่ในตัวแปร File
  Future<void> getImage(ImageSource imageSource) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      final result = await _picker.pickImage(source: imageSource);

      if (result == null) return;
      final path = result.path;
      if (isProfile) {
        setState(() => file = File(path));
        if (file != null) {
          final fileName = basename(file!.path);
          setState(() => debugPrint('ชื่อรูปภาพ $fileName'));
        }
      } else {
        setState(() => coverPagefile = File(path));
        if (coverPagefile != null) {
          final fileName = basename(coverPagefile!.path);
          setState(() => debugPrint('ชื่อรูปภาพ $fileName'));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget registerButton(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        width: screenWidth * 0.6,
        child: ElevatedButton.icon(
          onPressed: () {
            name = _name.value.text;
            lastname = _lastname.value.text;
            phone = _phone.value.text;
            email = _email.value.text;
            password = _password.value.text;
            conpassword = _conpassword.value.text;

            if (name.isEmpty) {
              MyStyle().showdialog(context, 'คำเตือน', 'กรุณากรอกชื่อด้วยค่ะ');
              myFocusName.requestFocus();
            } else if (lastname.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกนามสกุลด้วยค่ะ');
              myFocusLastname.requestFocus();
            } else if (phone.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกเบอร์โทรด้วยค่ะ');
              myFocusPhone.requestFocus();
            } else if (gender == null) {
              MyStyle().showdialog(context, 'คำเตือน', 'กรุณาเลือกเพศด้วยค่ะ');
              myFocusPhone.requestFocus();
            } else if (email.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกอีเมลล์ด้วยค่ะ');
              myFocusEmail.requestFocus();
            } else if (password.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกรหัสผ่านด้วยค่ะ');
              myFocusPassword.requestFocus();
            } else if (conpassword.isEmpty) {
              MyStyle().showdialog(
                  context, 'คำเตือน', 'กรุณากรอกยืนยันรหัสผ่านด้วยค่ะ');
              myFocusConpassword.requestFocus();
            } else if (password != conpassword) {
              MyStyle().showdialog(
                  context, 'คำเตือน', 'กรุณากรอกรหัสผ่านให้ตรงกันค่ะ');
              myFocusConpassword.requestFocus();
            } else {
              createUser(context);
              setState(() {
                isLoading = true;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            primary: Colors.red,
          ),
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Create Accound'),
        ),
      );

  //เพิ่มรูปภาพไปยังโฟลเดอร์ที่เก็บรูป พร้อมเปลี่ยนชื่อรูป
  Future<void> createUser(BuildContext context) async {
    String urlImage = '';
    String urlCoverPage = '';
    Random random = Random();
    int i = random.nextInt(1000000);
    String imageName = 'Profile$i.jpg';
    String imageCoverPageName = 'coverPagefile$i.jpg';

    try {
      if (file != null || coverPagefile != null) {
        if (file == null) urlImage = '';
        if (coverPagefile == null) urlCoverPage = '';
        if (file != null) {
          String url = '${MyConstant().domain}/application/saveImageFile.php';
          Map<String, dynamic> map = Map();
          map['file'] = await MultipartFile.fromFile(
            file!.path,
            filename: imageName,
          );
          debugPrint('Respone ==>> ${imageName.toString()}');

          FormData formData = FormData.fromMap(map);
          await Dio().post(url, data: formData).then((value) {
            debugPrint('Respone ==>> $value');
            urlImage = '/application/backend/imageProfile/$imageName';
          });
        }
        if (coverPagefile != null) {
          String url =
              '${MyConstant().domain}/application/saveImagecoverPagefile.php';
          Map<String, dynamic> map = Map();
          map['file'] = await MultipartFile.fromFile(
            coverPagefile!.path,
            filename: imageCoverPageName,
          );
          debugPrint('coverPagefile ==>> ${imageCoverPageName.toString()}');

          FormData formDataCoverPage = FormData.fromMap(map);
          await Dio().post(url, data: formDataCoverPage).then((value) {
            debugPrint('coverPagefile ==>> $value');
            urlCoverPage =
                '/application/backend/imageCoverPage/$imageCoverPageName';
          });
        }
        uploadData(context, urlImage, urlCoverPage);
      } else {
        uploadData(context, urlImage, urlCoverPage);
      }
    } catch (e) {
      debugPrint('อัพโหลดไม่สำเร็จ === ${e.toString()}');
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadData(
    BuildContext context,
    String imageProfile,
    String imageCoverPage,
  ) async {
    debugPrint(
        'imageCoverPage>>>>>>>>>>>>>>>>>>>>>>>> === ${imageCoverPage.toString()}');
    String url = '${MyConstant().domain}/application/registerdata_post.php';
    FormData formData = FormData.fromMap(
      {
        "email": email,
        "password": password,
        "name": name,
        "lastname": lastname,
        "gender": gender,
        "phone": phone,
        "profile": imageProfile,
        "CoverPage": imageCoverPage
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        String success = result['success'];
        String message = result['message'];
        debugPrint('success == $success');
        debugPrint('message == $message');
        debugPrint('Value == $value');
        if (success == '0') {
          setState(() {
            isLoading = false;
          });
          MyStyle().showdialog(
              context, 'คำเตือน', 'มีผู้ใช้บัญชี $email \nอยู่แล้ว');
        } else if (success == '3') {
          setState(() {
            isLoading = false;
          });
          MyStyle().showdialog(
              context, 'คำเตือน', 'มีผู้ใช้งานเบอร์โทรศัพท์ $phone \nอยู่แล้ว');
        } else if (success == '1') {
          registerlDialog(context);
          setState(() {
            isLoading = false;
          });
        } else {
          MyStyle().showdialog(context, 'ล้มเหลว', 'การเชื่อมต่อขัดข้อง');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        isLoading = false;
      });
    }
  }

  void routeToSignIn(BuildContext context, Widget myWidget) {
    _name.clear();
    _lastname.clear();
    _phone.clear();
    _email.clear();
    _password.clear();
    _conpassword.clear();
    gender = null;
    file = null;
    coverPagefile = null;
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => true);
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              //  onChanged: (value) => name = value.trim(),
              focusNode: myFocusName,
              autofocus: true,
              controller: _name,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.supervisor_account_outlined,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'ชื่อ : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget lastnameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              //  onChanged: (value) => lastname = value.trim(),
              controller: _lastname,
              focusNode: myFocusLastname,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.account_circle,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'นามสกุล : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              //  onChanged: (value) => phone = value.trim(),
              controller: _phone,
              focusNode: myFocusPhone,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.phone_iphone,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'เบอร์ : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget radio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'เพศ',
            style: TextStyle(
              fontSize: 22.0,
              // fontWeight: FontWeight.bold,
              color: Colors.black54,
              // fontStyle: FontStyle.italic,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.red,
                      value: 'ชาย',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                          debugPrint('เพศ$gender');
                        });
                      },
                    ),
                    const Text(
                      'ชาย',
                      style: TextStyle(
                        fontSize: 22.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        // fontStyle: FontStyle.italic,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                //  width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.red,
                      value: 'หญิง',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                          debugPrint('เพศ$gender');
                        });
                      },
                    ),
                    const Text(
                      'หญิง',
                      style: TextStyle(
                        fontSize: 22.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        // fontStyle: FontStyle.italic,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              //  onChanged: (value) => user = value.trim(),
              controller: _email,
              focusNode: myFocusEmail,
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
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              obscureText: statusRedEyepassword,
              focusNode: myFocusPassword,
              //   onChanged: (value) => password = value.trim(),
              controller: _password,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: statusRedEyepassword
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
                        statusRedEyepassword = !statusRedEyepassword;
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
                labelText: 'รหัสผ่าน : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget conpasswordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              obscureText: statusRedEyeconpassword,
              //   onChanged: (value) => conpassword = value.trim(),
              controller: _conpassword,
              focusNode: myFocusConpassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: statusRedEyeconpassword
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
                        statusRedEyeconpassword = !statusRedEyeconpassword;
                      });
                    }),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black54,
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'ยืนยันรหัสผ่าน : ',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        buildContent(context),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.transparent,
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Center(
                    child: Text(
                      'กำลังสมัครสมาชิก...',
                      style: TextStyle(
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

  Future<void> registerlDialog(BuildContext context) async {
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
                MyStyle().showTitle_2('Register'),
              ]),
              const Divider(
                color: Colors.black54,
              ),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyStyle().showtext_2('สมัครสมาชิกเรียบร้อย'),
            ],
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/authen');
                routeToSignIn(context, const Login());
              },
            ),
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }
}
