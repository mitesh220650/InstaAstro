import 'package:json_annotation/json_annotation.dart';

part 'horoscope_model.g.dart';

@JsonSerializable()
class HoroscopeModel {
  final String sunSign;
  final String date;
  final String prediction;
  final int luckNumber;
  final String luckColor;
  final String luckTime;
  final String mood;

  HoroscopeModel({
    required this.sunSign,
    required this.date,
    required this.prediction,
    required this.luckNumber,
    required this.luckColor,
    required this.luckTime,
    required this.mood,
  });

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) => _$HoroscopeModelFromJson(json);

  Map<boltAction type="file" filePath="lib/features/user/horoscope/data/models/horoscope_model.dart">
  Map<String, dynamic> toJson() => _$HoroscopeModelToJson(this);
}

enum HoroscopeType {
  daily,
  weekly,
  monthly
}

extension HoroscopeTypeExtension on HoroscopeType {
  String get name {
    switch (this) {
      case HoroscopeType.daily:
        return 'Daily';
      case HoroscopeType.weekly:
        return 'Weekly';
      case HoroscopeType.monthly:
        return 'Monthly';
    }
  }
}

enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces
}

extension ZodiacSignExtension on ZodiacSign {
  String get name {
    switch (this) {
      case ZodiacSign.aries:
        return 'Aries';
      case ZodiacSign.taurus:
        return 'Taurus';
      case ZodiacSign.gemini:
        return 'Gemini';
      case ZodiacSign.cancer:
        return 'Cancer';
      case ZodiacSign.leo:
        return 'Leo';
      case ZodiacSign.virgo:
        return 'Virgo';
      case ZodiacSign.libra:
        return 'Libra';
      case ZodiacSign.scorpio:
        return 'Scorpio';
      case ZodiacSign.sagittarius:
        return 'Sagittarius';
      case ZodiacSign.capricorn:
        return 'Capricorn';
      case ZodiacSign.aquarius:
        return 'Aquarius';
      case ZodiacSign.pisces:
        return 'Pisces';
    }
  }

  String get dateRange {
    switch (this) {
      case ZodiacSign.aries:
        return 'Mar 21 - Apr 19';
      case ZodiacSign.taurus:
        return 'Apr 20 - May 20';
      case ZodiacSign.gemini:
        return 'May 21 - Jun 20';
      case ZodiacSign.cancer:
        return 'Jun 21 - Jul 22';
      case ZodiacSign.leo:
        return 'Jul 23 - Aug 22';
      case ZodiacSign.virgo:
        return 'Aug 23 - Sep 22';
      case ZodiacSign.libra:
        return 'Sep 23 - Oct 22';
      case ZodiacSign.scorpio:
        return 'Oct 23 - Nov 21';
      case ZodiacSign.sagittarius:
        return 'Nov 22 - Dec 21';
      case ZodiacSign.capricorn:
        return 'Dec 22 - Jan 19';
      case ZodiacSign.aquarius:
        return 'Jan 20 - Feb 18';
      case ZodiacSign.pisces:
        return 'Feb 19 - Mar 20';
    }
  }

  String get icon {
    return 'images/zodiac/${name.toLowerCase()}.png';
  }
}
