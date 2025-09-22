import 'package:instaastro_clone/features/user/matchmaking/data/models/matchmaking_model.dart';

abstract class MatchmakingRepository {
  Future<MatchmakingModel> getMatchmaking(MatchmakingRequest request);
  Future<List<MatchmakingRequest>> getSavedMatches();
  Future<void> saveMatch(MatchmakingRequest request);
}
