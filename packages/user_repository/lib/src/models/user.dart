import 'package:equatable/equatable.dart';

import '../entities/user_entity.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String name;

  const MyUser({
    required this.userId,
    required this.email,
    required this.name
  });

  @override
  List<Object?> get props => [userId, email, name];

  static const empty = MyUser(
    userId: '',
    email: '',
    name: ''
  );

  MyUser copyWith({
    String ? userId,
    String ? email,
    String ? name,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email:  email ?? this.email,
      name: name ?? this.name,
    );
  }

  /// getter to determine wether the current user is empty.
  bool get isEmpty => this == MyUser.empty;

  /// getter to determine wether the current user is not empty.
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email, 
      name: name
    );
  }

  static MyUser fromEntity(MyUserEntity myUserEntity) {
    return MyUser(
      userId: myUserEntity.userId,
      email: myUserEntity.email, 
      name: myUserEntity.name
    );
  }
}
