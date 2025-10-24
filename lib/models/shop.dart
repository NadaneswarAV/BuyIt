class Shop {
  final String id;
  final String name;
  final String description;
  final String location;
  final double averageRating;
  final int reviewCount;
  final List<dynamic> shopProducts;
  final String? image;

  // Additional fields for compatibility with existing code
  final double rating;
  final int time;
  final String delivery;
  final double distance;
  final List<String> categories;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.averageRating,
    required this.reviewCount,
    required this.shopProducts,
    this.image,
    this.rating = 4.5,
    this.time = 15,
    this.delivery = 'Free delivery',
    this.distance = 2.5,
    this.categories = const ['Grocery'],
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      // Normalize id to String regardless of API (int) or local JSON (string like "shop_001")
      id: json['id']?.toString() ?? '0',
      name: json['name'],
      description: json['description'],
      location: json['location'] ?? '',
      averageRating: (json['average_rating'] ?? json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      shopProducts: json['shop_products'] ?? [],
      image: json['image'] ?? 'assets/images/logo.png',
      rating: (json['average_rating'] ?? json['rating'] ?? 4.5).toDouble(),
      time: json['time'] ?? 15,
      delivery: json['delivery'] ?? 'Free delivery',
      distance: (json['distance'] ?? 2.5).toDouble(),
      categories: List<String>.from(json['categories'] ?? ['Grocery']),
    );
  }
}
