import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/screen/landmark_detail.dart';
import 'package:project/utility/my_style.dart';

class TestListview extends StatefulWidget {
  final List<LandmarkModel> landmarkModel;
  final List<String> distances;
  final List<double> times;
  final int index;
  const TestListview({
    Key? key,
    required this.landmarkModel,
    required this.distances,
    required this.times,
    required this.index,
  }) : super(key: key);

  @override
  State<TestListview> createState() => _TestListviewState();
}

class _TestListviewState extends State<TestListview> {
  late double screenwidth;
  late double screenhight;
  late List landmarkModel;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    
    landmarkModel = List.generate(10, (index) => widget.landmarkModel[index]);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    super.initState();
  }

  getMoreData() {
    debugPrint('getMoreData');
    for (int i = _currentMax; i < _currentMax + 10; i++) {
        setState(() {
          landmarkModel.add(widget.landmarkModel[i]);
          _currentMax = _currentMax + 10;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Container(
      child: ListView.builder(
          controller: _scrollController,
          //itemExtent: screenhight * 0.2,
          itemCount:
           widget.index == landmarkModel.length ? landmarkModel.length :  landmarkModel.length + 1,
          itemBuilder: (context, index) {
            if (index == landmarkModel.length) {
              return const CupertinoActivityIndicator(
                radius: 15,
              );
            }
            return Container(
              child: Slidable(
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
                              landmarkModel: landmarkModel[index],
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
                            landmarkModel: landmarkModel[index],
                          ),
                        );
                        Navigator.push(context, route);
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
                                  imageUrl: '${landmarkModel[index].imagePath}',
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
                                        landmarkModel[index].landmarkName!,
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
                                        'จังหวัด ${landmarkModel[index].provinceName}',
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
                                        color: landmarkModel[index]
                                                    .landmarkScore! >=
                                                1
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: landmarkModel[index]
                                                    .landmarkScore! >=
                                                2
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: landmarkModel[index]
                                                    .landmarkScore! >=
                                                3
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: landmarkModel[index]
                                                    .landmarkScore! >=
                                                4
                                            ? Colors.orange
                                            : Colors.grey),
                                    Icon(Icons.star,
                                        size: 15,
                                        color: landmarkModel[index]
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
                                        'View ${landmarkModel[index].landmarkView}',
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
                                                  landmarkModel[index],
                                            ),
                                          );
                                          Navigator.push(context, route);
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

            //  ListTile(
            //   title: Text('${landmarkModel[index]}'),
            // );
          }),
    );
  }
}
