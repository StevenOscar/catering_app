import 'dart:convert';

class UserModel {
  String? token;
  User? user;

  UserModel({this.token, this.user});

  factory UserModel.fromRawJson(String str) => UserModel.fromLoginJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromLoginJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  factory UserModel.fromProfileJson(Map<String, dynamic> json) {
    return UserModel(user: User.fromJson(json));
  }

  Map<String, dynamic> toJson() => {"token": token, "data": user?.toJson()};
}

class User {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({this.id, this.name, this.email, this.emailVerifiedAt, this.createdAt, this.updatedAt});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
