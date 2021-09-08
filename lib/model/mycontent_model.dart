class MyContent {
  int? iduser;
  String? username;
  String? image;
  String? statusPost;
  String? statusContent;
  String? statusReport;
  String? statement;
  int? idcontent;
  String? dateContent;
  String? timeContent;
  String? title;
  String? category;
  String? content;
  String? link;
  String? location;
  int? counterread;
  String? images01;
  String? images02;
  String? images03;
  String? images04;
  int? favorited;
  int? comment;
  int? saved;
  int? shared;

  MyContent(
      {this.iduser,
      this.username,
      this.image,
      this.statusPost,
      this.statusContent,
      this.statusReport,
      this.statement,
      this.idcontent,
      this.dateContent,
      this.timeContent,
      this.title,
      this.category,
      this.content,
      this.link,
      this.location,
      this.counterread,
      this.images01,
      this.images02,
      this.images03,
      this.images04,
      this.favorited,
      this.comment,
      this.saved,
      this.shared});

  MyContent.fromJson(Map<String, dynamic> json) {
    iduser = json['ID_User'];
    username = json['Username'];
    image = json['Image'];
    statusPost = json['Status_Post'];
    statusContent = json['Status_Content'];
    statusReport = json['Status_Report'];
    statement = json['Statement'];
    idcontent = json['ID_Content'];
    dateContent = json['Date_Content'];
    timeContent = json['Time_Content'];
    title = json['Title'];
    category = json['Category'];
    content = json['Content'];
    link = json['Link_VDO'];
    location = json['Location'];
    counterread = json['Counter_Read'];
    images01 = json['Images01'];
    images02 = json['Images02'];
    images03 = json['Images03'];
    images04 = json['Images04'];
    favorited = json['Total_Fav'];
    comment = json['Total_Com'];
    saved = json['Total_Save'];
    shared = json['Total_Share'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_User'] = this.iduser;
    data['Username'] = this.username;
    data['Image'] = this.image;
    data['Status_Post'] = this.statusPost;
    data['Status_Content'] = this.statusContent;
    data['Status_Report'] = this.statusReport;
    data['Statement'] = this.statement;
    data['ID_Content'] = this.idcontent;
    data['Date_Content'] = this.dateContent;
    data['Time_Content'] = this.timeContent;
    data['Title'] = this.title;
    data['Category'] = this.category;
    data['Content'] = this.content;
    data['Link_VDO'] = this.link;
    data['Location'] = this.location;
    data['Counter_Read'] = this.counterread;
    data['Images01'] = this.images01;
    data['Images02'] = this.images02;
    data['Images03'] = this.images03;
    data['Images04'] = this.images04;
    data['Total_Fav'] = this.favorited;
    data['Total_Com'] = this.comment;
    data['Total_Save'] = this.saved;
    data['Total_Share'] = this.shared;
    return data;
  }
}
