final String userTable = 'user';

class UserFields {
  static final List<String> allFields = [
    iduser,
    email,
  ];

  static final String iduser = 'iduser';
  static final String email = 'email';
}

class UserDB {
  int? iduser;
  String? email;

  UserDB({this.iduser, this.email});

  Map<String, Object?> toJson() => {
        UserFields.iduser: iduser,
        UserFields.email: email,
      };

  static UserDB fromJson(Map<String, Object> json) => UserDB(
        iduser: json[UserFields.iduser] as int?,
        email: json[UserFields.email] as String?,
      );
}
