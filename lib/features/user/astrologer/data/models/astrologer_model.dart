import 'package:json_annotation/json_annotation.dart';

part 'astrologer_model.g.dart';

@JsonSerializable()
class AstrologerModel {
  final String id;
  final String name;
  final String profilePicture;
  final List<String> specializations;
  final double rating;
  final int totalReviews;
  final String experience;
  final double pricePerMinute;
  final bool isOnline;
  final bool isBusy;
  final List<String> languages;
  final String about;
  final int totalConsultations;

  AstrologerModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.specializations,
    required this.rating,
    required this.totalReviews,
    required this.experience,
    required this.pricePerMinute,
    required this.isOnline,
    required this.isBusy,
    required this.languages,
    required this.about,
    required this.totalConsultations,
  });

  factory AstrologerModel.fromJson(Map<String, dynamic> json) => _$AstrologerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AstrologerModelToJson(this);
}

@JsonSerializable()
class AstrologerReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userProfilePicture;
  final double rating;
  final String comment;
  final DateTime createdAt;

  AstrologerReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfilePicture,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory AstrologerReviewModel.fromJson(Map<String, dynamic> json) => _$AstrologerReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$AstrologerReviewModelToJson(this);
}
