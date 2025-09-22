import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/horoscope/data/models/horoscope_model.dart';
import 'package:instaastro_clone/features/user/horoscope/domain/repositories/horoscope_repository.dart';

class HoroscopeRepositoryImpl implements HoroscopeRepository {
  final ApiClient _apiClient;

  HoroscopeRepositoryImpl(this._apiClient);

  @override
  Future<HoroscopeModel> getDailyHoroscope(ZodiacSign sign) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.dailyHoroscope}${sign.name.toLowerCase()}',
      );
      return HoroscopeModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HoroscopeModel> getWeeklyHoroscope(ZodiacSign sign) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.weeklyHoroscope}${sign.name.toLowerCase()}',
      );
      return HoroscopeModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HoroscopeModel> getMonthlyHoroscope(ZodiacSign sign) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.monthlyHoroscope}${sign.name.toLowerCase()}',
      );
      return HoroscopeModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
