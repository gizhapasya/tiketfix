import 'package:flutter/material.dart';
import 'package:tiketfix/core/app_routes.dart';
import '../../../../data/datasources/auth_remote_datasource.dart';
import 'package:tiketfix/core/theme/app_colors.dart';
import 'package:tiketfix/core/theme/app_text_styles.dart';
import 'package:tiketfix/presentation/widgets/custom_button.dart';
import 'package:tiketfix/presentation/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _authDataSource = AuthRemoteDataSource();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authDataSource.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        String role = 'user';

        if (result['data'] != null) {
            String? username = result['data']['username'];
            if (username != null) await prefs.setString('username', username);
            
            if (result['data']['role'] != null) {
               role = result['data']['role'];
               await prefs.setString('role', role);
            }
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login Successful')),
        );

        if (!mounted) return;

        if (role == 'admin') {
           Navigator.pushReplacementNamed(context, '/admin_scan');
        } else {
           Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.movie_filter_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'TicketFix',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(
                'Your bridge to cinematic experiences',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 48),
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Don\'t have an account? ', style: AppTextStyles.bodySmall),
                   GestureDetector(
                     onTap: () {
                       Navigator.pushNamed(context, AppRoutes.register);
                     },
                     child: Text(
                       'Register',
                       style: AppTextStyles.bodySmall.copyWith(
                         color: AppColors.primary,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
