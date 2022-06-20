// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/my_style.dart';
import 'package:url_launcher/url_launcher.dart';

class Listview extends StatefulWidget {
  final List<LandmarkModel> landmarkModel;
  final List<String> distances;
  final List<double> times;
  final int index;
  final double lat1, lng1;

  const Listview({
    Key? key,
    required this.landmarkModel,
    required this.index,
    required this.distances,
    required this.times,
    required this.lat1,
    required this.lng1,
  }) : super(key: key);

  @override
  State<Listview> createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
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
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              child: Slidable(
                key: Key(widget.landmarkModel[index].landmarkId!),
                // startActionPane: ActionPane(
                //   motion: const ScrollMotion(),
                //   dismissible: DismissiblePane(onDismissed: () {}),
                //   children: const [
                //     SlidableAction(
                //       onPressed: null,
                //       backgroundColor: Color(0xFFFE4A49),
                //       foregroundColor: Colors.white,
                //       icon: Icons.delete,
                //       label: 'Delete',
                //     ),
                //     SlidableAction(
                //       onPressed: null,
                //       backgroundColor: Color(0xFF21B7CA),
                //       foregroundColor: Colors.white,
                //       icon: Icons.share,
                //       label: 'Share',
                //     ),
                //   ],
                // ),
                endActionPane: ActionPane(
                  dragDismissible: true,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      autoClose: true,
                      flex: 3,
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandmarkDetail(
                              landmarkModel: widget.landmarkModel[index],
                              // lat: widget.lat1,
                              // lng: widget.lng1,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'เปิด',
                    ),
                    const SlidableAction(
                      autoClose: true,
                      flex: 3,
                      onPressed: null,
                      backgroundColor: Color.fromARGB(255, 224, 2, 2),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'share',
                    ),
                  ],
                ),
                child: Container(
                  width: screenwidth,
                  height: screenhight * 0.16,
                  decoration: index % 2 == 0
                      ? const BoxDecoration(color: Colors.white)
                      : BoxDecoration(color: Colors.grey[50]),
                  child: Container(
                    padding:
                        const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('คุณคลิก index = $index');
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => LandmarkDetail(
                            landmarkModel: widget.landmarkModel[index],
                            // lat: widget.lat1,
                            // lng: widget.lng1,
                          ),
                        );
                        Navigator.push(context, route).then((value) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                          ]);
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.only(
                                start: 0.0, end: 0.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Container(
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${widget.landmarkModel[index].imagePath}',
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
                                margin: const EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Container(
                            //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                            //   padding: EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width * 0.488,
                            height: MediaQuery.of(context).size.width * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget
                                            .landmarkModel[index].landmarkName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: MyStyle().mainTitle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'จังหวัด ${widget.landmarkModel[index].provinceName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: MyStyle().mainH2Title,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                1
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                2
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                3
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! >=
                                                4
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: widget.landmarkModel[index]
                                                    .landmarkScore! ==
                                                5
                                            ? Colors.orange
                                            : Colors.grey),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Expanded(
                                //       child: Text(
                                //         'คะแนน ${widget.landmarkModel[index].landmarkScore.toString()}/5',
                                //         //overflow: TextOverflow.ellipsis,
                                //         style: const TextStyle(
                                //           color: Colors.red,
                                //           fontSize: 12.0,
                                //           fontFamily: 'FC-Minimal-Regular',
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${widget.distances[index]} Km. | (${widget.times[index].toStringAsFixed(2)}hr.)',
                                        //overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 10.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'View ${widget.landmarkModel[index].landmarkView}',
                                        //overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black54,
                                ),
                                // const Expanded(
                                //   child: Divider(
                                //     color: Colors.black54,
                                //   ),
                                // ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          //  fixedSize: const Size(100, 10),
                                          maximumSize: Size(screenwidth / 3.7,
                                              screenhight / 10),
                                        ),
                                        onPressed: () {
                                          debugPrint(
                                              'คุณคลิก รายระเอียด = $index');
                                          MaterialPageRoute route =
                                              MaterialPageRoute(
                                            builder: (context) =>
                                                LandmarkDetail(
                                              landmarkModel:
                                                  widget.landmarkModel[index],
                                              // lat: widget.lat1,
                                              // lng: widget.lng1,
                                            ),
                                          );
                                          Navigator.push(context, route)
                                              .then((value) {
                                            SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.portraitUp,
                                            ]);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                        label: const Text(
                                          'รายระเอียด',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0,
                                            fontFamily: 'FC-Minimal-Regular',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          fixedSize: const Size(80, 10),
                                          // maximumSize: Size(screenwidth / 4.5,
                                          //     screenhight / 15),
                                          maximumSize: Size(screenwidth / 3.7,
                                              screenhight / 10),
                                        ),
                                        onPressed: () {
                                          debugPrint('คุณคลิก นำทาง = $index');
                                          launchMapUrl(
                                              widget.landmarkModel[index]
                                                  .latitude!,
                                              widget.landmarkModel[index]
                                                  .longitude!);
                                        },
                                        icon: const Icon(
                                          Icons.navigation_outlined,
                                          size: 15,
                                        ),
                                        label: const Text(
                                          'นำทาง',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.0,
                                            fontFamily: 'FC-Minimal-Regular',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.black45,
                                //size: 15,
                              ),
                              // ignore: unnecessary_statements
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: widget.landmarkModel.length,
        ),
      ),
    );
  }

  Future<void> launchMapUrl(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);
      var httpsUri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/search/',
        queryParameters: {
          'api': '1',
          'query': '$lat,$lng',
        },
      );
      try {
        final bool nativeAppLaunchSucceeded = await launchUrl(
          httpsUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (!nativeAppLaunchSucceeded) {
          await launchUrl(
            httpsUri,
            mode: LaunchMode.inAppWebView,
          );
        }
      } catch (error) { 
        debugPrint('คุณคลิก นำทาง error = $error');
        throw ("Cannot launch Apple map");
      }
    }
}
