import 'package:cloud_firestore/cloud_firestore.dart';


class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  final DateTime createdAt;
  final String userId;
  final double? latitude;
  final double? longitude;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
    this.latitude,
    this.longitude,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      title: data['title'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
