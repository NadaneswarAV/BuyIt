class Shop {
  final String id;
  final String name;
  final double rating;
  final String description;
  final String delivery;
  final int time;
  final double distance;
  final List<String> categories;
  final String image;

  Shop({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.delivery,
    required this.time,
    required this.distance,
    required this.categories,
    required this.image,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      delivery: json['delivery'],
      time: json['time'],
      distance: (json['distance'] as num).toDouble(),
      categories: List<String>.from(json['categories']),
      image: json['image'],
    );
  }
}