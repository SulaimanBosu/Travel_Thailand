class ProvinceModel {
  String? districtName;
  String? amphurName;
  String? provinceName;
  String? provinceId;
  String? provinceLogo;
  String? regionId;
  String? regionName;

  ProvinceModel(
      {this.districtName,
      this.amphurName,
      this.provinceName,
      this.provinceId,
      this.provinceLogo,
      this.regionId,
      this.regionName});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    districtName = json['District_name'];
    amphurName = json['Amphur_name'];
    provinceName = json['Province_name'];
    provinceId = json['Province_id'];
    provinceLogo = json['Province_logo'];
    regionId = json['region_id'];
    regionName = json['region_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['District_name'] = districtName;
    data['Amphur_name'] = amphurName;
    data['Province_name'] = provinceName;
    data['Province_id'] = provinceId;
    data['Province_logo'] = provinceLogo;
    data['region_id'] = regionId;
    data['region_name'] = regionName;
    return data;
  }
}
