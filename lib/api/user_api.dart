import 'dart:convert';

import 'package:catering_app/constants/endpoint.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:catering_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<ResponseModel> createUser({
    required String name,
    required String password,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );

    if (response.statusCode == 200 || response.statusCode == 422) {
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => UserModel.fromJson(x),
      );
    } else {
      throw Exception("Error Register");
    }
  }

  static Future<ResponseModel<UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<UserModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => UserModel.fromJson(x),
      );
    } else if (response.statusCode == 422 ||
        response.statusCode == 404 ||
        response.statusCode == 401) {
      return ResponseModel<UserModel>.fromJson(json: jsonDecode(response.body));
    } else {
      throw Exception("Error Login");
    }
  }
}
