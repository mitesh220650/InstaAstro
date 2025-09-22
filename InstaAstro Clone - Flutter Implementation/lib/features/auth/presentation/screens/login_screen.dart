import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/auth/presentation/providers/auth_provider.dart';
import 'package:instaastro_clone/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await ref.read(authStateProvider.notifier).sendOtp(_phoneController.text);
      
      final authState = ref.read(authStateProvider);
      
      setState(() {
        _isLoading = false;
      });
      
      if (authState.otpSent) {
        if (mounted) {
          context.go('/otp-verification?phoneNumber=${_phoneController.text}');
        }
      } else if (authState.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error!)),
          );
        }
      }
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    await ref.read(authStateProvider.notifier).signInWithGoogle();
    
    final authState = ref.read(authStateProvider);
    
    setState(() {
      _isLoading = false;
    });
    
    if (authState.isAuthenticated) {
      if (mounted) {
        context.go('/dashboard');
      }
    } else if (authState.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
      }
    }
  }

  void _signInWithFacebook() async {
    setState(() {
      _isLoading = true;
    });

    await ref.read(authStateProvider.notifier).signInWithFacebook();
    
    final authState = ref.read(authStateProvider);
    
    setState(() {
      _isLoading = false;
    });
    
    if (authState.isAuthenticated) {
      if (mounted) {
        context.go('/dashboard');
      }
    } else if (authState.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // App Logo
                  Center(
                    child: Image.asset(
                      'images/logo.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome to InstaAstro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Phone number input
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter your phone number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Continue'),
                  ),
                  const SizedBox(height: 24),
                  // OR divider
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: AppTheme.secondaryTextColor),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social login buttons
                  SocialLoginButton(
                    text: 'Continue with Google',
                    icon: 'images/google_icon.png',
                    onPressed: _signInWithGoogle,
                  ),
                  const SizedBox(height: 16),
                  SocialLoginButton(
                    text: 'Continue with Facebook',
                    icon: 'images/facebook_icon.png',
                    onPressed: _signInWithFacebook,
                  ),
                  const SizedBox(height: 24),
                  // Terms and conditions
                  const Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
