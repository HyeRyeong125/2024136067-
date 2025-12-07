import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 사용자 UID 2개를 받아서 오름차순 정렬 후 chatRoomId 생성
String getChatRoomId(String uid1, String uid2) {
  final sorted = [uid1, uid2]..sort();
  return sorted.join('_');
}

/// 🔹 채팅방이 존재하지 않으면 생성
Future<void> createOrGetChatRoom(String chatRoomId, List<String> users) async {
  final ref = FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);
  final snapshot = await ref.get();
  if (!snapshot.exists) {
    await ref.set({
      'users': users,
      'updatedAt': Timestamp.now(),
    });
  }
}

/// 🔹 사용자 UID로 이름(name) 가져오기
Future<String?> getUserName(String uid) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['name'] ?? '이름 없음';
  } catch (e) {
    print('❌ 사용자 이름 가져오기 실패: $e');
    return '이름 없음';
  }
}
