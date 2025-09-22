import 'package:instaastro_clone/features/user/astrologer/data/models/astrologer_model.dart';

abstract class AstrologerRepository {
  Future<List<AstrologerModel>> getAstrologers({
    String? category,
    String? sortBy,
    bool? onlineOnly,
  });
  
  Future<AstrologerModel> getAstrologerDetails(String astrologerId);
  
  Future<List<AstrologerReviewModel>> getAstrologerReviews(String astrologerId);
  
  Future<void> submitAstrologerReview(
    String astrologerId,
    double rating,
    String comment,
  );
}
