import 'package:bamtol_market_app/src/models/chat_room.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  final RxList<ChatRoom> chatRoomList = <ChatRoom>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    chatRoomList.value = [
      const ChatRoom(
        id: '1',
        productId: '1',
        productTitle: '블레이저 판매합니다.',
        productPrice: '36,000원',
        productImagePath: 'assets/images/Blazer.png',
        otherUserName: '이용민',
        otherUserProfileImage: '',
        lastMessage: '직거래 가능합니다',
        lastMessageTime: '오후 5:30',
        unreadCount: 1,
      ),
      const ChatRoom(
        id: '2',
        productId: '2',
        productTitle: 'MTB 자전거 급처합니다.',
        productPrice: '200,000원',
        productImagePath: 'assets/images/MTB_Bike.png',
        otherUserName: '김서현',
        otherUserProfileImage: '',
        lastMessage: '쿨거 가능하세요?',
        lastMessageTime: '오후 3:25',
        unreadCount: 2,
      ),
    ];
  }

  void openChatRoom(ChatRoom chatRoom) {
    Get.toNamed('/chat-room', arguments: {
      'chatRoom': chatRoom,
    });
  }
}
