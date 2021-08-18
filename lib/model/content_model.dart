class Contents {
  int iduser;
  String username;
  String statuspost;
  int idcontent;
  String dateContent;
  String title;
  String category;
  String content;
  String link;
  double latitude;
  double longitude;
  int counterread;
  String image01;
  String image02;
  String image03;
  String image04;
  int favorite;
  int save;
  int comments;
  int share;

  Contents({
    this.iduser,
    this.username,
    this.statuspost,
    this.idcontent,
    this.dateContent,
    this.title,
    this.category,
    this.content,
    this.link,
    this.latitude,
    this.longitude,
    this.counterread,
    this.image01,
    this.image02,
    this.image03,
    this.image04,
    this.favorite,
    this.save,
    this.comments,
    this.share,
  });

  Contents.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    username = json['Username'];
    statuspost = json['Status_Post'];
    idcontent = json['ID_Content'];
    dateContent = json['Date_Content'];
    title = json['Title'];
    category = json['Category'];
    content = json['Content'];
    link = json['Link_VDO'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    counterread = json['Counter_Read'];
    image01 = json['Images01'];
    image02 = json['Images02'];
    image03 = json['Images03'];
    image04 = json['Images04'];
    favorite = json['Total_Fav'];
    save = json['Total_Save'];
    comments = json['Total_Com'];
    share = json['Total_Share'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['Username'] = this.username;
    data['Status_Post'] = this.statuspost;
    data['ID_Content'] = this.idcontent;
    data['Date_Content'] = this.dateContent;
    data['Title'] = this.title;
    data['Category'] = this.category;
    data['Content'] = this.content;
    data['Link_VDO'] = this.link;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['Counter_Read'] = this.counterread;
    data['Images01'] = this.image01;
    data['Images02'] = this.image02;
    data['Images03'] = this.image03;
    data['Images04'] = this.image04;
    data['Total_Fav'] = this.favorite;
    data['Total_Save'] = this.save;
    data['Total_Com'] = this.comments;
    data['Total_Share'] = this.share;
    return data;
  }
}
