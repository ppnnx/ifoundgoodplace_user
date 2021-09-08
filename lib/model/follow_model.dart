class Follow {
  int? iduser;
  String? username;
  String? image;

  Follow({this.iduser, this.username, this.image});

  Follow.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    username = json['Username'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['Username'] = this.username;
    data['Image'] = this.image;
    return data;
  }
}
