class Save {
  int id;
  int iduser;
  int idauthor;
  String author;
  int idcontent;
  String datecontent;
  String title;
  String category;
  String story;
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

  Save(
      {this.id,
      this.iduser,
      this.idauthor,
      this.author,
      this.idcontent,
      this.datecontent,
      this.title,
      this.category,
      this.story,
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
      this.share});

  factory Save.fromMap(Map<String, dynamic> json) => new Save(
        id: json['id'],
        iduser: json['iduser'],
        idauthor: json['idauthor'],
        author: json['author'],
        idcontent: json['idcontent'],
        datecontent: json['datecontent'],
        title: json['title'],
        category: json['category'],
        story: json['story'],
        link: json['link'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        counterread: json['counterread'],
        image01: json['image01'],
        image02: json['image02'],
        image03: json['image03'],
        image04: json['image04'],
        favorite: json['favorite'],
        save: json['save'],
        comments: json['comments'],
        share: json['share'],
      );

  // create a function to convert our item into a map
  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "iduser": iduser,
      "idauthor": idauthor,
      "author": author,
      "idcontent": idcontent,
      "datecontent": datecontent,
      "title": title,
      "category": category,
      "story": story,
      "link": link,
      "latitude": latitude,
      "longitude": longitude,
      "counterread": counterread,
      "image01": image01,
      "image02": image02,
      "image03": image03,
      "image04": image04,
      "favorite": favorite,
      "save": save,
      "comments": comments,
      "share": share
    });
  }
}
