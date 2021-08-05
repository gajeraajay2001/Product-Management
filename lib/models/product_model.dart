class Products {
  int? id;
  final String name;
  final String color;
  final int stock;
  final String type;
  int selected = 0;
  Products({
    this.id,
    required this.name,
    required this.color,
    required this.selected,
    required this.stock,
    required this.type,
  });
  static Products fromMap(Map<String, dynamic> map) {
    return Products(
      id: map["id"],
      color: map["color"],
      name: map["name"],
      selected: map["selected"],
      stock: map["stock"],
      type: map["type"],
    );
  }
}
