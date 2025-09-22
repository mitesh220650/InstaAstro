import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';
import 'package:instaastro_clone/features/user/kundli/domain/repositories/kundli_repository.dart';

class KundliRepositoryImpl implements KundliRepository {
  final ApiClient _apiClient;

  KundliRepositoryImpl(this._apiClient);

  @override
  Future<KundliModel> generateKundli(BirthDetails birthDetails) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.kundli,
        data: birthDetails.toJson(),
      );
      return KundliModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BirthDetails>> getSavedProfiles() async {
    try {
      final response = await _apiClient.get('/kundli/saved-profiles');
      
      final List<dynamic> data = response.data['profiles'];
      return data.map((json) => BirthDetails.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveProfile(BirthDetails birthDetails) async {
    try {
      await _apiClient.post(
        '/kundli/save-profile',
        data: birthDetails.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
