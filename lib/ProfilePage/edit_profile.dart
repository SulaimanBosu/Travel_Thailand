import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/home_screen.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  late UserModel userModel;

  late double screenWidth;
  late double screenHight;
  String? userid,
      name,
      lastname,
      phone,
      email,
      password,
      oldpassword,
      newpassword,
      conpassword,
      profile;
  bool statusRedEyepassword = true;
  bool statusRedEyenewpassword = true;
  bool statusRedEyeconpassword = true;
  File? file;
  var gender;
  late SharedPreferences preferences;
  bool onData = false;
  bool onUpdate = true;
  late String urlImage;

  @override
  void initState() {
    // debugPrint('userid ============ ${userid.toString()}');
    // debugPrint('_name ============ ${name.toString()}');
    // debugPrint('_lastname ============ ${lastname.toString()}');
    // debugPrint('_phone ============ ${phone.toString()}');
    // debugPrint('_email ============ ${email.toString()}');
    // debugPrint('_password ============ ${oldpassword.toString()}');
    // debugPrint('gender ============ ${gender.toString()}');
    // debugPrint('profile ============ ${profile.toString()}');
    getPreferences();
    super.initState();
  }

  Future<void> setPreferences(String image, String pass) async {
    preferences.setString('User_id', userid!);
    preferences.setString('Email', email!);
    preferences.setString('Password', pass);
    preferences.setString('first_name', name!);
    preferences.setString('last_name', lastname!);
    preferences.setString('Gender', gender);
    preferences.setString('Phone', phone!);
    preferences.setString('Image_profile', image);

    userModel.userId = userid;
    userModel.email = email;
    userModel.name = name;
    userModel.lastname = lastname;
    userModel.gender = gender;
    userModel.phone = phone;
    userModel.file = profile;
  }

  Future<void> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id')!;
    name = preferences.getString('first_name')!;
    lastname = preferences.getString('last_name')!;
    profile = preferences.getString('Image_profile')!;
    phone = preferences.getString('Phone')!;
    gender = preferences.getString('Gender')!;
    email = preferences.getString('Email')!;
    oldpassword = preferences.getString('Password')!;
    if (userid!.isNotEmpty) {
      setState(() {
        onData = true;
      });
    } else {
      setState(() {
        onData = false;
      });
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Account',
          style: TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: !onUpdate
          ? progress(context)
          : !onData
              ? MyStyle().progress(context)
              : buildContent(context),
    );
  }

  SafeArea buildContent(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : profile!;
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
                        InkWell(
                          onTap: () => _bottomSheet(context),
                          child: Stack(
                            children: [
                              showImage(context),
                              Positioned(
                                child: ClipOval(
                                    child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.mode_edit_sharp,
                                    color: Color.fromARGB(255, 242, 55, 55),
                                    size: 20,
                                  ),
                                )),
                                right: 12,
                                top: 50,
                              ),
                            ],
                          ),
                        ),
                        // OutlinedButton(
                        //   style: OutlinedButton.styleFrom(
                        //     fixedSize: const Size(170, 35),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     _bottomSheet(context);
                        //     // _showPicker(context);
                        //   },
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     // ignore: prefer_const_literals_to_create_immutables
                        //     children: [
                        //       const Icon(
                        //         Icons.add_a_photo_outlined,
                        //         color: Colors.black54,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       const Text(
                        //         'เปลี่ยนรูปโปรไฟล์',
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           color: Colors.black54,
                        //           fontFamily: 'FC-Minimal-Regular',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // // SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       fileName,
                        //       overflow: TextOverflow.ellipsis,
                        //       style: const TextStyle(
                        //         //fontWeight: FontWeight.bold,
                        //         fontSize: 16.0,
                        //         color: Colors.black54,
                        //         fontFamily: 'FC-Minimal-Regular',
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                        newpasswordForm(),
                        MyStyle().mySizebox(),
                        conpasswordForm(),
                        MyStyle().mySizebox(),
                        editButton(context),
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

  //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  Container showImage(context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 90,
        backgroundColor: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(2), // Border radius
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(88), // Image radius
              child: file != null
                  ? CircleAvatar(radius: 88, backgroundImage: FileImage(file!))
                  : profile == ''
                      ? Image.asset('images/iconprofile.png')
                      : CachedNetworkImage(
                          imageUrl: MyConstant().domain + profile!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          errorWidget: (context, url, error) =>
                              Image.asset('images/iconprofile.png'),
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
      ),
    );
  }

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
                children: [
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

      setState(() => file = File(path));
      if (file != null) {
        final fileName = basename(file!.path);
        debugPrint('ชื่อรูปภาพ $fileName');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget editButton(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        width: screenWidth * 0.6,
        child: ElevatedButton.icon(
          onPressed: () {
            if (name == null || name!.isEmpty) {
              MyStyle().showdialog(context, 'คำเตือน', 'กรุณากรอกชื่อด้วยค่ะ');
            } else if (lastname == null || lastname!.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกนามสกุลด้วยค่ะ');
            } else if (phone == null || phone!.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกเบอร์โทรด้วยค่ะ');
            } else if (gender == null) {
              MyStyle().showdialog(context, 'คำเตือน', 'กรุณาเลือกเพศด้วยค่ะ');
            } else if (email == null || email!.isEmpty) {
              MyStyle()
                  .showdialog(context, 'คำเตือน', 'กรุณากรอกอีเมลล์ด้วยค่ะ');
            } else if (password == null || password!.isEmpty) {
              updateUser(context, oldpassword!);
              setState(() {
                onUpdate = false;
              });
            } else {
              if (newpassword == null || newpassword!.isEmpty) {
                MyStyle().showdialog(
                    context, 'คำเตือน', 'กรุณากรอกรหัสผ่านใหม่ด้วยค่ะ');
              } else if (conpassword == null || conpassword!.isEmpty) {
                MyStyle().showdialog(
                    context, 'คำเตือน', 'กรุณากรอกยืนยันรหัสผ่านด้วยค่ะ');
              } else if (password != oldpassword) {
                MyStyle().showdialog(
                    context, 'คำเตือน', 'คุณใส่รหัสผ่านเก่าไม่ถูกต้อง');
              } else if (newpassword == oldpassword) {
                MyStyle().showdialog(
                    context, 'คำเตือน', 'คุณใส่รหัสผ่านซ้ำกับรหัสผ่านเดิม');
              } else if (newpassword != conpassword) {
                MyStyle().showdialog(
                    context, 'คำเตือน', 'กรุณากรอกรหัสผ่านใหม่ให้ตรงกันค่ะ');
              } else {
                updateUser(context, newpassword!);
                setState(() {
                  onUpdate = false;
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Update Accound'),
        ),
      );

  //เพิ่มรูปภาพไปยังโฟลเดอร์ที่เก็บรูป พร้อมเปลี่ยนชื่อรูป
  Future<void> updateUser(BuildContext context, String _password) async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String imageName = 'Profile$i.jpg';
    String url = '${MyConstant().domain}/application/saveImageFile.php';
    try {
      if (file != null) {
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
          uploadData(context, urlImage, _password);
        });
      } else {
        uploadData(context, profile!, _password);
      }
    } catch (e) {
      debugPrint('อัพโหลดไม่สำเร็จ === ${e.toString()}');
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        onUpdate = true;
      });
    }
  }

  Future<void> uploadData(
      BuildContext context, String imageProfile, String _password) async {
    String url = '${MyConstant().domain}/application/get_profile.php';
    FormData formData = FormData.fromMap(
      {
        "id": 0,
        "userid": userid,
        "email": email,
        "password": _password,
        "name": name,
        "lastname": lastname,
        "gender": gender,
        "phone": phone,
        "profile": imageProfile,
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
        if (success == '1') {
          setState(() {
            onUpdate = true;
          });
          setPreferences(imageProfile, _password);
          editlDialog(context);
        } else {
          MyStyle().showdialog(context, 'ล้มเหลว', 'การเชื่อมต่อขัดข้อง');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
      setState(() {
        onUpdate = true;
      });
    }
  }

  void routeToSignIn(BuildContext context, Widget myWidget) {
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
            child: TextFormField(
              initialValue: name,
              onChanged: (value) => name = value.trim(),
              // controller: _name,
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
                // hintText: name,
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
            child: TextFormField(
              initialValue: lastname,
              onChanged: (value) => lastname = value.trim(),
              // controller: _lastname,
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
            child: TextFormField(
              initialValue: phone,
              onChanged: (value) => phone = value.trim(),
              //  controller: _phone,
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
            child: TextFormField(
              initialValue: email,
              onChanged: (value) => email = value.trim(),
              // controller: _email,
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
              //initialValue: password,
              onChanged: (value) => password = value.trim(),
              // controller: _password,
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
                labelText: 'รหัสผ่านเดิม : ',
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

  Widget newpasswordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextField(
              obscureText: statusRedEyenewpassword,
              //initialValue: password,
              onChanged: (value) => newpassword = value.trim(),
              // controller: _newpassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: statusRedEyenewpassword
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
                        statusRedEyenewpassword = !statusRedEyenewpassword;
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
                labelText: 'รหัสผ่านใหม่ : ',
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
              onChanged: (value) => conpassword = value.trim(),
              // controller: _conpassword,
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
                labelText: 'ยืนยันรหัสผ่านใหม่ : ',
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
          color: Colors.transparent,
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Center(
                    child: Text(
                      'กำลังอัพเดต...',
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

  Future<void> editlDialog(BuildContext context) async {
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
                MyStyle().showTitle_2('Edit Profile'),
              ]),
              const Divider(
                color: Colors.black54,
              ),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyStyle().showtext_2('แก้ไขโปรไฟล์เรียบร้อย'),
            ],
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/authen');
                routeToSignIn(
                    context,
                    const HomeScreen(
                      index: 4,
                    ));
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
