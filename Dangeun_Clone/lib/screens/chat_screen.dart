import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_room_screen.dart';
import '../utils/chat_utils.dart'; // getUserName 함수도 여기에 있으면 좋음

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(body: Center(child: Text('로그인이 필요합니다')));
    }

    print("✅ 로그인된 UID: ${currentUser.uid}");

    return Scaffold(
      appBar: AppBar(title: Text('채팅 목록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: currentUser.uid)
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          print("📡 연결 상태: ${snapshot.connectionState}");
          if (snapshot.hasError) {
            print("❌ 에러 발생: ${snapshot.error}");
          }

          if (!snapshot.hasData) {
            print("⌛ 아직 데이터 없음");
            return Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!.docs;
          print("📦 불러온 채팅방 수: ${chatRooms.length}");

          if (chatRooms.isEmpty) {
            print("🔍 조건에 맞는 채팅방 없음");
            return Center(child: Text("참여 중인 채팅방이 없습니다."));
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index].data() as Map<String, dynamic>;
              final chatRoomId = chatRooms[index].id;
              final users = room['users'];
              final otherUserId = (users as List)
                  .firstWhere((uid) => uid != currentUser.uid);

              final lastMessage = room['lastMessage'] ?? '대화를 시작해보세요';
              final updatedAt = room['updatedAt'] != null
                  ? (room['updatedAt'] as Timestamp).toDate()
                  : null;

              print("💬 채팅방 ID: $chatRoomId");
              print("👥 유저 목록: $users");
              print("🕒 updatedAt: $updatedAt");

              return FutureBuilder<String?>(
                future: getUserName(otherUserId),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? '사용자';
                  return ListTile(
                    title: Text(userName),
                    subtitle: Text(lastMessage),
                    trailing: updatedAt != null
                        ? Text('${updatedAt.hour}:${updatedAt.minute.toString().padLeft(2, '0')}')
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomScreen(chatRoomId: chatRoomId),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
