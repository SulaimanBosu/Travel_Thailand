import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/my_style.dart';

class LandmarkDetail extends StatefulWidget {
  const LandmarkDetail({Key? key, required this.landmarkModel})
      : super(key: key);
  final LandmarkModel landmarkModel;

  @override
  State<LandmarkDetail> createState() => _LandmarkDetailState();
}

class _LandmarkDetailState extends State<LandmarkDetail> {
  LandmarkModel landmarkModel = LandmarkModel();
  double screenwidth = 0;
  double screenhight = 0;

  @override
  void initState() {
    landmarkModel = widget.landmarkModel;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: screenwidget(context),
    );
  }

  Widget screenwidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: screenwidth,
        height: screenhight,
        color: Colors.white,
        child: Stack(
          children: [
            showImage(context, landmarkModel.imagePath!),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    decoration: const BoxDecoration(
                      color: Colors.white60,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    decoration: const BoxDecoration(
                      color: Colors.white60,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      color: Colors.black,
                      onPressed: () {
                        debugPrint('share');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenhight * 0.45,
              child: Stack(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      content(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              margin: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.favorite_outline_outlined),
                                color: Colors.black,
                                onPressed: () {
                                  debugPrint('รายการโปรด');
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              children: const [
                                Icon(Icons.star, color: Colors.orange),
                                Icon(Icons.star, color: Colors.orange),
                                Icon(Icons.star, color: Colors.orange),
                                Icon(Icons.star, color: Colors.orange),
                                Icon(Icons.star, color: Colors.orange),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      width: screenwidth,
      height: screenhight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10, bottom: 10, top: 20),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10, bottom: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landmarkModel.landmarkName!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'จังหวัด ${landmarkModel.provinceName!}',
                      style: const TextStyle(
                        color: Colors.black54,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
            child: Divider(
              color: Colors.black54,
              thickness: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10, bottom: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 15,
                ),
                Text(
                  ' ตำบล ${landmarkModel.districtName!}\t\t',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' อำเภอ ${landmarkModel.amphurName!}\t\t',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' จังหวัด ${landmarkModel.provinceName!}\t\t',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container showImage(BuildContext context, String imageURL) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.5,
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
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        elevation: 5,
        margin: const EdgeInsets.all(0),
      ),
    );
  }
}
