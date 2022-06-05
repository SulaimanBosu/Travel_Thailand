import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/my_style.dart';

class Listview extends StatefulWidget {
  final List<LandmarkModel> landmarkModel;
  final List<String> distances;
  final List<double> times;
  final int index;
  const Listview(
      {Key? key,
      required this.landmarkModel,
      required this.index,
      required this.distances,
      required this.times})
      : super(key: key);

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
                endActionPane: const ActionPane(
                  dragDismissible: true,
                  motion: ScrollMotion(),
                  children: [
                    // SlidableAction(
                    //   flex: 4,
                    //   onPressed: null,
                    //   backgroundColor: Color(0xFF7BC043),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.archive,
                    //   label: 'Archive',
                    // ),
                    SlidableAction(
                      flex: 3,
                      onPressed: null,
                      backgroundColor: Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Save',
                    ),
                    SlidableAction(
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
                  height: screenhight * 0.13,
                  decoration: index % 2 == 0
                      ? BoxDecoration(color: Colors.grey[100])
                      : BoxDecoration(color: Colors.grey[200]),
                  child: Container(
                    padding:
                        const EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('คุณคลิก index = $index');
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.only(
                                start: 0.0, end: 0.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.14,
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
                                  // CircularProgressIndicator(
                                  //     ),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'คะแนน ${widget.landmarkModel[index].landmarkScore.toString()}/5',
                                        //overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.0,
                                          fontFamily: 'FC-Minimal-Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                          fixedSize: const Size(100, 10),
                                          // maximumSize: Size(screenwidth / 3.7,
                                          //     screenhight / 10),
                                        ),
                                        onPressed: () {},
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
                                          fixedSize:  const Size(80, 10),
                                          // maximumSize: Size(screenwidth / 4.5,
                                          //     screenhight / 15),
                                        ),
                                        onPressed: () {},
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
}
