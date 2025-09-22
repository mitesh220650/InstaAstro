import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? profilePicture;
  final DateTime dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;
  final String? gender;
  final double walletBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.profilePicture,
    required this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
    this.gender,
    required this.walletBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    DateTime? dateOfBirth,
    String? timeOfBirth,
    String? placeOfBirth,
    String? gender,
    double? walletBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      timeOfBirth: timeOfBirth ?? this.timeOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      gender: gender ?? this.gender,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
