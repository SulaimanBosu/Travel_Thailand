import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/my_style.dart';

class GoogleMapWidget extends StatefulWidget {
  // final double lat, lng;
  final LandmarkModel landmarkModel;
  const GoogleMapWidget({
    Key? key,
    // required this.lat,
    // required this.lng,
    required this.landmarkModel,
  }) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late double screenwidth;
  late double screenhight;
  late double lat2, lng2;
  late CameraPosition position;
  late GoogleMapController _controller;
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        addMarker();
      });
    });
    lat2 = double.parse(widget.landmarkModel.latitude!);
    lng2 = double.parse(widget.landmarkModel.longitude!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: showMap(),
    );
  }

  void addMarker() async {
    _markers.addLabelMarker(LabelMarker(
      // onTap: () => _bottomSheet(),
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
  }

  //   Marker userMarker() {
  //   return Marker(
  //     visible: true,
  //     markerId: const MarkerId('userMarker'),
  //     position: LatLng(
  //       widget.lat,
  //       widget.lng,
  //     ),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //     infoWindow: const InfoWindow(
  //       title: 'ตำแหน่งของคุณ',
  //     ),
  //   );
  // }

  Marker landmarkMarker() {
    return Marker(
      visible: true,
      markerId: const MarkerId('Landmark'),
      position: LatLng(
        lat2,
        lng2,
      ),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: widget.landmarkModel.landmarkName!,
        snippet: widget.landmarkModel.provinceName!,
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>{
      //userMarker(),
      landmarkMarker()
    };
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

  Widget showMap() {
    if (lat2.isFinite) {
      LatLng latLng = LatLng(lat2, lng2);
      position = CameraPosition(
        target: latLng,
        zoom: 6.0,
      );
    }
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 300.0,
      child: lat2.isInfinite
          ? MyStyle().showProgress()
          : Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: GoogleMap(
                  mapType: MapType.normal,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  indoorViewEnabled: true,
                  trafficEnabled: true,
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
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: position,
                  minMaxZoomPreference: const MinMaxZoomPreference(6, 19),
                  onMapCreated: (controller) {
                    _controller = controller;
                  },
                  markers: _markers
                  // mySet(),
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
}
