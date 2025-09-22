import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';

abstract class KundliRepository {
  Future<KundliModel> generateKundli(BirthDetails birthDetails);
  Future<List<BirthDetails>> getSavedProfiles();
  Future<void> saveProfile(BirthDetails birthDetails);
}
