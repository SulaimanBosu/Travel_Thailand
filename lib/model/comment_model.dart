class CommentModel {
  String? userFirstName;
  String? userLastName;
  String? commentDetail;
  String? commentDate;

  CommentModel({this.userFirstName, this.commentDetail, this.commentDate});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userFirstName = json['User_first_name'];
    userLastName = json['User_last_name'];
    commentDetail = json['Comment_detail'];
    commentDate = json['Comment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_first_name'] = userFirstName;
    data['User_last_name'] = userLastName;
    data['Comment_detail'] = commentDetail;
    data['Comment_date'] = commentDate;
    return data;
  }
}