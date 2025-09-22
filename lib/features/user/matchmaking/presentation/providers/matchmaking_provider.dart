import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/matchmaking/data/models/matchmaking_model.dart';
import 'package:instaastro_clone/features/user/matchmaking/data/repositories/matchmaking_repository_impl.dart';
import 'package:instaastro_clone/features/user/matchmaking/domain/repositories/matchmaking_repository.dart';

final matchmakingRepositoryProvider = Provider<MatchmakingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MatchmakingRepositoryImpl(apiClient);
});

final savedMatchesProvider = FutureProvider<List<MatchmakingRequest>>((ref) async {
  final repository = ref.watch(matchmakingRepositoryProvider);
  return repository.getSavedMatches();
});

final matchmakingProvider = FutureProvider.family<MatchmakingModel, MatchmakingRequest>((ref, request) async {
  final repository = ref.watch(matchmakingRepositoryProvider);
  return repository.getMatchmaking(request);
});

final matchmakingStateProvider = StateNotifierProvider<MatchmakingNotifier, MatchmakingState>((ref) {
  final repository = ref.watch(matchmakingRepositoryProvider);
  return MatchmakingNotifier(repository);
});

class MatchmakingNotifier extends StateNotifier<MatchmakingState> {
  final MatchmakingRepository _repository;

  MatchmakingNotifier(this._repository) : super(MatchmakingState.initial());

  Future<void> getMatchmaking(MatchmakingRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.getMatchmaking(request);
      state = state.copyWith(
        matchResult: result,
        request: request,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> saveMatch(MatchmakingRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.saveMatch(request);
      state = state.copyWith(
        isLoading: false,
        request: request,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetState() {
    state = MatchmakingState.initial();
  }
}

class MatchmakingState {
  final MatchmakingModel? matchResult;
  final MatchmakingRequest? request;
  final bool isLoading;
  final String? error;

  MatchmakingState({
    this.matchResult,
    this.request,
    required this.isLoading,
    this.error,
  });

  factory MatchmakingState.initial() {
    return MatchmakingState(
      isLoading: false,
    );
  }

  MatchmakingState copyWith({
    MatchmakingModel? matchResult,
    MatchmakingRequest? request,
    bool? isLoading,
    String? error,
  }) {
    return MatchmakingState(
      matchResult: matchResult ?? this.matchResult,
      request: request ?? this.request,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
