import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  void login() async {
  final auth = context.read<AuthProvider>();

  print("=== LOGIN START ===");
  print("Email: ${emailC.text}");
  print("Password: ${passC.text}");

  try {
    await auth.login(emailC.text, passC.text);

    print("✅ LOGIN SUCCESS");
    print("User: ${auth.user?.name}");
    print("Email: ${auth.user?.email}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );

  } catch (e) {
    print("❌ LOGIN ERROR");
    print("Error: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login gagal: $e")),
    );
  }

  print("=== LOGIN END ===");
}

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "E-Learning",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: "Email"),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : login,
                    child: auth.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}