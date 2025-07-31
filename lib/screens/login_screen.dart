import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2partners/core/theme/app_colors.dart';
import 'package:talk2partners/core/widgets/premium_button.dart';
import 'package:talk2partners/core/widgets/premium_text_fields.dart';
import 'package:talk2partners/screens/admin_screen.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
          ),
        );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserModel?>>(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    });
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, Color(0xFFF0F4FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Premium Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildHeader(),
                    ),
                  ),
                  const SizedBox(height: 60),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildFormContent(authState),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const Icon(
            Icons.chat_bubble_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'Talk2Partners',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isSignUp ? 'Create your account' : 'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(AsyncValue<UserModel?> authState) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          PremiumTextField(
            label: 'Email Address',
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Password Field
          PremiumTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            showVisibilityToggle: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          authState.when(
            data: (_) => PremiumButton(
              text: _isSignUp ? 'Create Account' : 'Sign In',
              onPressed: _handleAuth,
              icon: _isSignUp ? Icons.person_add : Icons.login,
            ),
            loading: () =>
                const PremiumButton(text: 'Please wait...', isLoading: true),
            error: (error, _) => Column(
              children: [
                _buildErrorContainer(error.toString()),
                const SizedBox(height: 16),
                PremiumButton(
                  text: 'Try Again',
                  onPressed: _handleAuth,
                  icon: Icons.refresh,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PremiumButton(
            text: _isSignUp ? 'Already have an account?' : 'Create new account',
            onPressed: () => setState(() => _isSignUp = !_isSignUp),
            isSecondary: true,
          ),
          const SizedBox(height: 16),
          // Admin Login Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Colors.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Administrator Access',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PremiumButton(
                  text: 'Login as ADMIN',
                  onPressed: _handleAdminLogin,
                  icon: Icons.security,
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContainer(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getErrorMessage(error),
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password.';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address.';
    } else {
      return 'Invalid Credentials';
    }
  }

  void _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    final authNotifier = ref.read(authStateProvider.notifier);
    if (_isSignUp) {
      await authNotifier.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      await authNotifier.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _handleAdminLogin() {
    // Show admin login dialog
    showDialog(
      context: context,
      builder: (context) => _buildAdminLoginDialog(),
    );
  }

  Widget _buildAdminLoginDialog() {
    final adminEmailController = TextEditingController();
    final adminPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.admin_panel_settings,
                      color: Colors.orange.shade600, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PremiumTextField(
                controller: adminEmailController,
                label: 'Admin Email',
                hint: 'Enter admin email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PremiumTextField(
                controller: adminPasswordController,
                label: 'Admin Password',
                hint: 'Enter admin password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                showVisibilityToggle: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              PremiumButton(
                text: 'Login',
                icon: Icons.security,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  if (_validateAdminCredentials(
                    adminEmailController.text.trim(),
                    adminPasswordController.text.trim(),
                  )) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('is_admin', true);

                    if (mounted) {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomeScreen(),
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Invalid Admin Credentials'),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              PremiumButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateAdminCredentials(String email, String password) {
    return email == 'admin@gmail.com' && password == 'admin123';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
