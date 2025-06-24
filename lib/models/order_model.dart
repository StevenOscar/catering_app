class OrderModel {
  int id;
  int userId;
  int menuId;
  String deliveryAddress;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    userId: json["user_id"],
    menuId: json["menu_id"],
    deliveryAddress: json["delivery_address"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

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
