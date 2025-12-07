import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'update_product_screen.dart';
import '../screens/chat_room_screen.dart'; // 새로 만든 채팅방 화면
import '../utils/chat_utils.dart'; // 유틸 함수 정의된 파일

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final bool isOwner = product.userId == currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions:
            isOwner
                ? [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateProductScreen(product: product),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(product.id)
                          .delete();
                      Navigator.pop(context);
                    },
                  ),
                ]
                : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.network(
                product.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('${product.price}원', style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.description),
            ),
            if (!isOwner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.chat),
                  label: Text('채팅하기'),
                  onPressed: () async {
                    final otherUserId = product.userId;
                    final myId = currentUser!.uid;

                    final chatRoomId = getChatRoomId(myId, otherUserId);
                    await createOrGetChatRoom(chatRoomId, [myId, otherUserId]);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(chatRoomId: chatRoomId),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
