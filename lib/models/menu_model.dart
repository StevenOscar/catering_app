class MenuModel {
  int id;
  String title;
  String description;
  DateTime date;
  int price;
  dynamic imageUrl;
  dynamic imagePath;

  MenuModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.imagePath,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    price: json["price"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "price": price,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
