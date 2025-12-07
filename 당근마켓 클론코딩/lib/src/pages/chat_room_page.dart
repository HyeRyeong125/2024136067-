import 'package:bamtol_market_app/src/controllers/chat_room_controller.dart';
import 'package:bamtol_market_app/src/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatRoomController());
    final args = Get.arguments as Map<String, dynamic>?;
    final sellerName = args?['sellerName'] ?? '판매자';

    return Scaffold(
      appBar: _buildAppBar(sellerName),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageItem(message);
                },
              ),
            ),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String sellerName) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2F3135),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xff868B94),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            sellerName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final isMyMessage = message.senderId == 'me';
    final timeFormat = DateFormat('a h:mm', 'ko_KR');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2F3135),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xff868B94),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isMyMessage) ...[
            Text(
              timeFormat.format(message.timestamp),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff868B94),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMyMessage
                    ? const Color(0xffFF6F0F)
                    : const Color(0xff2F3135),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (!isMyMessage) ...[
            const SizedBox(width: 8),
            Text(
              timeFormat.format(message.timestamp),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff868B94),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatRoomController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff212123),
        border: Border(
          top: BorderSide(color: Color(0xff2F3135), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  onChanged: controller.onMessageChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '메시지를 입력하세요',
                    hintStyle: const TextStyle(color: Color(0xff868B94)),
                    filled: true,
                    fillColor: const Color(0xff2F3135),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => IconButton(
                  icon: Icon(
                    Icons.send,
                    color: controller.messageText.value.trim().isEmpty
                        ? const Color(0xff868B94)
                        : const Color(0xffFF6F0F),
                  ),
                  onPressed: controller.messageText.value.trim().isEmpty
                      ? null
                      : controller.sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
