import 'package:instaastro_clone/features/user/wallet/data/models/wallet_model.dart';

abstract class WalletRepository {
  Future<double> getWalletBalance();
  Future<List<WalletTransactionModel>> getTransactionHistory();
  Future<void> addMoney(double amount, String paymentId);
}
