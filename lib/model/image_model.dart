class ImageModel {
  String? imageId;
  String? imagePath;
  String? landmarkId;
  String? landmarkName;
  String? provinceName;

  ImageModel(
      {this.imageId,
      this.imagePath,
      this.landmarkId,
      this.landmarkName,
      this.provinceName});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageId = json['Image_id'];
    imagePath = json['ImagePath'];
    landmarkId = json['Landmark_id'];
    landmarkName = json['Landmark_name'];
    provinceName = json['Province_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Image_id'] = imageId;
    data['ImagePath'] = imagePath;
    data['Landmark_id'] = landmarkId;
    data['Landmark_name'] = landmarkName;
    data['Province_name'] = provinceName;
    return data;
  }
}

List<String> imgList = [];
