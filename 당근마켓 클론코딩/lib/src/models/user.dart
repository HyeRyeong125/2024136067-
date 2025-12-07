import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String profileImagePath;
  final String location;
  final double mannerTemperature;
  final int sellCount;
  final int buyCount;

  const User({
    required this.id,
    required this.name,
    required this.profileImagePath,
    required this.location,
    required this.mannerTemperature,
    required this.sellCount,
    required this.buyCount,
  });

  User copyWith({
    String? id,
    String? name,
    String? profileImagePath,
    String? location,
    double? mannerTemperature,
    int? sellCount,
    int? buyCount,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      location: location ?? this.location,
      mannerTemperature: mannerTemperature ?? this.mannerTemperature,
      sellCount: sellCount ?? this.sellCount,
      buyCount: buyCount ?? this.buyCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profileImagePath,
        location,
        mannerTemperature,
        sellCount,
        buyCount,
      ];
}
