import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/screens/astrologer_list_screen.dart';
import 'package:instaastro_clone/features/user/dashboard/presentation/widgets/astrologer_category_card.dart';
import 'package:instaastro_clone/features/user/dashboard/presentation/widgets/banner_slider.dart';
import 'package:instaastro_clone/features/user/dashboard/presentation/widgets/featured_astrologer_card.dart';
import 'package:instaastro_clone/features/user/dashboard/presentation/widgets/service_card.dart';
import 'package:instaastro_clone/features/user/horoscope/presentation/screens/horoscope_screen.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/screens/kundli_screen.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/screens/matchmaking_screen.dart';
import 'package:instaastro_clone/features/user/profile/presentation/screens/profile_screen.dart';
import 'package:instaastro_clone/features/user/wallet/presentation/screens/wallet_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const AstrologerListScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Astrologers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Slider
              const BannerSlider(),
              
              // Services Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ServiceCard(
                          icon: Icons.chat,
                          title: 'Chat',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AstrologerListScreen(),
                              ),
                            );
                          },
                        ),
                        ServiceCard(
                          icon: Icons.call,
                          title: 'Call',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AstrologerListScreen(),
                              ),
                            );
                          },
                        ),
                        ServiceCard(
                          icon: Icons.videocam,
                          title: 'Video',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AstrologerListScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Astrology Tools Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Astrology Tools',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ServiceCard(
                          icon: Icons.auto_graph,
                          title: 'Kundli',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KundliScreen(),
                              ),
                            );
                          },
                        ),
                        ServiceCard(
                          icon: Icons.star,
                          title: 'Horoscope',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HoroscopeScreen(),
                              ),
                            );
                          },
                        ),
                        ServiceCard(
                          icon: Icons.favorite,
                          title: 'Matching',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MatchmakingScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Astrologer Categories
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Astrologer Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AstrologerCategoryCard(
                            title: 'Vedic',
                            image: 'images/vedic.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AstrologerListScreen(
                                    category: 'Vedic',
                                  ),
                                ),
                              );
                            },
                          ),
                          AstrologerCategoryCard(
                            title: 'Tarot',
                            image: 'images/tarot.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AstrologerListScreen(
                                    category: 'Tarot',
                                  ),
                                ),
                              );
                            },
                          ),
                          AstrologerCategoryCard(
                            title: 'Numerology',
                            image: 'images/numerology.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AstrologerListScreen(
                                    category: 'Numerology',
                                  ),
                                ),
                              );
                            },
                          ),
                          AstrologerCategoryCard(
                            title: 'Vastu',
                            image: 'images/vastu.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AstrologerListScreen(
                                    category: 'Vastu',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Featured Astrologers
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Astrologers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AstrologerListScreen(),
                              ),
                            );
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FeaturedAstrologerCard(
                            name: 'Acharya Vikram',
                            specialization: 'Vedic Astrology',
                            experience: '15 years',
                            rating: 4.8,
                            price: '₹40/min',
                            image: 'images/astrologer1.png',
                            isOnline: true,
                            onTap: () {
                              // Navigate to astrologer detail
                            },
                          ),
                          FeaturedAstrologerCard(
                            name: 'Sunita Sharma',
                            specialization: 'Tarot Reading',
                            experience: '10 years',
                            rating: 4.7,
                            price: '₹35/min',
                            image: 'images/astrologer2.png',
                            isOnline: true,
                            onTap: () {
                              // Navigate to astrologer detail
                            },
                          ),
                          FeaturedAstrologerCard(
                            name: 'Rajesh Joshi',
                            specialization: 'Numerology',
                            experience: '12 years',
                            rating: 4.6,
                            price: '₹30/min',
                            image: 'images/astrologer3.png',
                            isOnline: false,
                            onTap: () {
                              // Navigate to astrologer detail
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
