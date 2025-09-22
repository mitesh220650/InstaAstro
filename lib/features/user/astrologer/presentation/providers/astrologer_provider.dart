import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/astrologer/data/models/astrologer_model.dart';
import 'package:instaastro_clone/features/user/astrologer/data/repositories/astrologer_repository_impl.dart';
import 'package:instaastro_clone/features/user/astrologer/domain/repositories/astrologer_repository.dart';

final astrologerRepositoryProvider = Provider<AstrologerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AstrologerRepositoryImpl(apiClient);
});

final astrologersProvider = FutureProvider.family<List<AstrologerModel>, AstrologerFilterParams>((ref, params) async {
  final repository = ref.watch(astrologerRepositoryProvider);
  return repository.getAstrologers(
    category: params.category,
    sortBy: params.sortBy,
    onlineOnly: params.onlineOnly,
  );
});

final astrologerDetailsProvider = FutureProvider.family<AstrologerModel, String>((ref, astrologerId) async {
  final repository = ref.watch(astrologerRepositoryProvider);
  return repository.getAstrologerDetails(astrologerId);
});

final astrologerReviewsProvider = FutureProvider.family<List<AstrologerReviewModel>, String>((ref, astrologerId) async {
  final repository = ref.watch(astrologerRepositoryProvider);
  return repository.getAstrologerReviews(astrologerId);
});

class AstrologerFilterParams {
  final String? category;
  final String? sortBy;
  final bool? onlineOnly;

  AstrologerFilterParams({
    this.category,
    this.sortBy,
    this.onlineOnly,
  });

  AstrologerFilterParams copyWith({
    String? category,
    String? sortBy,
    bool? onlineOnly,
  }) {
    return AstrologerFilterParams(
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      onlineOnly: onlineOnly ?? this.onlineOnly,
    );
  }
}

final astrologerFilterProvider = StateProvider<AstrologerFilterParams>((ref) {
  return AstrologerFilterParams();
});
