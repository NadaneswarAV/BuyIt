class Product {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String image;
  final double rating;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      shopId: json['shopId'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      category: json['category'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}