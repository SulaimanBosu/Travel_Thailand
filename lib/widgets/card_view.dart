import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/my_style.dart';

class CardView extends StatefulWidget {
  final LandmarkModel landmarkModel;
  final int index;
  const CardView({
    Key? key,
    required this.landmarkModel,
    required this.index,
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
          // MaterialPageRoute route = MaterialPageRoute(
          //   builder: (context) => ShopInfo(
          //     shopModel: infomationShopModels[index],
          //  ),
          // );
          //   Navigator.push(context, route);
        },
        // ignore: avoid_unnecessary_containers
        child: Card(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              showImage(context, imageURL),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyStyle().mySizebox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.landmarkModel.landmarkName!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'จังหวัด ${widget.landmarkModel.provinceName}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คะแนน ${widget.landmarkModel.landmarkScore}/5',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                          Text(
                            'View ${widget.landmarkModel.landmarkView}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container showImage(BuildContext context, String imageURL) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.14,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
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
      ),
    );
  }
}
