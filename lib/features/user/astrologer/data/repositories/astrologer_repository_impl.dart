import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/astrologer/data/models/astrologer_model.dart';
import 'package:instaastro_clone/features/user/astrologer/domain/repositories/astrologer_repository.dart';

class AstrologerRepositoryImpl implements AstrologerRepository {
  final ApiClient _apiClient;

  AstrologerRepositoryImpl(this._apiClient);

  @override
  Future<List<AstrologerModel>> getAstrologers({
    String? category,
    String? sortBy,
    bool? onlineOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (category != null) {
        queryParams['category'] = category;
      }
      
      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }
      
      if (onlineOnly != null) {
        queryParams['online_only'] = onlineOnly.toString();
      }
      
      final response = await _apiClient.get(
        ApiConstants.astrologers,
        queryParameters: queryParams,
      );
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => AstrologerModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AstrologerModel> getAstrologerDetails(String astrologerId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.astrologerDetail}$astrologerId');
      return AstrologerModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AstrologerReviewModel>> getAstrologerReviews(String astrologerId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.astrologerReviews}$astrologerId');
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => AstrologerReviewModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> submitAstrologerReview(
    String astrologerId,
    double rating,
    String comment,
  ) async {
    try {
      await _apiClient.post(
        '${ApiConstants.astrologerReviews}$astrologerId',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
