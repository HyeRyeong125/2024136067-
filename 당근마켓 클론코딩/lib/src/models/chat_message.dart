import 'package:equatable/equatable.dart';

enum MessageType { text, image, system }

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderName,
        message,
        type,
        timestamp,
        isRead,
      ];
}
