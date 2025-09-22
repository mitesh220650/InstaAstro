import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class WalletTransactionModel {
  final String id;
  final String type; // credit, debit
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? consultationId;
  final String? astrologerId;
  final String? astrologerName;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.consultationId,
    this.astrologerId,
    this.astrologerName,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) => _$WalletTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionModelToJson(this);
}
