class PopularModel {
  String? landmarkView;
  String? landmarkId;
  String? landmarkName;
  String? landmarkDetail;
  String? districtName;
  String? amphurName;
  String? provinceName;
  String? latitude;
  String? longitude;
  String? imagePath;
  int? landmarkScore;

  PopularModel(
      {this.landmarkView,
      this.landmarkId,
      this.landmarkName,
      this.landmarkDetail,
      this.districtName,
      this.amphurName,
      this.provinceName,
      this.latitude,
      this.longitude,
      this.imagePath,
      this.landmarkScore});

  PopularModel.fromJson(Map<String, dynamic> json) {
    landmarkView = json['Landmark_view'];
    landmarkId = json['Landmark_id'];
    landmarkName = json['Landmark_name'];
    landmarkDetail = json['Landmark_detail'];
    districtName = json['District_name'];
    amphurName = json['Amphur_name'];
    provinceName = json['Province_name'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    imagePath = json['ImagePath'];
    landmarkScore = json['Landmark_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Landmark_view'] = landmarkView;
    data['Landmark_id'] = landmarkId;
    data['Landmark_name'] = landmarkName;
    data['Landmark_detail'] = landmarkDetail;
    data['District_name'] = districtName;
    data['Amphur_name'] = amphurName;
    data['Province_name'] = provinceName;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['ImagePath'] = imagePath;
    data['Landmark_score'] = landmarkScore;
    return data;
  }
}
