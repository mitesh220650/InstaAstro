import 'package:json_annotation/json_annotation.dart';

part 'consultation_model.g.dart';

@JsonSerializable()
class ConsultationModel {
  final String id;
  final String userId;
  final String astrologerId;
  final String astrologerName;
  final String? astrologerProfilePicture;
  final String type; // chat, voice, video
  final String status; // scheduled, ongoing, completed, cancelled
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // in seconds
  final double? totalAmount;
  final double pricePerMinute;

  ConsultationModel({
    required this.id,
    required this.userId,
    required this.astrologerId,
    required this.astrologerName,
    this.astrologerProfilePicture,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    this.duration,
    this.totalAmount,
    required this.pricePerMinute,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) => _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);
}

@JsonSerializable()
class ChatMessageModel {
  final String id;
  final String consultationId;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.consultationId,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}
