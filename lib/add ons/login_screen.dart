// lib/screens/login_screen.dart
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Waktu koneksi habis'),
          );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } on TimeoutException {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koneksi lambat — coba lagi nanti')),
        );
      }
    } catch (e) {
      String message = 'Login gagal. Periksa email dan password.';

      final errStr = e.toString().toLowerCase();

      if (errStr.contains('401') ||
          errStr.contains('unauthorized') ||
          errStr.contains('invalid credentials') ||
          errStr.contains('email or password')) {
        message = 'Email atau password salah.';
      } else if (errStr.contains('socket') || errStr.contains('connection')) {
        message = 'Tidak dapat terhubung ke server.';
      } else if (errStr.contains('timeout')) {
        message = 'Waktu koneksi habis.';
      } else if (errStr.isNotEmpty && errStr != 'exception') {
        message = e.toString();
      }

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showForgotPasswordDialog() {
    const contactText =
        'Saya lupa password akun RakitanKU.\n\nNama:\nKelas:\nEmail:\n';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lupa Password'),
        content: const Text(
          'Silakan hubungi guru pengajar untuk reset password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: contactText));

              if (mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Template disalin')),
                );
              }
            },
            child: const Text('Salin'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(controller: _emailController),
            TextField(controller: _passwordController),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
