import 'package:instaastro_clone/features/user/horoscope/data/models/horoscope_model.dart';

abstract class HoroscopeRepository {
  Future<HoroscopeModel> getDailyHoroscope(ZodiacSign sign);
  Future<HoroscopeModel> getWeeklyHoroscope(ZodiacSign sign);
  Future<HoroscopeModel> getMonthlyHoroscope(ZodiacSign sign);
}
