import 'dart:convert';
class ItemModel {
  final int id;
  final String type;
  final String name;
  final String? description;
  final double price;
  final int? sellerId;
  final String? categoryId;
  final List<String> images;
  final double rating;
  final int stock;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  const ItemModel({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    required this.price,
    this.sellerId,
    this.categoryId,
    this.images = const [],
    this.rating = 0.0,
    this.stock = 0,
    this.metadata,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'categoryId': categoryId,
      'images': json.encode(images),
      'rating': rating,
      'stock': stock,
      'metadata': metadata != null ? json.encode(metadata) : null,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int,
      type: map['type'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      sellerId: map['sellerId'] as int?,
      categoryId: map['categoryId'] as String?,
      images: map['images'] != null ? List<String>.from(json.decode(map['images'] as String) as List) : [],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      stock: map['stock'] as int? ?? 0,
      metadata: map['metadata'] != null ? json.decode(map['metadata'] as String) as Map<String, dynamic> : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}