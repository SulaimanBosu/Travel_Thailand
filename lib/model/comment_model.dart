class CommentModel {
  String? userFirstName;
  String? userLastName;
  String? userProfile;
  String? commentDetail;
  String? commentDate;
  bool? isLike;

  CommentModel({this.userFirstName, this.commentDetail, this.commentDate});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userFirstName = json['User_first_name'];
    userLastName = json['User_last_name'];
    userProfile = json['Image_profile'];
    commentDetail = json['Comment_detail'];
    commentDate = json['Comment_date'];
    isLike = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_first_name'] = userFirstName;
    data['User_last_name'] = userLastName;
    data['Image_profile'] = userProfile;
    data['Comment_detail'] = commentDetail;
    data['Comment_date'] = commentDate;
    data['isLike'] = isLike;
    return data;
  }
}
