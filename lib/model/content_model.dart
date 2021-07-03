class Contents {
  int iduser;
  String username;
  String statuspost;
  int idcontent;
  String dateContent;
  String title;
  String category;
  String content;
  int counterread;
  String image01;
  String image02;
  String image03;
  String image04;

  Contents({
    this.iduser,
    this.username,
    this.statuspost,
    this.idcontent,
    this.dateContent,
    this.title,
    this.category,
    this.content,
    this.counterread,
    this.image01,
    this.image02,
    this.image03,
    this.image04,
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
    counterread = json['Counter_Read'];
    image01 = json['Images01'];
    image02 = json['Images02'];
    image03 = json['Images03'];
    image04 = json['Images04'];
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
    data['Counter_Read'] = this.counterread;
    data['Images01'] = this.image01;
    data['Images02'] = this.image02;
    data['Images03'] = this.image03;
    data['Images04'] = this.image04;
    return data;
  }
}
