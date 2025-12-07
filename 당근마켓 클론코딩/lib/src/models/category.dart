import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String iconPath;

  const Category({
    required this.id,
    required this.name,
    required this.iconPath,
  });

  @override
  List<Object?> get props => [id, name, iconPath];
}
