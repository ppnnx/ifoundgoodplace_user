final String bookmarkTable = 'bookmark';

class BookMarkFields {
  static final List<String> bookmarkFields = [
    email,
    iduser,
    author,
    idcontent,
    title,
    category,
    content,
    bookmarkDate,
  ];

  static final String iduser = 'iduser';
  static final String author = 'author';
  static final String email = 'email';
  static final String idcontent = 'idcontent';
  static final String bookmarkDate = 'dateContent';
  static final String title = 'title';
  static final String category = 'category';
  static final String content = 'content';
}

class BookMarkDB {
  int? iduser;
  String? email;
  int? idcontent;
  String? author;
  String? bookmarkDate;
  String? title;
  String? category;
  String? content;

  BookMarkDB({
    this.iduser,
    this.author,
    this.email,
    this.idcontent,
    this.bookmarkDate,
    this.title,
    this.category,
    this.content,
  });

  Map<String, Object?> toJson() => {
        BookMarkFields.iduser: iduser,
        BookMarkFields.author: author,
        BookMarkFields.email: email,
        BookMarkFields.idcontent: idcontent,
        BookMarkFields.bookmarkDate: bookmarkDate,
        BookMarkFields.title: title,
        BookMarkFields.category: category,
        BookMarkFields.content: content,
      };

  static BookMarkDB fromJson(Map<String, Object> json) => BookMarkDB(
        iduser: json[BookMarkFields.iduser] as int?,
        author: json[BookMarkFields.author] as String?,
        email: json[BookMarkFields.email] as String?,
        idcontent: json[BookMarkFields.idcontent] as int?,
        bookmarkDate: json[BookMarkFields.bookmarkDate] as String?,
        title: json[BookMarkFields.title] as String?,
        category: json[BookMarkFields.category] as String?,
        content: json[BookMarkFields.content] as String?,
      );
}
