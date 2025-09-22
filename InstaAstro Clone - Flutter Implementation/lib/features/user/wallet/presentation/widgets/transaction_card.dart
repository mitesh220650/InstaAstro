import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/wallet/data/models/wallet_model.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final WalletTransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'credit';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.add : Icons.remove,
              color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(transaction.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                if (transaction.astrologerName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Astrologer: ${transaction.astrologerName}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
