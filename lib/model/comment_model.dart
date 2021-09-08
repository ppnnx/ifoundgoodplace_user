class CommentModel {
  int? idComment;
  int? idUser;
  String? username;
  String? image;
  String? comment;
  String? dateComment;
  String? timeComment;

  CommentModel(
      {this.idComment,
      this.idUser,
      this.username,
      this.image,
      this.comment,
      this.dateComment,
      this.timeComment});

  CommentModel.fromJson(Map<String, dynamic> json) {
    idComment = json['ID_Comment'];
    idUser = json['ID_User'];
    username = json['Username'];
    image = json['Image'];
    comment = json['Comment'];
    dateComment = json['Date_Comment'];
    timeComment = json['Time_Comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_Comment'] = this.idComment;
    data['ID_User'] = this.idUser;
    data['Username'] = this.username;
    data['Image'] = this.image;
    data['Comment'] = this.comment;
    data['Date_Comment'] = this.dateComment;
    data['Time_Comment'] = this.timeComment;
    return data;
  }
}

