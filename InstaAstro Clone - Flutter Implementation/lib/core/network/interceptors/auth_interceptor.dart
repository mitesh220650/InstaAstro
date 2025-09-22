import 'package:dio/dio.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/core/utils/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenManager.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final dio = Dio();
      final refreshToken = await TokenManager.getRefreshToken();
      
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final response = await dio.post(
            '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
            data: {'refresh_token': refreshToken},
          );
          
          if (response.statusCode == 200) {
            final newToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];
            
            await TokenManager.saveAccessToken(newToken);
            await TokenManager.saveRefreshToken(newRefreshToken);
            
            // Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            
            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // If refresh token is also expired, logout the user
          await TokenManager.clearTokens();
          // Here you would typically navigate to the login screen
        }
      }
    }
    
    return handler.next(err);
  }
}
