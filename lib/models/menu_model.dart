class MenuModel {
  int? id;
  String title;
  String? description;
  DateTime date;
  int? price;
  String? category;
  int? categoryId;
  String? imageUrl;

  MenuModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.price,
    this.category,
    this.categoryId,
    this.imageUrl,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    price: json["price"],
    category: json["category"],
    categoryId: json["category_id"] != null ? int.parse(json["category_id"]) : null,
    imageUrl:
        json["image_url"] != null
            ? (json["image_url"] as String).replaceFirst('/menus/', '/public/menus/')
            : null,
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "price": price,
    "category_id": categoryId,
    "image": imageUrl,
  };
}
