class LandmarkModel {
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
  String? imageid;
  int? landmarkScore;
  String? type;
  String? regionId;
  int? landmarkCount;

  LandmarkModel(
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
      this.imageid,
      this.landmarkScore,
      this.type,
      this.regionId,
      this.landmarkCount,});

  LandmarkModel.fromJson(Map<String, dynamic> json) {
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
    imageid = json['Image_id'];
    landmarkScore = json['Landmark_score'];
    type = json['Type'];
    regionId = json['region_id'];
    landmarkCount = json['Landmark_Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['Image_id'] = imageid;
    data['Landmark_score'] = landmarkScore;
    data['Type'] = type;
    data['region_id'] = regionId;
    data['Landmark_Count'] = landmarkCount;
    return data;
  }
}

List<String> itemList = [
  'ทะเล',
  'ภูเขา',
  'น้ำตก',
  'คาเฟ่',
  'อ่างเก็บน้ำ/เขื่อน',
];
List<String> imageList = [
  'images/beach-icon.png',
  'images/mountain-icon.png',
  'images/waterfall-icon.png',
  'images/cafe-icon.png',
  'images/dam-icon.png',
];
List<String> itemList2 = [
  'อุทยานแห่งชาติ',
  'เดินป่า',
  'แคมป์ปิ้ง',
  'มัสยิด/วัด',
  'ประวัติศาสตร์/เมืองโบราณ',
];
List<String> imageList2 = [
  'images/national-park-icon.png',
  'images/trekking-icon.png',
  'images/camping-icon.png',
  'images/masjid-icon.png',
  'images/history-icon.png',
];
