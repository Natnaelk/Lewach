import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String productName;
  final double price;
  final String status;
  final String imageUrl;
  final String creatorId;
  final String creatorName;
  final String creatorPhone;
  final Timestamp createdAt;
  final List<String> eligibleExchangeItems; // New field

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.creatorId,
    required this.creatorName,
    required this.creatorPhone,
    required this.createdAt,
    required this.eligibleExchangeItems, // Initialize the new field
  });

  // toFirestore method with the new field
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'status': status,
      'imageUrl': imageUrl,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorPhone': creatorPhone,
      'createdAt': createdAt,
      'eligibleExchangeItems': eligibleExchangeItems, // Include the new field
    };
  }

  // fromFirestore method with the new field
  static Product fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      productName: data['productName'],
      price: data['price'],
      status: data['status'],
      imageUrl: data['imageUrl'],
      creatorId: data['creatorId'],
      creatorName: data['creatorName'],
      creatorPhone: data['creatorPhone'],
      createdAt: data['createdAt'],
      eligibleExchangeItems: List<String>.from(
          data['eligibleExchangeItems']), // Retrieve the new field
    );
  }
}

class BidSubmittersProduct {
  final String productName;
  final double price;
  final String status;
  final String imageUrl; // New field

  BidSubmittersProduct({
    required this.productName,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  // toFirestore method with the new field
  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'price': price,
      'status': status,
      'imageUrl': imageUrl,
    };
  }

  // fromFirestore method with the new field
  static BidSubmittersProduct fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BidSubmittersProduct(
      productName: data['productName'],
      price: data['price'],
      status: data['status'],
      imageUrl: data['imageUrl'],
    );
  }
}
