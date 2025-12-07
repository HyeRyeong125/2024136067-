import 'package:bamtol_market_app/src/controllers/chat_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatListController());

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.chatRoomList.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                itemCount: controller.chatRoomList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xff2F3135),
                  indent: 80,
                ),
                itemBuilder: (context, index) {
                  final chatRoom = controller.chatRoomList[index];
                  return _buildChatRoomItem(chatRoom, controller);
                },
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        '채팅',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Color(0xff868B94),
          ),
          SizedBox(height: 16),
          Text(
            '채팅 내역이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff868B94),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomItem(chatRoom, ChatListController controller) {
    return InkWell(
      onTap: () => controller.openChatRoom(chatRoom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이미지
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff2F3135),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xff868B94),
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            // 채팅 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatRoom.otherUserName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        chatRoom.lastMessageTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff868B94),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chatRoom.lastMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff868B94),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xff2F3135),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            chatRoom.productImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image,
                                color: Color(0xff868B94),
                                size: 20,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatRoom.productTitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff868B94),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              chatRoom.productPrice,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (chatRoom.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFF6F0F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chatRoom.unreadCount}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
