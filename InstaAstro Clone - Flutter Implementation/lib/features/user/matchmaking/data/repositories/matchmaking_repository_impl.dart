import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/matchmaking/data/models/matchmaking_model.dart';
import 'package:instaastro_clone/features/user/matchmaking/domain/repositories/matchmaking_repository.dart';

class MatchmakingRepositoryImpl implements MatchmakingRepository {
  final ApiClient _apiClient;

  MatchmakingRepositoryImpl(this._apiClient);

  @override
  Future<MatchmakingModel> getMatchmaking(MatchmakingRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.matchMaking,
        data: request.toJson(),
      );
      return MatchmakingModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MatchmakingRequest>> getSavedMatches() async {
    try {
      final response = await _apiClient.get('/matchmaking/saved-matches');
      
      final List<dynamic> data = response.data['matches'];
      return data.map((json) => MatchmakingRequest.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveMatch(MatchmakingRequest request) async {
    try {
      await _apiClient.post(
        '/matchmaking/save-match',
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
