class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.instaastro-clone.com/api/v1';
  static const String astrologyApiBaseUrl = 'https://api.astrologyapi.com/v1';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile/update';
  
  // Astrologer endpoints
  static const String astrologers = '/astrologers';
  static const String astrologerDetail = '/astrologers/';
  static const String astrologerReviews = '/astrologers/reviews/';
  
  // Wallet endpoints
  static const String wallet = '/wallet';
  static const String walletTransactions = '/wallet/transactions';
  static const String addMoney = '/wallet/add-money';
  
  // Consultation endpoints
  static const String consultations = '/consultations';
  static const String startConsultation = '/consultations/start';
  static const String endConsultation = '/consultations/end';
  static const String consultationHistory = '/consultations/history';
  
  // Astrology API endpoints
  static const String kundli = '/horoscope/birth-details';
  static const String dailyHoroscope = '/horoscope/daily/sun_sign/';
  static const String weeklyHoroscope = '/horoscope/weekly/sun_sign/';
  static const String monthlyHoroscope = '/horoscope/monthly/sun_sign/';
  static const String matchMaking = '/compatibility/';
  
  // Agora endpoints
  static const String generateAgoraToken = '/agora/token';
}
