import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/horoscope/data/models/horoscope_model.dart';
import 'package:instaastro_clone/features/user/horoscope/data/repositories/horoscope_repository_impl.dart';
import 'package:instaastro_clone/features/user/horoscope/domain/repositories/horoscope_repository.dart';

final horoscopeRepositoryProvider = Provider<HoroscopeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HoroscopeRepositoryImpl(apiClient);
});

final selectedZodiacSignProvider = StateProvider<ZodiacSign>((ref) {
  return ZodiacSign.aries;
});

final selectedHoroscopeTypeProvider = StateProvider<HoroscopeType>((ref) {
  return HoroscopeType.daily;
});

final horoscopeProvider = FutureProvider.family<HoroscopeModel, HoroscopeParams>((ref, params) async {
  final repository = ref.watch(horoscopeRepositoryProvider);
  
  switch (params.type) {
    case HoroscopeType.daily:
      return repository.getDailyHoroscope(params.sign);
    case HoroscopeType.weekly:
      return repository.getWeeklyHoroscope(params.sign);
    case HoroscopeType.monthly:
      return repository.getMonthlyHoroscope(params.sign);
  }
});

class HoroscopeParams {
  final ZodiacSign sign;
  final HoroscopeType type;

  HoroscopeParams({
    required this.sign,
    required this.type,
  });
}
