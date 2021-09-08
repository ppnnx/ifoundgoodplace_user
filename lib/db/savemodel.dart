class Save {
  int? id;
  int? iduser;
  int? idauthor;
  String? author;
  int? idcontent;
  String? datecontent;
  String? title;
  String? category;
  String? story;
  String? link;
  double? latitude;
  double? longitude;
  String? image01;
  String? image02;
  String? image03;
  String? image04;
  int? counterread;
  int? favorite;
  int? comments;
  int? share;
  int? save;

  Save({
    this.id,
    this.iduser,
    this.idauthor,
    this.author,
    this.datecontent,
    this.idcontent,
    this.title,
    this.category,
    this.story,
    this.link,
    this.latitude,
    this.longitude,
    this.image01,
    this.image02,
    this.image03,
    this.image04,
    this.counterread,
    this.favorite,
    this.comments,
    this.save,
    this.share,
  });

  factory Save.fromMap(Map<String, dynamic> json) => new Save(
        id: json['id'],
        iduser: json['iduser'],
        idauthor: json['idauthor'],
        author: json['author'],
        datecontent: json['datecontent'],
        idcontent: json['idcontent'],
        title: json['title'],
        category: json['category'],
        story: json['story'],
        link: json['link'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        image01: json['image01'],
        image02: json['image02'],
        image03: json['image03'],
        image04: json['image04'],
        counterread: json['counterread'],
        favorite: json['favorite'],
        comments: json['comments'],
        save: json['save'],
        share: json['share'],
      );

  // create a function to convert our item into a map
  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "iduser": iduser,
      "idauthor": idauthor,
      "author": author,
      "datecontent": datecontent,
      "idcontent": idcontent,
      "title": title,
      "category": category,
      "story": story,
      "link": link,
      "latitude": latitude,
      "longitude": longitude,
      "image01": image01,
      "image02": image02,
      "image03": image03,
      "image04": image04,
      "counterread": counterread,
      "favorite": favorite,
      "comments": comments,
      "save": save,
      "share": share,
    });
  }
}
