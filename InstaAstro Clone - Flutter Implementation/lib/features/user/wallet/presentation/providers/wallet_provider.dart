import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/wallet/data/models/wallet_model.dart';
import 'package:instaastro_clone/features/user/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:instaastro_clone/features/user/wallet/domain/repositories/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepositoryImpl(apiClient);
});

final walletBalanceProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.getWalletBalance();
});

final transactionHistoryProvider = FutureProvider<List<WalletTransactionModel>>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.getTransactionHistory();
});

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return WalletNotifier(repository);
});

class WalletNotifier extends StateNotifier<WalletState> {
  final WalletRepository _repository;

  WalletNotifier(this._repository) : super(WalletState.initial()) {
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    state = state.copyWith(isLoading: true);
    try {
      final balance = await _repository.getWalletBalance();
      final transactions = await _repository.getTransactionHistory();
      
      state = state.copyWith(
        balance: balance,
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshWalletData() async {
    await _loadWalletData();
  }

  Future<void> addMoney(double amount, String paymentId) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.addMoney(amount, paymentId);
      await _loadWalletData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class WalletState {
  final double balance;
  final List<WalletTransactionModel> transactions;
  final bool isLoading;
  final String? error;

  WalletState({
    required this.balance,
    required this.transactions,
    required this.isLoading,
    this.error,
  });

  factory WalletState.initial() {
    return WalletState(
      balance: 0.0,
      transactions: [],
      isLoading: false,
    );
  }

  WalletState copyWith({
    double? balance,
    List<WalletTransactionModel>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
