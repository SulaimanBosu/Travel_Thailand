import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/comment_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';

class CommentListview extends StatefulWidget {
  final List<CommentModel> commentModels;
  final int index;
  final bool moreComment;
  const CommentListview({
    Key? key,
    required this.commentModels,
    required this.index,
    required this.moreComment,
  }) : super(key: key);

  @override
  State<CommentListview> createState() => _CommentListviewState();
}

class _CommentListviewState extends State<CommentListview> {
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
                key: Key(widget.commentModels[index].userFirstName!),
                child: Column(
                  children: [
                    Container(
                      // height:
                      //     widget.commentModels[index].commentDetail!.length < 50
                      //         ? screenhight * 0.06
                      //         : screenhight *
                      //             widget.commentModels[index].commentDetail!
                      //                 .length /
                      //             100,
                      // decoration: index % 2 == 0
                      //     ? const BoxDecoration(color: Colors.white)
                      //     : BoxDecoration(color: Colors.grey[50]),
                      child: Container(
                        padding: const EdgeInsetsDirectional.only(
                            top: 0.0, bottom: 0.0, start: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.red,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(2), // Border radius
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          16), // Image radius
                                      child: CachedNetworkImage(
                                        imageUrl: MyConstant().domain +
                                            widget.commentModels[index]
                                                .userProfile!,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                MyStyle().showProgress(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'images/iconprofile.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.grey.shade100,
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    elevation: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.commentModels[index].userFirstName!}\t\t${widget.commentModels[index].userLastName!}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              // decoration: TextDecoration.underline,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              color: Colors.black,
                                              // fontStyle: FontStyle.italic,
                                              //fontFamily: 'FC-Minimal-Regular',
                                            ),
                                          ),
                                          Text(
                                            '${widget.commentModels[index].commentDetail}',
                                            overflow: TextOverflow.fade,
                                            style: MyStyle().mainH2Title,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5,bottom: 15,top: 2),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'ถูกใจ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          'ตอบกลับ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        // Text(
                                        //   widget.commentModels[index].commentDate
                                        //       .toString(),
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: const TextStyle(
                                        //     color: Colors.black45,
                                        //     fontSize: 12.0,
                                        //     fontFamily: 'FC-Minimal-Regular',
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: IconButton(
                            //     icon: const Icon(
                            //       MdiIcons.thumbUp,
                            //       color: Colors.black45,
                            //       size: 15,
                            //     ),
                            //     // ignore: unnecessary_statements
                            //     onPressed: () {},
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    //  SizedBox(
                    //   height: screenhight * 0.0005,
                    // ),
                    // Divider(
                    //   color: Colors.grey.shade200,
                    //   thickness: 1,
                    // ),
                  ],
                ),
              ),
            );
          },
          childCount: widget.moreComment
              ? widget.commentModels.length
              : widget.commentModels.length <= 3
                  ? widget.commentModels.length
                  : 3,
        ),
      ),
    );
  }
}
