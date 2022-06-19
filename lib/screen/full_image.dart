import 'dart:convert';
import 'dart:math';

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
  late TransformationController _transformationController;
  // late AnimationController _animationController;
  // Animation<Matrix4>? _animation;
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
    _transformationController = TransformationController();
    // _animationController = AnimationController(
    //   vsync: this,
    // //  duration: Duration(milliseconds: 200),
    // )..addListener(() => _animationController.value);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
    ]);
    _transformationController.dispose();
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
            ? const Center(
                child: CupertinoActivityIndicator(
                  radius: 20.0,
                  color: Colors.white,
                ),
              )
            : Builder(
                builder: (context) {
                  final double height = MediaQuery.of(context).size.height;
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
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
                              (item) => InteractiveViewer(
                                //  scaleEnabled: true,
                                transformationController:
                                    _transformationController,
                                onInteractionEnd: (endDetails) {
                                  // resetAnimation();
                                },
                                clipBehavior: Clip.none,
                                minScale: minScele,
                                maxScale: maxScele,
                                panEnabled: false,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
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
                              ),
                            )
                            .toList(),
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

  // void resetAnimation() {
  //   _animation = Matrix4Tween(
  //     begin: _transformationController.value,
  //     end: Matrix4.identity(),
  //   ).animate(CurvedAnimation(
  //     parent: _animationController,
  //     curve: Curves.easeInOut,
  //   ));
  //   _animationController.forward(from: 0);
  // }
}
