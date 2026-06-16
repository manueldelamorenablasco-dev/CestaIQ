class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageEmoji; // Emoji representativo hasta tener imágenes reales

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.imageEmoji,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        brand: json['brand'] as String,
        category: json['category'] as String,
        imageEmoji: json['imageEmoji'] as String? ?? '🛒',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category,
        'imageEmoji': imageEmoji,
      };
}
