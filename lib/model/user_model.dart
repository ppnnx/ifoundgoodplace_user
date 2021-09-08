class User {
  int? iduser;
  String? username;
  String? image;
  String? status;
  int? follower;
  int? following;
  String? createdate;
  String? email;

  User(
      {this.iduser,
      this.username,
      this.image,
      this.status,
      this.follower,
      this.following,
      this.createdate,
      this.email});

  User.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    username = json['Username'];
    image = json['Image'];
    status = json['Status_User'];
    follower = json['follower'];
    following = json['following'];
    createdate = json['Date_User'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['Username'] = this.username;
    data['Image'] = this.image;
    data['Status_User'] = this.status;
    data['follower'] = this.follower;
    data['following'] = this.following;
    data['Date_User'] = this.createdate;
    data['Email'] = this.email;
    return data;
  }
}
