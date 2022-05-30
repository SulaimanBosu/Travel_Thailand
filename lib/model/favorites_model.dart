class FavoritesModel {
  String? landmarkId;
  String? landmarkName;
  String? provinceName;
  String? landmarkView;
  int? landmarkScore;
  String? imagePath;

  FavoritesModel(
      {this.landmarkId,
      this.landmarkName,
      this.provinceName,
      this.landmarkView,
      this.landmarkScore,
      this.imagePath});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    landmarkId = json['Landmark_id'];
    landmarkName = json['Landmark_name'];
    provinceName = json['Province_name'];
    landmarkView = json['Landmark_view'];
    landmarkScore = json['Landmark_score'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Landmark_id'] = landmarkId;
    data['Landmark_name'] = landmarkName;
    data['Province_name'] = provinceName;
    data['Landmark_view'] = landmarkView;
    data['Landmark_score'] = landmarkScore;
    data['ImagePath'] = imagePath;
    return data;
  }
}
