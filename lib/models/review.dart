class Review {
  final String id;
  final String shopId;
  final String userName;
  final int rating;
  final String comment;

  Review({
    required this.id,
    required this.shopId,
    required this.userName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'],
        shopId: json['shopId'],
        userName: json['userName'],
        rating: json['rating'],
        comment: json['comment']);
  }
}