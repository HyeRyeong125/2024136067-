import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productImagePath;
  final String otherUserName;
  final String otherUserProfileImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productImagePath,
    required this.otherUserName,
    required this.otherUserProfileImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productTitle,
        productPrice,
        productImagePath,
        otherUserName,
        otherUserProfileImage,
        lastMessage,
        lastMessageTime,
        unreadCount,
      ];
}
