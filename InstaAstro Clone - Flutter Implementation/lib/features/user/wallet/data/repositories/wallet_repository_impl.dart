import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/wallet/data/models/wallet_model.dart';
import 'package:instaastro_clone/features/user/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final ApiClient _apiClient;

  WalletRepositoryImpl(this._apiClient);

  @override
  Future<double> getWalletBalance() async {
    try {
      final response = await _apiClient.get(ApiConstants.wallet);
      return response.data['balance'].toDouble();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    try {
      final response = await _apiClient.get(ApiConstants.walletTransactions);
      
      final List<dynamic> data = response.data['transactions'];
      return data.map((json) => WalletTransactionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addMoney(double amount, String paymentId) async {
    try {
      await _apiClient.post(
        ApiConstants.addMoney,
        data: {
          'amount': amount,
          'payment_id': paymentId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
