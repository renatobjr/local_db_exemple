class User {
  int? idUser;
  String? email;
  String? passwd;

  User({
    this.idUser,
    this.email,
    this.passwd,
  });

  factory User.fromMap(Map<dynamic, dynamic> data) {
    return User(
      idUser: data['idUser'],
      email: data['email'],
      passwd: data['passwd'],
    );
  }

  Map<String, dynamic> toMap() => {
        'idUser': idUser,
        'email': email,
        'passwd': passwd,
      };
}
