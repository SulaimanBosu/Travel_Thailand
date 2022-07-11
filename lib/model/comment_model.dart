class CommentModel {
  int? commentid;
  String? userid;
  String? userFirstName;
  String? userLastName;
  String? userProfile;
  String? commentDetail;
  String? commentDate;
  bool? isLike;
  int? likeCount;
  bool? isDate = false;

  CommentModel(
      {this.commentid,
      this.userid,
      this.userFirstName,
      this.commentDetail,
      this.commentDate,
      this.isLike,
      this.likeCount,
      this.isDate,});

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentid = json['Comment_id'];
    userid = json['User_id'];
    userFirstName = json['User_first_name'];
    userLastName = json['User_last_name'];
    userProfile = json['Image_profile'];
    commentDetail = json['Comment_detail'];
    commentDate = json['Comment_date'];
    isLike = json['isLike'];
    likeCount = json['LikeCount'];
    isDate = json['isDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Comment_id'] = commentid;
    data['User_id'] = userid;
    data['User_first_name'] = userFirstName;
    data['User_last_name'] = userLastName;
    data['Image_profile'] = userProfile;
    data['Comment_detail'] = commentDetail;
    data['Comment_date'] = commentDate;
    data['isLike'] = isLike;
    data['LikeCount'] = likeCount;
    data['isDate'] = isDate;
    return data;
  }
}
