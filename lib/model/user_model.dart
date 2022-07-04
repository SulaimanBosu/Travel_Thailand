

class UserModel {
  String? userId = '';
  String? name = '';
  String? lastname = '';
  String? phone = '';
  String? gender = '';
  String? email = '';
  String? file = '';
  String? imagecoverPage = '';

  UserModel({
    this.userId,
    this.name,
    this.lastname,
    this.phone,
    this.gender,
    this.email,
    this.file,
    this.imagecoverPage,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['User_id'];
    name = json['Name'];
    lastname = json['Lastname'];
    phone = json['Phone'];
    gender = json['Gender'];
    email = json['Email'];
    file = json['File'];
    imagecoverPage = json['ImageCoverPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['User_id'] = userId;
    data['Name'] = name;
    data['Lastname'] = lastname;
    data['Phone'] = phone;
    data['Gender'] = gender;
    data['Email'] = email;
    data['File'] = file;
    data['ImageCoverPage'] = imagecoverPage;
    return data;
  }
}
