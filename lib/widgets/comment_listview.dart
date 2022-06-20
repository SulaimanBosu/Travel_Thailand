import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project/model/comment_model.dart';
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
                      height:
                          widget.commentModels[index].commentDetail!.length < 50
                              ? screenhight * 0.065
                              : screenhight *
                                  widget.commentModels[index].commentDetail!
                                      .length /
                                  100,
                      // decoration: index % 2 == 0
                      //     ? const BoxDecoration(color: Colors.white)
                      //     : BoxDecoration(color: Colors.grey[50]),
                      child: Container(
                        padding: const EdgeInsetsDirectional.only(
                            top: 0.0, bottom: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 10.0, end: 2.0),
                              child: Container(
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.commentModels[index].userFirstName!}\t\t${widget.commentModels[index].userLastName!}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        textBaseline: TextBaseline.ideographic,
                                        color: Colors.black45,
                                        // fontStyle: FontStyle.italic,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Comment : ${widget.commentModels[index].commentDetail}',
                                        overflow: TextOverflow.fade,
                                        style: MyStyle().mainH2Title,
                                      ),
                                    ),
                                    Text(
                                      widget.commentModels[index].commentDate
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  MdiIcons.thumbUp,
                                  color: Colors.black45,
                                  size: 15,
                                ),
                                // ignore: unnecessary_statements
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1,
                    ),
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
