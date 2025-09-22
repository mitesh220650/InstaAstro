import 'package:json_annotation/json_annotation.dart';

part 'matchmaking_model.g.dart';

@JsonSerializable()
class MatchmakingModel {
  final int totalScore;
  final Map<String, MatchCategory> categories;
  final String conclusion;
  final List<String> recommendations;

  MatchmakingModel({
    required this.totalScore,
    required this.categories,
    required this.conclusion,
    required this.recommendations,
  });

  factory MatchmakingModel.fromJson(Map<String, dynamic> json) => _$MatchmakingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchmakingModelToJson(this);
}

@JsonSerializable()
class MatchCategory {
  final String name;
  final int score;
  final int maxScore;
  final String description;

  MatchCategory({
    required this.name,
    required this.score,
    required this.maxScore,
    required this.description,
  });

  factory MatchCategory.fromJson(Map<String, dynamic> json) => _$MatchCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MatchCategoryToJson(this);
}

@JsonSerializable()
class MatchmakingRequest {
  final String boyName;
  final DateTime boyDob;
  final String boyTob;
  final String boyPob;
  final String girlName;
  final DateTime girlDob;
  final String girlTob;
  final String girlPob;

  MatchmakingRequest({
    required this.boyName,
    required this.boyDob,
    required this.boyTob,
    required this.boyPob,
    required this.girlName,
    required this.girlDob,
    required this.girlTob,
    required this.girlPob,
  });

  factory MatchmakingRequest.fromJson(Map<String, dynamic> json) => _$MatchmakingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MatchmakingRequestToJson(this);
}
