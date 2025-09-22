import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';
import 'package:instaastro_clone/features/user/kundli/data/repositories/kundli_repository_impl.dart';
import 'package:instaastro_clone/features/user/kundli/domain/repositories/kundli_repository.dart';

final kundliRepositoryProvider = Provider<KundliRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return KundliRepositoryImpl(apiClient);
});

final savedProfilesProvider = FutureProvider<List<BirthDetails>>((ref) async {
  final repository = ref.watch(kundliRepositoryProvider);
  return repository.getSavedProfiles();
});

final kundliProvider = FutureProvider.family<KundliModel, BirthDetails>((ref, birthDetails) async {
  final repository = ref.watch(kundliRepositoryProvider);
  return repository.generateKundli(birthDetails);
});

final kundliStateProvider = StateNotifierProvider<KundliNotifier, KundliState>((ref) {
  final repository = ref.watch(kundliRepositoryProvider);
  return KundliNotifier(repository);
});

class KundliNotifier extends StateNotifier<KundliState> {
  final KundliRepository _repository;

  KundliNotifier(this._repository) : super(KundliState.initial());

  Future<void> generateKundli(BirthDetails birthDetails) async {
    state = state.copyWith(isLoading: true);
    try {
      final kundli = await _repository.generateKundli(birthDetails);
      state = state.copyWith(
        kundli: kundli,
        birthDetails: birthDetails,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> saveProfile(BirthDetails birthDetails) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.saveProfile(birthDetails);
      state = state.copyWith(
        isLoading: false,
        birthDetails: birthDetails,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetState() {
    state = KundliState.initial();
  }
}

class KundliState {
  final KundliModel? kundli;
  final BirthDetails? birthDetails;
  final bool isLoading;
  final String? error;

  KundliState({
    this.kundli,
    this.birthDetails,
    required this.isLoading,
    this.error,
  });

  factory KundliState.initial() {
    return KundliState(
      isLoading: false,
    );
  }

  KundliState copyWith({
    KundliModel? kundli,
    BirthDetails? birthDetails,
    bool? isLoading,
    String? error,
  }) {
    return KundliState(
      kundli: kundli ?? this.kundli,
      birthDetails: birthDetails ?? this.birthDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
