import 'dart:convert';
import 'dart:io';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_api.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/popover.dart';
import 'package:resize/resize.dart';

class LandmarkNear extends StatefulWidget {
  const LandmarkNear({Key? key, required this.lat, required this.lng})
      : super(key: key);
  final double lat, lng;

  @override
  State<LandmarkNear> createState() => _LandmarkNearState();
}

class _LandmarkNearState extends State<LandmarkNear> {
  late LandmarkModel landmarkModel;
  late CameraPosition position;
  late GoogleMapController _controller;
  MapType _defaultMapType = MapType.normal;
  double zoom = 9.0;
  final Set<Marker> _markers = <Marker>{};
  bool isLoading = true;
  double radius = 50;
  final textControllor = TextEditingController();

  @override
  initState() {
    readlandmark();
    super.initState();
    setState(() {
      textControllor.text = radius.toStringAsFixed(0);
    });
  }

  Future<void> readlandmark() async {
    _markers.clear();
    String url = '${MyConstant().domain}/application/getAll_landmark.php';
    try {
      await Dio().get(url).then((value) async {
        var result = json.decode(value.data);
        // debugPrint('Value == $result');
        for (var map in result) {
          landmarkModel = LandmarkModel.fromJson(map);
          double latitude = double.parse(landmarkModel.latitude!);
          double longitude = double.parse(landmarkModel.longitude!);
          double distance = MyApi()
              .calculateDistance(widget.lat, widget.lng, latitude, longitude);

          if (distance <= radius) {
            addMarker(landmarkModel);
            debugPrint('longitude ============ ${distance.toString()}');
            setState(() {
              isLoading = false;
            });
          }
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
    }
  }

  void addMarker(LandmarkModel model) async {
    double latitude = double.parse(model.latitude!);
    double longitude = double.parse(model.longitude!);
    _markers.add(
      Marker(
        markerId: MarkerId(model.landmarkId!),
        icon: await MarkerIcon.downloadResizePictureCircle(model.imagePath!,
            size: 150,
            addBorder: true,
            borderColor: Colors.red,
            borderSize: 15),
        infoWindow: InfoWindow(
          onTap: (() {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => LandmarkDetail(
                landmarkModel: model,
              ),
            );
            Navigator.push(context, route).then((value) {});
          }),
          title: '${model.landmarkName}',
        ),
        position: LatLng(latitude, longitude),
      ),
    );
    setState(() {});
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : _defaultMapType == MapType.satellite
              ? MapType.hybrid
              : MapType.normal;
    });
  }

  Future<Object?> topsheet() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Item 1'),
                      onTap: () => Navigator.of(context).pop('item1'),
                    ),
                    ListTile(
                      title: const Text('Item 2'),
                      onTap: () => Navigator.of(context).pop('item2'),
                    ),
                    ListTile(
                      title: const Text('Item 3'),
                      onTap: () => Navigator.of(context).pop('item3'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 4,
      progressIndicator: Material(
        type: MaterialType.transparency,
        child: JumpingDotsProgressIndicator(
          color: Colors.red,
          fontSize: 50.0.sp,
        ),
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black,
      child: Stack(
        children: [
          showMap(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent,
            ),
            margin: EdgeInsets.only(top: 5.vh, left: 12.vw, right: 12.vw),
            width: 100.vw,
            height: 5.vh,
            child: Card(
              margin: EdgeInsets.only(left: 5.vw, right: 5.vw),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: CupertinoTextField(
                readOnly: false,
                padding: EdgeInsets.only(left: 2.vw, right: 2.vw),
                textAlign: TextAlign.end,
                // toolbarOptions: const ToolbarOptions(
                //     copy: true, cut: true, paste: true, selectAll: true),
                // onChanged: ((value) {
                //   setState(() {
                //     radius = double.parse(value);
                //   });
                // }),
                onSubmitted: (value) {
                  setState(() {
                    double valueSubmit = double.parse(value);
                    if (valueSubmit >= 5 && valueSubmit <= 1200) {
                      radius = valueSubmit;
                      textControllor.text = radius.toStringAsFixed(0);
                      zoom = 6;
                      isLoading = true;
                      readlandmark();
                    } else {
                      MyStyle().showBasicsFlash(
                        context: context,
                        text: 'ปรับรัศมีมากหรือน้อยเกินไป',
                        duration: const Duration(seconds: 3),
                        flashStyle: FlashBehavior.floating,
                      );
                    }
                  });
                },
                controller: textControllor,
                autofocus: false,
                keyboardType: TextInputType.number,

                placeholderStyle: const TextStyle(
                  color: Color(0xffC4C6CC),
                  fontSize: 14.0,
                  fontFamily: 'Brutal',
                ),
                prefix: Padding(
                    padding: EdgeInsets.only(left: 5.vw),
                    child: Row(
                      children: [
                        Text(
                          'รัศมีในการค้นหา',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                        SizedBox(
                          width: 2.vw,
                        ),
                        InkWell(
                          onTap: () async {
                            if (radius >= 10) {
                              isLoading = true;
                              radius -= 10;
                              textControllor.text = radius.toStringAsFixed(0);
                              var zoom = await _controller.getZoomLevel();
                              zoom = zoom + 0.5;
                              LatLng latLng = LatLng(widget.lat, widget.lng);
                              _controller.animateCamera(
                                  CameraUpdate.newLatLngZoom(latLng, zoom));
                              readlandmark();
                            } else {
                              MyStyle().showBasicsFlash(
                                context: context,
                                text: 'ปรับรัศมีต่ำสุดแล้ว',
                                duration: const Duration(seconds: 3),
                                flashStyle: FlashBehavior.floating,
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )),
                suffix: Row(
                  children: [
                    Text(
                      'กม.',
                      style: TextStyle(fontSize: 11.sp),
                    ),
                    SizedBox(
                      width: 1.vw,
                    ),
                    InkWell(
                      onTap: () async {
                        if (radius <= 1200) {
                          radius += 10;
                          isLoading = true;
                          textControllor.text = radius.toStringAsFixed(0);
                          var zoom = await _controller.getZoomLevel();
                          zoom = zoom - 0.5;
                          LatLng latLng = LatLng(widget.lat, widget.lng);
                          _controller.animateCamera(
                              CameraUpdate.newLatLngZoom(latLng, zoom));
                          readlandmark();
                        } else {
                          MyStyle().showBasicsFlash(
                            context: context,
                            text: 'ปรับรัศมีสูงสุดแล้ว',
                            duration: const Duration(seconds: 3),
                            flashStyle: FlashBehavior.floating,
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 2.5.vw),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color(0xffF0F1F5),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Material(
              color: const Color.fromRGBO(0, 0, 0, 0),
              child: Padding(
                padding: EdgeInsets.only(right: 10, top: 15.vh),
                child: Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.layers_rounded),
                    color: Colors.red,
                    onPressed: () {
                      _changeMapType();
                    },
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomRight,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      margin: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.navigation_outlined),
                        color: Colors.red,
                        onPressed: () async {
                          // var zoom = await _controller.getZoomLevel();
                          LatLng latLng = LatLng(widget.lat, widget.lng);
                          _controller.animateCamera(
                              CameraUpdate.newLatLngZoom(latLng, 14));
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: Platform.isAndroid ? 120 : 20),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.alt_route_outlined),
                        color: Colors.white,
                        onPressed: () {
                          // if (widget.userId.isEmpty) {
                          //   MyAlertDialog().showAlertDialog(
                          //     context,
                          //     'กรุณาเข้าสู่ระบบก่อนที่จะให้ Appนำทางไปยังแหล่งท่องเที่ยว',
                          //     'ตกลง',
                          //     'ยกเลิก',
                          //     () {
                          //       Navigator.pop(context);
                          //       MaterialPageRoute route = MaterialPageRoute(
                          //         builder: (context) => const Login(),
                          //       );
                          //       Navigator.push(context, route).then((value) {});
                          //     },
                          //   );
                          // } else {
                          //   navigaterLog(widget.landmarkModel.landmarkId!,
                          //       widget.userId);

                          //   launchMapUrl(widget.landmarkModel.latitude!,
                          //       widget.landmarkModel.longitude!);
                          // }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(bottom: 20),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    color: Colors.white,
                    onPressed: () {
                      _bottomSheet();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showMap() {
    if (widget.lat.isFinite) {
      LatLng latLng = LatLng(widget.lat, widget.lng);
      position = CameraPosition(
        target: latLng,
        zoom: zoom,
      );
    }
    return Container(
      width: 100.vw,
      height: 100.vh,
      child: widget.lat.isInfinite
          ? MyStyle().showProgress()
          : Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: GoogleMap(
                  mapType: _defaultMapType,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  indoorViewEnabled: true,
                  trafficEnabled: false,
                  buildingsEnabled: true,
                  //    circles:  <Circle>{ Circle(
                  // circleId: const CircleId('circle'),
                  // center: LatLng(lat2, lng2),
                  // radius: 10,fillColor: Colors.red)},
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  // liteModeEnabled: false,
                  tiltGesturesEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  initialCameraPosition: position,
                  minMaxZoomPreference: const MinMaxZoomPreference(6, 19),
                  onMapCreated: (controller) {
                    _controller = controller;
                  },
                  markers: _markers
                  //mySet(),
                  //polylines: polyline(),
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(5.0),
            ),
    );
  }

  void _bottomSheet() {
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
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: DefaultTextStyle(
                            child: Text('Map'),
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
                    onTap: () async {
                      Navigator.pop(context);
                      var zoom = await _controller.getZoomLevel();
                      zoom = zoom + 0.5;
                      LatLng latLng = LatLng(widget.lat, widget.lng);
                      _controller.animateCamera(
                          CameraUpdate.newLatLngZoom(latLng, zoom));
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
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('ซูมเข้า'),
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
                    onTap: () async {
                      Navigator.pop(context);
                      var zoom = await _controller.getZoomLevel();
                      zoom = zoom - 0.5;
                      LatLng latLng = LatLng(widget.lat, widget.lng);
                      _controller.animateCamera(
                          CameraUpdate.newLatLngZoom(latLng, zoom));
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
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              child: Text('ซูมออก'),
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
                        children: const [
                          Padding(
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
}
