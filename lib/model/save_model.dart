class SaveModel {
  String? statusSave;
  String? dateSave;
  String? timeSave;
  int? idcontent;
  String? author;
  String? dateContent;
  String? statusContent;
  String? title;
  String? images01;
  String? images02;
  String? images03;
  String? images04;
  int? idcategory;
  String? category;

  SaveModel(
      {this.statusSave,
      this.dateSave,
      this.timeSave,
      this.idcontent,
      this.author,
      this.dateContent,
      this.statusContent,
      this.title,
      this.images01,
      this.images02,
      this.images03,
      this.images04,
      this.idcategory,
      this.category});

  SaveModel.fromJson(Map<String, dynamic> json) {
    statusSave = json['Status_Save'];
    dateSave = json['Date_Save'];
    timeSave = json['Time_Save'];
    idcontent = json['ID_Content'];
    author = json['Author'];
    dateContent = json['Date_Content'];
    statusContent = json['Status_Content'];
    title = json['Title'];
    images01 = json['Images01'];
    images02 = json['Images02'];
    images03 = json['Images03'];
    images04 = json['Images04'];
    idcategory = json['ID_Category'];
    category = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status_Save'] = this.statusSave;
    data['Date_Save'] = this.dateSave;
    data['Time_Save'] = this.timeSave;
    data['ID_Content'] = this.idcontent;
    data['Author'] = this.author;
    data['Date_Content'] = this.dateContent;
    data['Status_Content'] = this.statusContent;
    data['Title'] = this.title;
    data['Images01'] = this.images01;
    data['Images02'] = this.images02;
    data['Images03'] = this.images03;
    data['Images04'] = this.images04;
    data['ID_Category'] = this.idcategory;
    data['Category'] = this.category;
    return data;
  }
}
