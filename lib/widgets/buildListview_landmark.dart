import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/my_style.dart';
import 'package:resize/resize.dart';

class BuildListviewLandmark extends StatelessWidget {
  const BuildListviewLandmark({
    Key? key,
    required this.screenwidth,
    required this.listLandmark,
    required this.index,
  }) : super(key: key);

  final double screenwidth;
  final List<LandmarkModel> listLandmark;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        width: screenwidth,
        height: 22.vh,
        child: ListView.builder(
          itemCount: listLandmark.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 40.vw,
              //  height: 10 .vh,
              margin: EdgeInsets.only(left: 1.5.vw, right: 1.5.vw),
              child: GestureDetector(
                onTap: () {
                  debugPrint('you click index $index');
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => LandmarkDetail(
                      landmarkModel: listLandmark[index],
                    ),
                  );
                  Navigator.push(context, route).then((value) {
                    // readlandmark();
                    // widget.getPreferences();
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  });
                },

                // ignore: avoid_unnecessary_containers
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide.none),
                 // margin: const EdgeInsets.only(bottom: 5.0),

                  //  elevation: 5,
                  //  color: Colors.grey[300],
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          width: screenwidth,
                          height:22.vw,
                          imageUrl: listLandmark[index].imagePath!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyStyle().mySizebox(),
                            Text(
                              listLandmark[index].landmarkName!,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0.sp,
                                fontFamily: 'FC-Minimal-Regular',
                              ),
                              textAlign: TextAlign.start,
                            ),

                            Text(
                              'จังหวัด ${listLandmark[index].provinceName}',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12.0.sp,
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
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                1
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                2
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                3
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! >=
                                                4
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: listLandmark[index]
                                                    .landmarkScore! ==
                                                5
                                            ? Colors.orange
                                            : Colors.grey),
                                  ],
                                ),
                                Text(
                                  'View ${listLandmark[index].landmarkView}',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 10.0.sp,
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
          },
        ),
      ),
    );
  }
}
