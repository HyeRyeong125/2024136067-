import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'dart:math';


class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // 상품 업로드
  Future<void> uploadProduct(Product product) async {
    await _db.collection('products').doc(product.id).set(product.toMap());
  }

  // 전체 상품 가져오기
  Future<List<Product>> getAllProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

  // 특정 유저의 상품 가져오기
  Future<List<Product>> getProductsByUser(String userId) async {
    final snapshot = await _db
        .collection('products')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

  // 거리 기반 필터링 (위도/경도 계산은 utils에서 따로 수행)
  Future<List<Product>> getProductsNearby(double lat, double lng, double maxDistanceKm) async {
    final snapshot = await _db.collection('products').get();
    final products = snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
    return products.where((p) {
      if (p.latitude == null || p.longitude == null) return false;
      return _calculateDistanceKm(lat, lng, p.latitude!, p.longitude!) < maxDistanceKm;
    }).toList();
  }

  double _calculateDistanceKm(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371; // 지구 반지름 (km)
    final dLat = _deg2rad(lat2 - lat1);
    final dLng = _deg2rad(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (3.1415926535897932 / 180.0);
}
