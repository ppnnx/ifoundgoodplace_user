class CheckFavorited {
  int? iduser;
  int? idcontent;
  String? statusFav;

  CheckFavorited({this.iduser, this.idcontent, this.statusFav});

  CheckFavorited.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    idcontent = json['ID_Content'];
    statusFav = json['Status_Fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['ID_Content'] = this.idcontent;
    data['Status_Fav'] = this.statusFav;
    return data;
  }
}
