import 'dart:convert';

import 'package:catering_app/constants/endpoint.dart';
import 'package:catering_app/helper/shared_pref_helper.dart';
import 'package:catering_app/models/category_model.dart';
import 'package:catering_app/models/menu_model.dart';
import 'package:catering_app/models/order_model.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:http/http.dart' as http;

class CateringApi {
  static Future<ResponseModel<List<MenuModel>>> getMenu() async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.menus),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel.listFromJson<MenuModel>(
        json: jsonDecode(response.body),
        fromJsonT: (x) => MenuModel.fromJson(x),
      );
    } else {
      throw Exception("Error Fetching menu");
    }
  }

  static Future<ResponseModel> postMenu({required MenuModel menu}) async {
    final String token = await SharedPrefHelper.getToken();
    print(menu.title);
    print(menu.price);
    print(menu.description);
    print(jsonEncode(menu.toJson()));
    final response = await http.post(
      Uri.parse(Endpoint.menus),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(menu.toJson()),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 422) {
      return ResponseModel.fromJson(json: jsonDecode(response.body));
    } else {
      throw Exception("Error Creating menu");
    }
  }

  static Future<int> deleteMenu({required int id}) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.delete(
      Uri.parse("${Endpoint.menus}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception("Error Deleting menu");
    }
  }

  static Future<ResponseModel<List<OrderModel>>> getOrder() async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.get(
      Uri.parse("${Endpoint.orders}/history"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return ResponseModel.listFromJson<OrderModel>(
        json: jsonDecode(response.body),
        fromJsonT: (x) => OrderModel.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery");
    }
  }

  static Future<ResponseModel<OrderModel>> postOrder({
    required int menuId,
    required String deliveryAddress,
  }) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.orders),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"menu_id": menuId, "delivery_address": deliveryAddress}),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 422) {
      return ResponseModel<OrderModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => OrderModel.fromJson(x),
      );
    } else {
      throw Exception("Error Order catering");
    }
  }

  static Future<ResponseModel<OrderModel>> deleteOrder({required int orderId}) async {
    final String token = await SharedPrefHelper.getToken();
    // TODO Problem
    final response = await http.delete(
      Uri.parse("${Endpoint.orders}/$orderId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<OrderModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => OrderModel.fromJson(x),
      );
    } else {
      throw Exception("Error Delete Order");
    }
  }

  static Future<ResponseModel<List<CategoryModel>>> getCategory() async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.categories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel.listFromJson<CategoryModel>(
        json: jsonDecode(response.body),
        fromJsonT: (x) => CategoryModel.fromJson(x),
      );
    } else {
      throw Exception("Error Get Category");
    }
  }

  static Future<ResponseModel<CategoryModel>> postCategory({required String name}) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.categories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: {"name": name},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<CategoryModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => CategoryModel.fromJson(x),
      );
    } else {
      throw Exception("Error Post Category");
    }
  }

  static Future<ResponseModel<CategoryModel>> updateCategory({
    required String name,
    required int categoryId,
  }) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.put(
      Uri.parse("${Endpoint.categories}/$categoryId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: {"name": name},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<CategoryModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => CategoryModel.fromJson(x),
      );
    } else {
      throw Exception("Error Update Category");
    }
  }

  static Future<ResponseModel<CategoryModel>> deleteCategory({required int categoryId}) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.delete(
      Uri.parse("${Endpoint.categories}/$categoryId"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<CategoryModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => CategoryModel.fromJson(x),
      );
    } else {
      throw Exception("Error Delete Category");
    }
  }

  static Future<ResponseModel<OrderModel>> updateDeliveryStatus({
    required String status,
    required int orderId,
  }) async {
    final String token = await SharedPrefHelper.getToken();
    final response = await http.put(
      Uri.parse("${Endpoint.orders}/$orderId/status"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"status": status},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<OrderModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => OrderModel.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery Status");
    }
  }

  static Future<ResponseModel<OrderModel>> updateDeliveryAddress({
    required String deliveryAddress,
    required int orderId,
  }) async {
    final String token = await SharedPrefHelper.getToken();

    //TODO Problem
    final response = await http.put(
      Uri.parse("${Endpoint.orders}/$orderId/address"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"delivery_address": deliveryAddress},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<OrderModel>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => OrderModel.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery Address");
    }
  }
}
