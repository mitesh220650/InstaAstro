import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instaastro_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:instaastro_clone/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:instaastro_clone/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:instaastro_clone/features/auth/presentation/screens/splash_screen.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/screens/astrologer_detail_screen.dart';
import 'package:instaastro_clone/features/user/astrologer/presentation/screens/astrologer_list_screen.dart';
import 'package:instaastro_clone/features/user/consultation/presentation/screens/chat_consultation_screen.dart';
import 'package:instaastro_clone/features/user/consultation/presentation/screens/video_call_screen.dart';
import 'package:instaastro_clone/features/user/consultation/presentation/screens/voice_call_screen.dart';
import 'package:instaastro_clone/features/user/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:instaastro_clone/features/user/horoscope/presentation/screens/horoscope_screen.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/screens/kundli_screen.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/screens/matchmaking_screen.dart';
import 'package:instaastro_clone/features/user/profile/presentation/screens/profile_screen.dart';
import 'package:instaastro_clone/features/user/wallet/presentation/screens/transaction_history_screen.dart';
import 'package:instaastro_clone/features/user/wallet/presentation/screens/wallet_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Common routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final phoneNumber = state.queryParameters['phoneNumber'] ?? '';
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      
      // User app routes
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/astrologers',
        builder: (context, state) => const AstrologerListScreen(),
      ),
      GoRoute(
        path: '/astrologer/:id',
        builder: (context, state) {
          final astrologerId = state.pathParameters['id'] ?? '';
          return AstrologerDetailScreen(astrologerId: astrologerId);
        },
      ),
      GoRoute(
        path: '/chat/:astrologerId',
        builder: (context, state) {
          final astrologerId = state.pathParameters['astrologerId'] ?? '';
          return ChatConsultationScreen(astrologerId: astrologerId);
        },
      ),
      GoRoute(
        path: '/voice-call/:astrologerId',
        builder: (context, state) {
          final astrologerId = state.pathParameters['astrologerId'] ?? '';
          return VoiceCallScreen(astrologerId: astrologerId);
        },
      ),
      GoRoute(
        path: '/video-call/:astrologerId',
        builder: (context, state) {
          final astrologerId = state.pathParameters['astrologerId'] ?? '';
          return VideoCallScreen(astrologerId: astrologerId);
        },
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/kundli',
        builder: (context, state) => const KundliScreen(),
      ),
      GoRoute(
        path: '/horoscope',
        builder: (context, state) => const HoroscopeScreen(),
      ),
      GoRoute(
        path: '/matchmaking',
        builder: (context, state) => const MatchmakingScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.location}'),
      ),
    ),
  );
});
