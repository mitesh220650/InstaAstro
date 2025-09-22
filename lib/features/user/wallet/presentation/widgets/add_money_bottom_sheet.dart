import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/wallet/presentation/providers/wallet_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoneyBottomSheet extends ConsumerStatefulWidget {
  const AddMoneyBottomSheet({super.key});

  @override
  ConsumerState<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
}

class _AddMoneyBottomSheetState extends ConsumerState<AddMoneyBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Razorpay _razorpay;
  bool _isProcessing = false;
  
  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Add money to wallet
    final amount = double.parse(_amountController.text);
    ref.read(walletProvider.notifier).addMoney(amount, response.paymentId!);
    
    // Close bottom sheet
    Navigator.pop(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful: ₹${amount.toStringAsFixed(2)} added to wallet'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessing = false;
    });
    
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
      ),
    );
  }

  void _openRazorpayCheckout() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      
      final amount = double.parse(_amountController.text);
      
      // Razorpay accepts amount in paise (1 INR = 100 paise)
      final options = {
        'key': 'rzp_test_YOUR_KEY_HERE', // Replace with your Razorpay key
        'amount': (amount * 100).toInt(),
        'name': 'InstaAstro',
        'description': 'Add money to wallet',
        'prefill': {
          'contact': '9876543210', // Replace with user's phone number
          'email': 'user@example.com', // Replace with user's email
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      
      try {
        _razorpay.open(options);
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Add Money to Wallet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Enter Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    hintText: 'Amount',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid amount';
                    }
                    if (amount < 100) {
                      return 'Minimum amount is ₹100';
                    }
                    if (amount > 10000) {
                      return 'Maximum amount is ₹10,000';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quick Select',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickAmounts.map((amount) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _amountController.text = amount.toString();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          '₹${amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _openRazorpayCheckout,
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Proceed to Payment'),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Secured by Razorpay',
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
