class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String subcategory;
  final String format;
  final String imageEmoji; // fallback visual hasta tener imagen real
  final String imageUrl;   // URL real (Mercadona CDN, etc.)
  final String supermarketId;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.subcategory = '',
    this.format = '',
    this.imageEmoji = '🛒',
    this.imageUrl = '',
    this.supermarketId = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        brand: (json['brand'] as String?) ?? '',
        category: (json['category'] as String?) ?? '',
        subcategory: (json['subcategory'] as String?) ?? '',
        format: (json['format'] as String?) ?? '',
        imageEmoji: (json['imageEmoji'] as String?) ?? '🛒',
        imageUrl: (json['imageUrl'] as String?) ?? '',
        supermarketId: (json['supermarketId'] as String?) ?? '',
      );

  factory Product.fromFirestore(Map<String, dynamic> data) => Product(
        id: data['id'] as String,
        name: data['name'] as String,
        brand: (data['brand'] as String?) ?? '',
        category: (data['category'] as String?) ?? '',
        subcategory: (data['subcategory'] as String?) ?? '',
        format: (data['format'] as String?) ?? '',
        imageEmoji: _emojiForCategory(data['category'] as String? ?? ''),
        imageUrl: (data['imageUrl'] as String?) ?? '',
        supermarketId: (data['supermarketId'] as String?) ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category,
        'subcategory': subcategory,
        'format': format,
        'imageEmoji': imageEmoji,
        'imageUrl': imageUrl,
        'supermarketId': supermarketId,
      };

  static String _emojiForCategory(String category) {
    const map = {
      'Alimentación': '🥫',
      'Bebidas': '🥤',
      'Lácteos': '🥛',
      'Huevos': '🥚',
      'Panadería': '🍞',
      'Cereales': '🥣',
      'Aceites': '🫙',
      'Conservas': '🥫',
      'Carnes': '🥩',
      'Embutidos': '🍖',
      'Frutas': '🍎',
      'Verduras': '🥦',
      'Bebidas alcohólicas': '🍷',
      'Dulces': '🍫',
      'Snacks': '🍿',
      'Vegano': '🌱',
      'Higiene': '🧴',
      'Limpieza': '🧹',
      'Mascotas': '🐾',
      'Bebé': '👶',
    };
    for (final entry in map.entries) {
      if (category.contains(entry.key)) return entry.value;
    }
    return '🛒';
  }
}
