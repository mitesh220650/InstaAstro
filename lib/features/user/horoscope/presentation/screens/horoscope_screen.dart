import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/horoscope/data/models/horoscope_model.dart';
import 'package:instaastro_clone/features/user/horoscope/presentation/providers/horoscope_provider.dart';
import 'package:instaastro_clone/features/user/horoscope/presentation/widgets/zodiac_sign_card.dart';

class HoroscopeScreen extends ConsumerWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSign = ref.watch(selectedZodiacSignProvider);
    final selectedType = ref.watch(selectedHoroscopeTypeProvider);
    
    final horoscopeAsync = ref.watch(horoscopeProvider(
      HoroscopeParams(sign: selectedSign, type: selectedType),
    ));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Horoscope'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zodiac sign selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Your Zodiac Sign',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: ZodiacSign.values.map((sign) {
                      return ZodiacSignCard(
                        sign: sign,
                        isSelected: selectedSign == sign,
                        onTap: () {
                          ref.read(selectedZodiacSignProvider.notifier).state = sign;
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Horoscope type selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildTypeSelector(
                    context,
                    type: HoroscopeType.daily,
                    selectedType: selectedType,
                    onTap: () {
                      ref.read(selectedHoroscopeTypeProvider.notifier).state = HoroscopeType.daily;
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildTypeSelector(
                    context,
                    type: HoroscopeType.weekly,
                    selectedType: selectedType,
                    onTap: () {
                      ref.read(selectedHoroscopeTypeProvider.notifier).state = HoroscopeType.weekly;
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildTypeSelector(
                    context,
                    type: HoroscopeType.monthly,
                    selectedType: selectedType,
                    onTap: () {
                      ref.read(selectedHoroscopeTypeProvider.notifier).state = HoroscopeType.monthly;
                    },
                  ),
                ],
              ),
            ),
            
            // Horoscope content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        selectedSign.icon,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedSign.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            selectedSign.dateRange,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  horoscopeAsync.when(
                    data: (horoscope) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selectedType.name} Horoscope - ${horoscope.date}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            horoscope.prediction,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow(
                            'Lucky Number',
                            horoscope.luckNumber.toString(),
                            Icons.format_list_numbered,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Lucky Color',
                            horoscope.luckColor,
                            Icons.color_lens,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Lucky Time',
                            horoscope.luckTime,
                            Icons.access_time,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Mood',
                            horoscope.mood,
                            Icons.mood,
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text('Error: ${error.toString()}'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTypeSelector(
    BuildContext context, {
    required HoroscopeType type,
    required HoroscopeType selectedType,
    required VoidCallback onTap,
  }) {
    final isSelected = type == selectedType;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            ),
          ),
          child: Text(
            type.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
