class AuthorTrendingModel {
  int iduser;
  String username;
  int sumread;
  String image;

  AuthorTrendingModel({this.iduser, this.username, this.sumread, this.image});

  AuthorTrendingModel.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    username = json['Username'];
    sumread = json['sumread'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['Username'] = this.username;
    data['sumread'] = this.sumread;
    data['Image'] = this.image;
    return data;
  }
}
