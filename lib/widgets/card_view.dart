//CardViewเดิม
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/my_style.dart';
import 'package:resize/resize.dart';

class CardView extends StatefulWidget {
  final LandmarkModel landmarkModel;
  final VoidCallback readlandmark;
  final VoidCallback getPreferences;
  final int index;
  // final double lat, lng;
  const CardView({
    Key? key,
    required this.landmarkModel,
    required this.index,
    required this.readlandmark,
    required this.getPreferences,
    // required this.lat,
    // required this.lng,
  }) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late double screenwidth;
  late double screenhight;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageURL = widget.landmarkModel.imagePath!;
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: GestureDetector(
        onTap: () {
          debugPrint('you click index ${widget.index}');
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => LandmarkDetail(
              landmarkModel: widget.landmarkModel,
              // lat: widget.lat,
              // lng: widget.lng,
            ),
          );
          Navigator.push(context, route).then((value) {
            widget.readlandmark();
            widget.getPreferences();
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          });
        },
        // ignore: avoid_unnecessary_containers
        child: Card(
           margin: const EdgeInsets.only(bottom: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            
          ),
          //  elevation: 5,
          //  color: Colors.grey[300],
          child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              showImage(context, imageURL),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 2.5 .vh,),
                    Text(
                      widget.landmarkModel.landmarkName!,
                      style:  TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0 .sp,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.start,
                    ),

                    Text(
                      'จังหวัด ${widget.landmarkModel.provinceName}',
                      style:  TextStyle(
                        color: Colors.black45,
                        fontSize: 12.0 .sp,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star,
                                size: 15,
                                color: widget.landmarkModel.landmarkScore! >= 1
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                size: 15,
                                color: widget.landmarkModel.landmarkScore! >= 2
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                size: 15,
                                color: widget.landmarkModel.landmarkScore! >= 3
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                size: 15,
                                color: widget.landmarkModel.landmarkScore! >= 4
                                    ? Colors.orange
                                    : Colors.grey),
                            Icon(Icons.star,
                                size: 15,
                                color: widget.landmarkModel.landmarkScore! == 5
                                    ? Colors.orange
                                    : Colors.grey),
                          ],
                        ),
                        // Text(
                        //   'คะแนน ${widget.landmarkModel.landmarkScore}/5',
                        //   style: const TextStyle(
                        //     color: Colors.red,
                        //     fontSize: 12.0,
                        //     fontFamily: 'FC-Minimal-Regular',
                        //   ),
                        // ),
                        Text(
                          'View ${widget.landmarkModel.landmarkView}',
                          style:  TextStyle(
                            color: Colors.black45,
                            fontSize: 10.0 .sp,
                            fontFamily: 'FC-Minimal-Regular',
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: screenhight * 0.01,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showImage(BuildContext context, String imageURL) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CachedNetworkImage(
        width: 100 .vw,
        height: 15.vh,
        // height: Platform.isIOS ? screenhight * 0.14 : screenhight * 0.14,
        imageUrl: imageURL,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            MyStyle().showProgress(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(0),
    );
  }
}
