import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';
import 'package:intl/intl.dart';

class DashaTable extends StatelessWidget {
  final List<Dasha> dashas;

  const DashaTable({
    super.key,
    required this.dashas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Planet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Start Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'End Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dashas.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final dasha = dashas[index];
              final isCurrentDasha = _isCurrentDasha(dasha);
              
              return Container(
                color: isCurrentDasha ? AppTheme.primaryColor.withOpacity(0.05) : null,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        dasha.planet,
                        style: TextStyle(
                          fontWeight: isCurrentDasha ? FontWeight.bold : FontWeight.normal,
                          color: isCurrentDasha ? AppTheme.primaryColor : null,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        DateFormat('dd MMM yyyy').format(dasha.startDate),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        DateFormat('dd MMM yyyy').format(dasha.endDate),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  bool _isCurrentDasha(Dasha dasha) {
    final now = DateTime.now();
    return now.isAfter(dasha.startDate) && now.isBefore(dasha.endDate);
  }
}
