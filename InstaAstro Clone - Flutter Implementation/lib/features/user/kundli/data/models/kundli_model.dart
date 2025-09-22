import 'package:json_annotation/json_annotation.dart';

part 'kundli_model.g.dart';

@JsonSerializable()
class KundliModel {
  final String ascendant;
  final String ascendantLord;
  final List<PlanetPosition> planetPositions;
  final List<HouseDetail> houseDetails;
  final List<Dasha> dashas;
  final Map<String, dynamic> generalPredictions;

  KundliModel({
    required this.ascendant,
    required this.ascendantLord,
    required this.planetPositions,
    required this.houseDetails,
    required this.dashas,
    required this.generalPredictions,
  });

  factory KundliModel.fromJson(Map<String, dynamic> json) => _$KundliModelFromJson(json);

  Map<String, dynamic> toJson() => _$KundliModelToJson(this);
}

@JsonSerializable()
class PlanetPosition {
  final String planet;
  final String sign;
  final String house;
  final double degree;
  final bool isRetrograde;

  PlanetPosition({
    required this.planet,
    required this.sign,
    required this.house,
    required this.degree,
    required this.isRetrograde,
  });

  factory PlanetPosition.fromJson(Map<String, dynamic> json) => _$PlanetPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetPositionToJson(this);
}

@JsonSerializable()
class HouseDetail {
  final int houseNumber;
  final String sign;
  final String signLord;
  final List<String> planets;

  HouseDetail({
    required this.houseNumber,
    required this.sign,
    required this.signLord,
    required this.planets,
  });

  factory HouseDetail.fromJson(Map<String, dynamic> json) => _$HouseDetailFromJson(json);

  Map<String, dynamic> toJson() => _$HouseDetailToJson(this);
}

@JsonSerializable()
class Dasha {
  final String planet;
  final DateTime startDate;
  final DateTime endDate;

  Dasha({
    required this.planet,
    required this.startDate,
    required this.endDate,
  });

  factory Dasha.fromJson(Map<String, dynamic> json) => _$DashaFromJson(json);

  Map<String, dynamic> toJson() => _$DashaToJson(this);
}

@JsonSerializable()
class BirthDetails {
  final String name;
  final DateTime dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;
  final double latitude;
  final double longitude;
  final String timezone;

  BirthDetails({
    required this.name,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory BirthDetails.fromJson(Map<String, dynamic> json) => _$BirthDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BirthDetailsToJson(this);
}
