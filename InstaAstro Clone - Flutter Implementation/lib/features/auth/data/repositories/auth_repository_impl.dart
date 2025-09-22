import 'package:dio/dio.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/core/utils/token_manager.dart';
import 'package:instaastro_clone/features/auth/data/models/user_model.dart';
import 'package:instaastro_clone/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'phone_number': phoneNumber},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyOtp,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens
        await TokenManager.saveAccessToken(data['access_token']);
        await TokenManager.saveRefreshToken(data['refresh_token']);
        
        // Return user data
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.userProfile);
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.updateUserProfile,
        data: userData,
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
      await TokenManager.clearTokens();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return TokenManager.isLoggedIn();
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // This would be implemented with Firebase Auth
      // For now, we'll just mock the response
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'provider': 'google'},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens
        await TokenManager.saveAccessToken(data['access_token']);
        await TokenManager.saveRefreshToken(data['refresh_token']);
        
        // Return user data
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    try {
      // This would be implemented with Firebase Auth
      // For now, we'll just mock the response
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'provider': 'facebook'},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens
        await TokenManager.saveAccessToken(data['access_token']);
        await TokenManager.saveRefreshToken(data['refresh_token']);
        
        // Return user data
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('Failed to sign in with Facebook');
      }
    } catch (e) {
      rethrow;
    }
  }
}
