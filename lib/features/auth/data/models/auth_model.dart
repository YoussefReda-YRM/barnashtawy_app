import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.uId,
    required super.phoneNumber,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
      phoneNumber: user.phoneNumber ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      uId: json['uId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      name: user.name,
      email: user.email,
      uId: user.uId,
      phoneNumber: user.phoneNumber,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'phoneNumber': phoneNumber,
    };
  }
}