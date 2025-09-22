import 'package:instaastro_clone/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(Map<String, dynamic> userData);
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
}
