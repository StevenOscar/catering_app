import 'dart:convert';

class ResponseModel<T> {
  String message;
  T? data;
  Errors? errors;

  ResponseModel({required this.message, this.data, this.errors});

  factory ResponseModel.fromRawJson({
    required String str,
    T Function(Map<String, dynamic>)? fromJsonT,
  }) => ResponseModel.fromJson(json: json.decode(str), fromJsonT: fromJsonT);

  String toRawJson() => json.encode(toJson());

  factory ResponseModel.fromJson({
    required Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  }) {
    return ResponseModel(
      message: json["message"],
      errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      data:
          json["data"] == null
              ? null
              : fromJsonT != null
              ? fromJsonT(json["data"])
              : null,
    );
  }
  Map<String, dynamic> toJson() => {"message": message, "errors": errors?.toJson()};
}

class Errors {
  List<String>? name;
  List<String>? email;
  List<String>? password;

  Errors({this.name, this.email, this.password});

  factory Errors.fromRawJson(String str) => Errors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
    email: json["email"] == null ? [] : List<String>.from(json["email"]!.map((x) => x)),
    password: json["password"] == null ? [] : List<String>.from(json["password"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
    "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
    "password": password == null ? [] : List<dynamic>.from(password!.map((x) => x)),
  };

  List<String> toList() {
    List<String> errorMessages = [];
    if (name != null && name!.isNotEmpty) {
      errorMessages.add(name!.first);
    }
    if (email != null && email!.isNotEmpty) {
      errorMessages.add(email!.first);
    }
    if (password != null && password!.isNotEmpty) {
      errorMessages.add(password!.first);
    }
    return errorMessages;
  }
}
