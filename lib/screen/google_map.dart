import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:location/location.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/login.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/popover.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen(
      {Key? key,
      required this.landmarkModel,
      required this.lat,
      required this.lng,
      required this.userId})
      : super(key: key);
  final LandmarkModel landmarkModel;
  final double lat, lng;
  final String userId;
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late double screenwidth;
  late double screenhight;
  late double lat, lng, lat2, lng2;
  late CameraPosition position;
  late GoogleMapController _controller;
  MapType _defaultMapType = MapType.normal;
  double zoom = 6.0;
  final Set<Marker> _markers = <Marker>{};

  @override
  initState() {
    lat2 = double.parse(widget.landmarkModel.latitude!);
    lng2 = double.parse(widget.landmarkModel.longitude!);
    lat = widget.lat;
    lng = widget.lng;
    addMarker();
    delay();
    // TODO: implement initState
    super.initState();
  }

  void delay() {
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        addMarker();
      });
    });
  }

  void addMarker() async {
    _markers.addLabelMarker(LabelMarker(
      onTap: () => _bottomSheet(),
      //  icon: BitmapDescriptor.fromBytes(byteData),
      visible: true,
      consumeTapEvents: false,
      draggable: false,
      flat: false,
      label: widget.landmarkModel.landmarkName!,
      markerId: const MarkerId("idLandmark"),
      position: LatLng(lat2, lng2),
      backgroundColor: Colors.red,
    ));
    _markers.addLabelMarker(LabelMarker(
      visible: true,
      consumeTapEvents: false,
      draggable: false,
      flat: false,
      label: 'ตำแหน่งของคุณ',
      markerId: const MarkerId("idUser"),
      position: LatLng(lat, lng),
      backgroundColor: Colors.blue.shade900,
    ));
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

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          showMap(),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Material(
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
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            // margin: const EdgeInsets.only(top: 5),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                //margin: const EdgeInsets.only(bottom: 40),
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
                              CameraUpdate.newLatLngZoom(latLng, 16));
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
                        // icon: const Icon(Icons.assistant_direction_outlined),
                        icon: const Icon(Icons.alt_route_outlined),
                        color: Colors.white,
                        onPressed: () {
                          if (widget.userId.isEmpty) {
                            MyAlertDialog().showAlertDialog(
                              Icons.error_outline_outlined,
                              context,
                              'กรุณาเข้าสู่ระบบ',
                              'กรุณาเข้าสู่ระบบก่อนที่จะให้ Appนำทางไปยังแหล่งท่องเที่ยว',
                              'ตกลง',
                              () {
                                Navigator.pop(context);
                                MaterialPageRoute route = MaterialPageRoute(
                                  builder: (context) => const Login(),
                                );
                                Navigator.push(context, route).then((value) {});
                              },
                            );
                          } else {
                            navigaterLog(widget.landmarkModel.landmarkId!,
                                widget.userId);

                            launchMapUrl(widget.landmarkModel.latitude!,
                                widget.landmarkModel.longitude!);
                          }
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

  Marker userMarker() {
    return Marker(
      visible: true,
      markerId: const MarkerId('userMarker'),
      position: LatLng(
        widget.lat,
        widget.lng,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: 'ตำแหน่งของคุณ',
      ),
    );
  }

  Marker landmarkMarker() {
    return Marker(
      visible: true,
      markerId: const MarkerId('Landmark'),
      position: LatLng(
        lat2,
        lng2,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
  }

  Set<Marker> mySet() {
    return <Marker>{userMarker(), landmarkMarker()};
  }

  Set<Polyline> polyline() {
    return <Polyline>{
      Polyline(
        polylineId: const PolylineId('line'),
        visible: true,
        points: <LatLng>[
          LatLng(lat2, lng2),
          // LatLng(widget.lat, widget.lng),
        ],
        width: 5,
        color: Colors.red,
      ),
    };
  }

  Future<void> getLocation() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);

    setState(() {
      lat = locationData.latitude!;
      lng = locationData.longitude!;
    });
    debugPrint('latitude ============ ${lat.toString()}');
    debugPrint('longitude ============ ${lng.toString()}');
  }

  Widget showMap() {
    if (lat2.isFinite) {
      LatLng latLng = LatLng(lat2, lng2);
      position = CameraPosition(
        target: latLng,
        zoom: zoom,
      );
    }
    return Container(
      width: screenwidth,
      height: screenhight,
      child: lat2.isInfinite
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
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
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
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.userId.isEmpty) {
                        MyAlertDialog().showAlertDialog(
                          Icons.error_outline_outlined,
                          context,
                          'กรุณาเข้าสู่ระบบ',
                          'กรุณาเข้าสู่ระบบก่อนที่จะให้ Appนำทางไปยังแหล่งท่องเที่ยว',
                          'ตกลง',
                          () {
                            Navigator.pop(context);
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => const Login(),
                            );
                            Navigator.push(context, route).then((value) {});
                          },
                        );
                      } else {
                        navigaterLog(
                            widget.landmarkModel.landmarkId!, widget.userId);

                        launchMapUrl(widget.landmarkModel.latitude!,
                            widget.landmarkModel.longitude!);
                      }
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
                              child: Text('นำทาง'),
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
                      zoom = zoom + 2;
                      LatLng latLng = LatLng(lat2, lng2);
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
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Padding(
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
                      zoom = zoom - 2;
                      LatLng latLng = LatLng(lat2, lng2);
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
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Padding(
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

  Future<void> navigaterLog(String landmarkID, String userId) async {
    String url = '${MyConstant().domain}/application/navigate_post.php';

    FormData formData = FormData.fromMap(
      {
        "Landmark_id": landmarkID,
        "User_id": userId,
      },
    );
    try {
      await Dio().post(url, data: formData).then((value) {
        var result = json.decode(value.data);
        debugPrint('data == $result');
        String success = result['success'];
        if (success == '1') {
          debugPrint('บันทึกการนำทางเรียบร้อย');
        } else {
          debugPrint('ล้มเหลว');
        }
      });
    } catch (error) {
      debugPrint("ดาวน์โหลดไม่สำเร็จ: $error");
      MyStyle().showdialog(
          context, 'ล้มเหลว', 'ไม่พบการเชื่อมต่อเครือข่ายอินเตอร์เน็ต');
    }
  }

  Future<void> launchMapUrl(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);
    // var appleMapUrl1 = 'https://maps.apple.com/?q=$lat,$lng';
    var appleMapUrl = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/maps/search/',
      queryParameters: {
        'q': '$lat,$lng',
      },
    );
    var googlemapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '$lat,$lng',
      },
    );
    try {
      if (Platform.isAndroid) {
        final bool nativeAppLaunchSucceeded = await launchUrl(
          googlemapsUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (!nativeAppLaunchSucceeded) {
          await launchUrl(
            googlemapsUri,
            mode: LaunchMode.inAppWebView,
          );
        }
      } else {
        bottomSheet(lat2, lng2);
      }
    } catch (error) {
      debugPrint('คุณคลิก นำทาง error = $error');
      throw ("Cannot launch Apple map");
    }
  }

  void bottomSheet(double lat, double lng) {
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
                            child: Text('เลือกแผนที่'),
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
                      var googlemapsUri = Uri(
                        scheme: 'https',
                        host: 'www.google.com',
                        path: '/maps/search/',
                        queryParameters: {
                          'api': '1',
                          'query': '$lat,$lng',
                        },
                      );
                      final bool nativeAppLaunchSucceeded = await launchUrl(
                        googlemapsUri,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                      if (!nativeAppLaunchSucceeded) {
                        await launchUrl(
                          googlemapsUri,
                          mode: LaunchMode.inAppWebView,
                        );
                      }
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
                              child: Text('Google Maps'),
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
                      var appleMapUrl = Uri(
                        scheme: 'https',
                        host: 'maps.apple.com',
                        path: '/maps/search/',
                        queryParameters: {
                          'q': '$lat,$lng',
                        },
                      );
                      final bool nativeAppLaunchSucceeded = await launchUrl(
                        appleMapUrl,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                      if (!nativeAppLaunchSucceeded) {
                        await launchUrl(
                          appleMapUrl,
                          mode: LaunchMode.inAppWebView,
                        );
                      }
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
                              child: Text('Apple Maps'),
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
}
