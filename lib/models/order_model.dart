import 'package:catering_app/models/menu_model.dart';

class OrderModel {
  int id;
  int userId;
  int menuId;
  String deliveryAddress;
  String? status;
  DateTime createdAt;
  DateTime updatedAt;
  MenuModel? menu;

  OrderModel({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.menu,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: int.parse(json["user_id"].toString()),
      menuId: int.parse(json["menu_id"].toString()),
      deliveryAddress: json["delivery_address"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      menu: json["menu"] != null ? MenuModel.fromJson(json["menu"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "menu_id": menuId,
    "delivery_address": deliveryAddress,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
