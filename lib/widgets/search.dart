import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.onClose}) : super(key: key);
  final VoidCallback onClose;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<LandmarkModel> landmarkModels = [];
  LandmarkModel landmarkModel = LandmarkModel();
  TextEditingController textControllor = TextEditingController();

  @override
  void initState() {
    readlandmark();
    super.initState();
  }

  Future<void> readlandmark() async {
    String url = '${MyConstant().domain}/application/get_landmark.php';
    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        debugPrint('Value == $result');
        for (var map in result) {
          landmarkModel = LandmarkModel.fromJson(map);
          landmarkModels.add(landmarkModel);
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: landmarkModels.isEmpty
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: landmarkModels.length,
              itemBuilder: (context, index) {
                // final landmarkItem = landmarkModels[index];
                return ListTile(
                  onTap: () {
                    MyStyle().routeToWidget(
                        context,
                        LandmarkDetail(landmarkModel: landmarkModels[index]),
                        true);
                  },
                  leading: CachedNetworkImage(
                    imageUrl: landmarkModels[index].imagePath!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            MyStyle().showProgress(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(landmarkModels[index].landmarkName!),
                );
              }),
    );
  }

  void searchLandmark(String query) {
    final search = landmarkModels.where((landmark) {
      assert(landmark != null);
      final landmarkName = landmark.landmarkName!.toLowerCase();
      final input = query.toLowerCase();

      return landmarkName.contains(input);
    }).toList();
    setState(() => landmarkModels = search);
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
              child: Container(
                height: 36.0,
                width: double.infinity,
                child: CupertinoTextField(
                  onChanged: ((value) {
                    searchLandmark(value);
                    if (value.isEmpty) setState(() => readlandmark());
                  }),
                  controller: textControllor,
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
                      if (textControllor.text.isEmpty) {
                        widget.onClose();
                      } else {
                        setState(() {
                          textControllor.clear();
                        });
                      }
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
    );
  }
}
