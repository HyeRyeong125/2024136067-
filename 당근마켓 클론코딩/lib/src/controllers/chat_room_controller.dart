import 'package:bamtol_market_app/src/models/chat_message.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString messageText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMessages();
  }

  void _loadMessages() {
    messages.value = [
      ChatMessage(
        id: '1',
        senderId: 'other',
        senderName: '판매자',
        message: '안녕하세요! 상품에 관심 가져주셔서 감사합니다.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'me',
        senderName: '나',
        message: '안녕하세요. 직거래 가능한가요?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'other',
        senderName: '판매자',
        message: '네, 직거래 가능합니다! 어디가 편하신가요?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        senderId: 'me',
        senderName: '나',
        message: '강남역 근처는 어떠신가요?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
        isRead: true,
      ),
    ];
  }

  void sendMessage() {
    if (messageText.value.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: '나',
      message: messageText.value,
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(newMessage);
    messageText.value = '';
  }

  void onMessageChanged(String value) {
    messageText.value = value;
  }
}
