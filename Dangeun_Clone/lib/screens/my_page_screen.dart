import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../services/auth_service.dart';

class MyPageScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<Product>> fetchMyProducts(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // 로그인 안 되어 있으면 로그인 화면으로 이동
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL ?? ''),
            ),
            title: Text(user!.displayName ?? '이름 없음'),
            subtitle: Text(user!.email ?? '이메일 없음'),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: fetchMyProducts(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('등록한 상품이 없습니다.'));
                }

                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
