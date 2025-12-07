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
        productTitle: '애플워치 7세대 팝니다',
        productPrice: '350,000원',
        productImagePath: 'assets/images/sample_product_1.jpg',
        otherUserName: '김철수',
        otherUserProfileImage: '',
        lastMessage: '네, 직거래 가능합니다!',
        lastMessageTime: '오후 2:30',
        unreadCount: 2,
      ),
      const ChatRoom(
        id: '2',
        productId: '2',
        productTitle: '아이폰 14 프로 256GB',
        productPrice: '1,200,000원',
        productImagePath: 'assets/images/sample_product_2.jpg',
        otherUserName: '이영희',
        otherUserProfileImage: '',
        lastMessage: '가격 조정 가능할까요?',
        lastMessageTime: '오후 1:15',
        unreadCount: 0,
      ),
      const ChatRoom(
        id: '3',
        productId: '3',
        productTitle: '맥북 프로 16인치 M1',
        productPrice: '2,500,000원',
        productImagePath: 'assets/images/sample_product_3.jpg',
        otherUserName: '박민수',
        otherUserProfileImage: '',
        lastMessage: '내일 오전에 만날 수 있을까요?',
        lastMessageTime: '오전 11:20',
        unreadCount: 1,
      ),
      const ChatRoom(
        id: '4',
        productId: '4',
        productTitle: '에어팟 프로 2세대',
        productPrice: '200,000원',
        productImagePath: 'assets/images/sample_product_4.jpg',
        otherUserName: '정수진',
        otherUserProfileImage: '',
        lastMessage: '감사합니다~',
        lastMessageTime: '어제',
        unreadCount: 0,
      ),
      const ChatRoom(
        id: '5',
        productId: '5',
        productTitle: '아이패드 프로 11인치',
        productPrice: '800,000원',
        productImagePath: 'assets/images/sample_product_5.jpg',
        otherUserName: '최동욱',
        otherUserProfileImage: '',
        lastMessage: '사진 더 보내주실 수 있나요?',
        lastMessageTime: '어제',
        unreadCount: 3,
      ),
    ];
  }

  void openChatRoom(ChatRoom chatRoom) {
    Get.toNamed('/chat-room', arguments: {
      'chatRoom': chatRoom,
    });
  }
}
