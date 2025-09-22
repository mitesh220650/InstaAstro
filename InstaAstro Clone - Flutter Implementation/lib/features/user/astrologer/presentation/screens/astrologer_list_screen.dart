import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/providers/astrologer_provider.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/widgets/astrologer_card.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/widgets/filter_chip.dart';

class AstrologerListScreen extends ConsumerStatefulWidget {
  final String? category;

  const AstrologerListScreen({
    super.key,
    this.category,
  });

  @override
  ConsumerState<AstrologerListScreen> createState() => _AstrologerListScreenState();
}

class _AstrologerListScreenState extends ConsumerState<AstrologerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilterSheet = false;

  @override
  void initState() {
    super.initState();
    
    // Set initial category filter if provided
    if (widget.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(astrologerFilterProvider.notifier).state = 
            ref.read(astrologerFilterProvider).copyWith(category: widget.category);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFilterSheet() {
    setState(() {
      _showFilterSheet = !_showFilterSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterParams = ref.watch(astrologerFilterProvider);
    final astrologersAsync = ref.watch(astrologersProvider(filterParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search astrologers',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: 'All',
                  isSelected: filterParams.category == null,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(astrologerFilterProvider.notifier).state = 
                          filterParams.copyWith(category: null);
                    }
                  },
                ),
                FilterChip(
                  label: 'Vedic',
                  isSelected: filterParams.category == 'Vedic',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(astrologerFilterProvider.notifier).state = 
                          filterParams.copyWith(category: 'Vedic');
                    }
                  },
                ),
                FilterChip(
                  label: 'Tarot',
                  isSelected: filterParams.category == 'Tarot',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(astrologerFilterProvider.notifier).state = 
                          filterParams.copyWith(category: 'Tarot');
                    }
                  },
                ),
                FilterChip(
                  label: 'Numerology',
                  isSelected: filterParams.category == 'Numerology',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(astrologerFilterProvider.notifier).state = 
                          filterParams.copyWith(category: 'Numerology');
                    }
                  },
                ),
                FilterChip(
                  label: 'Vastu',
                  isSelected: filterParams.category == 'Vastu',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(astrologerFilterProvider.notifier).state = 
                          filterParams.copyWith(category: 'Vastu');
                    }
                  },
                ),
                FilterChip(
                  label: 'Online',
                  isSelected: filterParams.onlineOnly == true,
                  onSelected: (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(onlineOnly: selected ? true : null);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Astrologer list
          Expanded(
            child: astrologersAsync.when(
              data: (astrologers) {
                if (astrologers.isEmpty) {
                  return const Center(
                    child: Text('No astrologers found'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: astrologers.length,
                  itemBuilder: (context, index) {
                    final astrologer = astrologers[index];
                    return AstrologerCard(
                      astrologer: astrologer,
                      onTap: () {
                        context.go('/astrologer/${astrologer.id}');
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _showFilterSheet
          ? _buildFilterBottomSheet()
          : null,
    );
  }

  Widget _buildFilterBottomSheet() {
    final filterParams = ref.watch(astrologerFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleFilterSheet,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: 'Relevance',
                isSelected: filterParams.sortBy == null,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(sortBy: null);
                  }
                },
              ),
              FilterChip(
                label: 'Rating: High to Low',
                isSelected: filterParams.sortBy == 'rating_desc',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(sortBy: 'rating_desc');
                  }
                },
              ),
              FilterChip(
                label: 'Price: Low to High',
                isSelected: filterParams.sortBy == 'price_asc',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(sortBy: 'price_asc');
                  }
                },
              ),
              FilterChip(
                label: 'Price: High to Low',
                isSelected: filterParams.sortBy == 'price_desc',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(sortBy: 'price_desc');
                  }
                },
              ),
              FilterChip(
                label: 'Experience',
                isSelected: filterParams.sortBy == 'experience_desc',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(sortBy: 'experience_desc');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Availability',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilterChip(
                label: 'All',
                isSelected: filterParams.onlineOnly == null,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(astrologerFilterProvider.notifier).state = 
                        filterParams.copyWith(onlineOnly: null);
                  }
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: 'Online Now',
                isSelected: filterParams.onlineOnly == true,
                onSelected: (selected) {
                  ref.read(astrologerFilterProvider.notifier).state = 
                      filterParams.copyWith(onlineOnly: selected ? true : null);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(astrologerFilterProvider.notifier).state = AstrologerFilterParams();
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleFilterSheet,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
