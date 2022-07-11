import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/comment_model.dart';
import 'package:project/utility/alert_dialog.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:resize/resize.dart';

typedef ListVoidFunc = void Function(List);

class CommentListview extends StatefulWidget {
  final List<CommentModel> commentModels;
  final List<String> commentdate;
  final int index;
  final bool moreComment;
  final ListVoidFunc onLike;
  final String userid;
  // final IntVoidFunc onLike;

  const CommentListview({
    Key? key,
    required this.commentModels,
    required this.index,
    required this.moreComment,
    required this.commentdate,
    required this.onLike,
    required this.userid,
  }) : super(key: key);

  @override
  State<CommentListview> createState() => _CommentListviewState();
}

class _CommentListviewState extends State<CommentListview> {
  late double screenwidth;
  late double screenhight;
  List<bool> isLike = [];
  List<bool> datetime = [];

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
                                radius: 19,
                                backgroundColor: Colors.red,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(2), // Border radius
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          18), // Image radius
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
                                            style: TextStyle(
                                              // decoration: TextDecoration.underline,

                                              fontSize: 9.0.sp,
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
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 15, top: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  widget.commentModels[index]
                                                      .isDate = true;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 5000),
                                                      () {
                                                    setState(() {
                                                      widget
                                                          .commentModels[index]
                                                          .isDate = false;
                                                    });
                                                  });
                                                });
                                              },
                                              child: Text(
                                                widget.commentModels[index]
                                                        .isDate!
                                                    ? widget
                                                        .commentModels[index]
                                                        .commentDate!
                                                    : widget.commentdate[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black54,
                                                  fontSize: 9.0.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenwidth * 0.025,
                                            ),
                                            InkWell(
                                              onTap: () => setState(() {
                                                if (widget.commentModels[index]
                                                        .isLike ==
                                                    true) {
                                                  widget.commentModels[index]
                                                      .isLike = false;
                                                  widget.commentModels[index]
                                                      .likeCount = (widget
                                                          .commentModels[index]
                                                          .likeCount! -
                                                      1);
                                                  List<int> like = [
                                                    0,
                                                    widget.commentModels[index]
                                                        .commentid!
                                                  ];
                                                  widget.onLike(like);
                                                } else {
                                                  widget.commentModels[index]
                                                      .isLike = true;
                                                  widget.commentModels[index]
                                                      .likeCount = (widget
                                                          .commentModels[index]
                                                          .likeCount! +
                                                      1);
                                                  List<int> like = [
                                                    1,
                                                    widget.commentModels[index]
                                                        .commentid!
                                                  ];
                                                  widget.onLike(like);
                                                }
                                              }),
                                              child: Text(
                                                'ถูกใจ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: widget
                                                              .commentModels[
                                                                  index]
                                                              .isLike ==
                                                          true
                                                      ? Colors.blue
                                                      : Colors.black54,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenwidth * 0.04,
                                            ),
                                            widget.userid ==
                                                    widget.commentModels[index]
                                                        .userid
                                                ? InkWell(
                                                    onTap: (() {
                                                      MyAlertDialog().showAlertDialog(
                                                          Icons
                                                              .delete_forever_outlined,
                                                          context,
                                                          'ลบ',
                                                          'คุณต้องการลบความคิดเห็นใช่หรือไม่',
                                                          'ตกลง', () {
                                                        List<int> delete = [
                                                          2,
                                                          widget
                                                              .commentModels[
                                                                  index]
                                                              .commentid!
                                                        ];
                                                        widget.onLike(delete);
                                                        setState(() {
                                                          widget.commentModels
                                                              .removeAt(index);
                                                        });

                                                        Navigator.pop(context);
                                                      });
                                                    }),
                                                    child: Text(
                                                      'ลบ',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: (() {
                                                      MyAlertDialog().showtDialog(
                                                          context,
                                                          Icons
                                                              .error_outline_outlined,
                                                          'ผิดพลาด',
                                                          'ฟังก์ชันการตอบกลับ ยังไม่พร้อมใช้งาน เนื่องจากคนเขียนแอพขี้เกียจทำ');
                                                      debugPrint(
                                                          'คุณกดปุ่มตอบกลับ');
                                                    }),
                                                    child: Text(
                                                      'ตอบกลับ',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),

                                        widget.commentModels[index].likeCount !=
                                                0
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3),
                                                      child: Text(
                                                        '${widget.commentModels[index].likeCount}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black54,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                    CircleAvatar(
                                                      radius:
                                                          screenwidth * 0.018,
                                                      backgroundColor:
                                                          Colors.blue.shade600,
                                                      child: Icon(
                                                        Icons.thumb_up,
                                                        color: Colors.white,
                                                        size:
                                                            screenwidth * 0.022,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),

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
                    //   height: screenhight * 0.025,
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
