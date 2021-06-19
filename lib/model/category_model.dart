class Categories {
  int id;
  String name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['ID_Category'];
    name = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_Category'] = this.id;
    data['Category'] = this.name;
    return data;
  }
}