import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String price;
  final String location;
  final String timeAgo;
  final String imagePath;
  final int likeCount;
  final int chatCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.timeAgo,
    required this.imagePath,
    required this.likeCount,
    required this.chatCount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        location,
        timeAgo,
        imagePath,
        likeCount,
        chatCount,
      ];
}
