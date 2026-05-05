import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  Future<void> register() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text;
    final confirm = confirmC.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _snack("Semua field wajib diisi");
      return;
    }

    if (pass.length < 6) {
      _snack("Password minimal 6 karakter");
      return;
    }

    if (pass != confirm) {
      _snack("Konfirmasi password tidak sama");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<AuthProvider>().register(
        name: name,
        email: email,
        password: pass,
      );

      if (!mounted) return;

      _snack("Registrasi berhasil, silakan login");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      String msg = "Registrasi gagal";
      if (e.toString().toLowerCase().contains("email")) {
        msg = "Email sudah digunakan";
      }

      _snack(msg);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥 BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2196F3), // biru
                  Color.fromARGB(255, 183, 58, 166), // ungu
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 🔥 LOGO
                  Image.asset("assets/images/logo.png", height: 90),

                  const SizedBox(height: 10),

                  const Text(
                    "RakitanKU",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔥 GLASS CARD
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.1),

                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Buat akun baru",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 👤 NAME
                            TextField(
                              controller: nameC,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input("Nama", Icons.person),
                            ),

                            const SizedBox(height: 16),

                            // 📧 EMAIL
                            TextField(
                              controller: emailC,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input("Email", Icons.email),
                            ),

                            const SizedBox(height: 16),

                            // 🔒 PASSWORD
                            TextField(
                              controller: passC,
                              obscureText: _obscure,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input("Password", Icons.lock)
                                  .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() => _obscure = !_obscure);
                                      },
                                    ),
                                  ),
                            ),

                            const SizedBox(height: 16),

                            // 🔒 CONFIRM
                            TextField(
                              controller: confirmC,
                              obscureText: _obscureConfirm,
                              style: const TextStyle(color: Colors.white),
                              decoration:
                                  _input(
                                    "Konfirmasi Password",
                                    Icons.lock,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirm
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () => _obscureConfirm =
                                              !_obscureConfirm,
                                        );
                                      },
                                    ),
                                  ),
                            ),

                            const SizedBox(height: 20),

                            // 🔥 BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.deepPurple,
                                      )
                                    : const Text("Daftar"),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🔗 BACK LOGIN
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Sudah punya akun? Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
