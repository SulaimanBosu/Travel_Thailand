import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/model/model_landmarkRecommended.dart';
import 'package:project/utility/my_style.dart';

class CardView extends StatefulWidget {
  final LandmarkRecommended landmarkRecommended;
  final int index;
  const CardView({
    Key? key,
    required this.landmarkRecommended,
    required this.index,
  }) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late LandmarkRecommended landmark;
  List<Widget> landmarkCards = [];
  late int index;

  @override
  void initState() {
    landmark = widget.landmarkRecommended;
    index = widget.index;
    buildCards();
  debugPrint('${landmark.landmarkId}');
    super.initState();
  }

  Future<Null> buildCards() async {
    landmarkCards.add(createCard(context, landmark, index));
    debugPrint('${landmark.landmarkId}');
  }

  @override
  Widget build(BuildContext context) {
    return landmark == null ? Container() : GridView.extent(
        maxCrossAxisExtent: 265,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        children: landmarkCards,
    );
  }

  Widget createCard(
    BuildContext context,
    LandmarkRecommended landmarkRecommended,
    int index,
  ) {
    String imageURL = landmarkRecommended.imagePath!;
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        // MaterialPageRoute route = MaterialPageRoute(
        //   builder: (context) => ShopInfo(
        //     shopModel: infomationShopModels[index],
        //  ),
        // );
        //   Navigator.push(context, route);
      },
      // ignore: avoid_unnecessary_containers
      child: Container(
        height: 400,
        child: Card(
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
                            landmarkRecommended.landmarkName!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'จังหวัด ${landmarkRecommended.provinceName}',
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
                            'คะแนน ${landmarkRecommended.landmarkScore}/5',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                              fontFamily: 'FC-Minimal-Regular',
                            ),
                          ),
                          Text(
                            'View ${landmarkRecommended.landmarkView}',
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
      height: MediaQuery.of(context).size.width * 0.30,
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(0),
      ),
    );
  }

  Container buildlistView() {
    return Container(
      height: 60,
      color: Colors.orange,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            height: 20,
            width: 20,
            color: Colors.red,
          );
        },
      ),
    );
  }
}
