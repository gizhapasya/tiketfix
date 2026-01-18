import 'package:flutter/material.dart';
import 'package:tiketfix/core/app_routes.dart';
import '../../../../data/datasources/auth_remote_datasource.dart';


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
        // Save username locally
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
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: const Text('Don\'t have an account? Register'),
            )
          ],
        ),
      ),
    );
  }
}

