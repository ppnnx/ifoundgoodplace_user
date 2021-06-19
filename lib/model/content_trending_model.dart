class TrendingModel {
  int counterRead;
  int idcontent;
  String dateContent;
  String statusContent;
  String title;
  String content;
  String username;
  String images01;
  int idcategory;
  String category;

  TrendingModel(
      {this.counterRead,
      this.idcontent,
      this.dateContent,
      this.statusContent,
      this.title,
      this.content,
      this.username,
      this.images01,
      this.idcategory,
      this.category});

  TrendingModel.fromJson(Map<String, dynamic> json) {
    counterRead = json['Counter_Read'];
    idcontent = json['ID_Content'];
    dateContent = json['Date_Content'];
    statusContent = json['Status_Content'];
    title = json['Title'];
    content = json['Content'];
    username = json['Username'];
    images01 = json['Images01'];
    idcategory = json['ID_Category'];
    category = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Counter_Read'] = this.counterRead;
    data['ID_Content'] = this.idcontent;
    data['Date_Content'] = this.dateContent;
    data['Status_Content'] = this.statusContent;
    data['Title'] = this.title;
    data['Content'] = this.content;
    data['Username'] = this.username;
    data['Images01'] = this.images01;
    data['ID_Category'] = this.idcategory;
    data['Category'] = this.category;
    return data;
  }
}
