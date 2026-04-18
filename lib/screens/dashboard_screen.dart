import 'package:flutter/material.dart';
import 'package:media_interactive/screens/quiz_list_screen.dart';
import 'package:media_interactive/screens/simulasi_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'materi_screen.dart';
import 'video_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    // 🔥 ambil user
    Future.microtask(() {
      context.read<AuthProvider>().fetchMe();
    });

    // 🔥 tampilkan dialog setelah build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showChallengeDialog();
    });
  }

  void _showChallengeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tantangan Praktik",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              """Pada saat praktik di laboratorium jaringan, sebuah komputer tidak dapat terhubung ke jaringan lokal (LAN).

1. Apa kemungkinan penyebab kegagalan koneksi?
2. Apakah jenis kabel yang digunakan sudah sesuai?
3. Apakah urutan warna sudah sesuai standar TIA/EIA?

Silakan pelajari materi dan video sebelum melakukan simulasi.""",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Mengerti"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.user == null ? 'Loading...' : 'Hei, ${auth.user!.name}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _menuItem(
              title: "Materi",
              icon: Icons.book,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MateriScreen()),
                );
              },
            ),

            _menuItem(
              title: "Video",
              icon: Icons.video_library,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VideoScreen()),
                );
              },
            ),

            _menuItem(
              title: "Formatif",
              icon: Icons.quiz,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuizListScreen(type: "formatif"),
                  ),
                );
              },
            ),

            _menuItem(
              title: "Sumatif",
              icon: Icons.school,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuizListScreen(type: "sumatif"),
                  ),
                );
              },
            ),

            _menuItem(
              title: "Simulasi",
              icon: Icons.memory,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SimulasiScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 reusable menu
  Widget _menuItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
