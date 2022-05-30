// ignore_for_file: camel_case_types

class LandmarkRecommended {
  String? landmarkId;
  String? landmarkName;
  String? provinceName;
  int? landmarkScore;
  String? landmarkView;
  String? imagePath;

  LandmarkRecommended(
      {this.landmarkId,
      this.landmarkName,
      this.provinceName,
      this.landmarkScore,
      this.landmarkView,
      this.imagePath});

  LandmarkRecommended.fromJson(Map<String, dynamic> json) {
    landmarkId = json['Landmark_id'];
    landmarkName = json['Landmark_name'];
    provinceName = json['Province_name'];
    landmarkScore = json['Landmark_score'];
    landmarkView = json['Landmark_view'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Landmark_id'] = landmarkId;
    data['Landmark_name'] = landmarkName;
    data['Province_name'] = provinceName;
    data['Landmark_score'] = landmarkScore;
    data['Landmark_view'] = landmarkView;
    data['ImagePath'] = imagePath;
    return data;
  }
}
