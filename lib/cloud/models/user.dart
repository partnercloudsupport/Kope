class User {
  static String userId;
  final String username;
  final String passwords;
  final String email;
  final String tel;
  final String nom;
  final String province;
  final String adresse;
  final String ville;
  final String profession;

  const User(
      {this.username,
        this.passwords,
        this.email,
        this.tel,
        this.nom,
        this.province,
        this.adresse,
        this.ville,
        this.profession});

  const User.init(
      {this.username,
        this.passwords,
        this.email,
        this.tel,
        this.nom,
        this.province,
        this.adresse,
        this.ville,
        this.profession});

  User.fromMap(Map<String, dynamic> data, String id)
      : this(
      username: data['username'],
      passwords: data['passwords'],
      email: data['email'],
      tel: data['data']);
}
