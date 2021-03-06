import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/model/image_model.dart';
import 'package:project/utility/myConstant.dart';

class FullImage extends StatefulWidget {
  const FullImage({
    Key? key,
    required this.landmarkId,
  }) : super(key: key);
  final String landmarkId;

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isLoading = true;
  double minScele = 1.0;
  double maxScele = 4.0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    getImage();
    // _animationController = AnimationController(
    //   vsync: this,
    // //  duration: Duration(milliseconds: 200),
    // )..addListener(() => _animationController.value);
    super.initState();
  }

  @override
  void dispose() {
    // Platform.isIOS
    //     ? SystemChrome.setPreferredOrientations([
    //         DeviceOrientation.portraitDown,
    //       ]).then((value) => debugPrint('setPreferredOrientations'))
    //     : null;
    //  _animationController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    String urlgetImage = '${MyConstant().domain}/application/get_image.php';
    FormData getImage = FormData.fromMap(
      {
        "Landmark_id": widget.landmarkId,
      },
    );
    try {
      await Dio().post(urlgetImage, data: getImage).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');

        for (var map in result) {
          ImageModel imageModel = ImageModel.fromJson(map);
          setState(
            () {
              imgList.add(imageModel.imagePath!);
              isLoading = false;
            },
          );
        }
      });
    } catch (error) {
      debugPrint("??????????????????????????????????????????????????????: $error");
      showdialog(context, '?????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
      setState(
        () {
          isLoading = false;
        },
      );
    }
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
                delay();
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

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      minScale: minScele,
      maxScale: maxScele,
      panEnabled: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: const CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                  color: Colors.white,
                ),
              )
            : Builder(
                builder: (context) {
                  final double height = MediaQuery.of(context).size.height;
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      InteractiveViewer(
                        clipBehavior: Clip.none,
                        minScale: minScele,
                        maxScale: maxScele,
                        panEnabled: false,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              //pageSnapping: true,
                              height: height,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft,
                                  ]);
                                  _current = index;
                                });
                              }
                              // autoPlay: false,
                              ),
                          items: imgList
                              .map(
                                (item) => Center(
                                  child: InteractiveViewer(
                                    clipBehavior: Clip.none,
                                    minScale: minScele,
                                    maxScale: maxScele,
                                    panEnabled: false,
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              const Center(
                                        child: CupertinoActivityIndicator(
                                          animating: true,
                                          color: Colors.white,
                                          radius: 15,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                      fit: BoxFit.cover,
                                      // height: height,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Positioned(
                        bottom: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 6.0,
                                height: 6.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 1.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(
                                            _current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Positioned(
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                            ]);
                            imgList.clear();
                            Navigator.pop(context);
                          },
                        ),
                        top: 30,
                        right: 20,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void delay() {
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        Navigator.of(context).pop();
      });
    });
  }
}
