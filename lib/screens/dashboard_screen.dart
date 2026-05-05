import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'about_screen.dart';
import 'help_screen.dart';
import 'login_screen.dart';
import 'materi_screen.dart';
import 'quiz_list_screen.dart';
import 'simulasi_screen.dart';
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

    Future.microtask(() {
      context.read<AuthProvider>().fetchMe();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showChallengeDialog();
    });
  }

  void _showChallengeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tantangan Praktik Perakitan Kabel Jaringan"),
        content: const SingleChildScrollView(
          child: Text(
            "Pada saat praktik di laboratorium jaringan, sebuah komputer "
            "tidak dapat terhubung ke jaringan lokal (LAN), meskipun "
            "perangkat telah dinyalakan dan konfigurasi IP address sudah "
            "dilakukan dengan benar.\n\n"
            "Setelah dilakukan pemeriksaan awal, tidak ditemukan kerusakan "
            "pada perangkat jaringan. Namun, indikator pada LAN tester "
            "menunjukkan adanya kesalahan pada susunan kabel.\n\n"
            "Berdasarkan kondisi tersebut:\n"
            "1. Apa kemungkinan penyebab kegagalan koneksi?\n"
            "2. Apakah jenis kabel yang digunakan sudah sesuai kebutuhan jaringan?\n"
            "3. Apakah urutan warna kabel telah mengikuti standar TIA/EIA 568A atau 568B?\n\n"
            "Silakan pelajari materi dan amati video pembelajaran untuk "
            "mengidentifikasi permasalahan sebelum Anda merancang solusi "
            "melalui simulasi.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Mulai"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2EEF3),
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 HEADER ATAS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
              decoration: const BoxDecoration(color: Color(0xFF1E96F2)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Hei, ${auth.user?.name ?? 'Siswa'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      await auth.logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 GRID MENU
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                  children: [
                    // _menuItem(
                    //   title: "CP",
                    //   icon: Icons.menu_book_rounded,
                    //   colors: const [Color(0xFF2A90F4), Color(0xFF43C5F8)],
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) =>
                    //             const MateriScreen(filterType: "cp"),
                    //       ),
                    //     );
                    //   },
                    // ),

                    // _menuItem(
                    //   title: "TP",
                    //   icon: Icons.lightbulb_outline,
                    //   colors: const [Color(0xFFFF9800), Color(0xFFFF6A00)],
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) =>
                    //             const MateriScreen(filterType: "tp"),
                    //       ),
                    //     );
                    //   },
                    // ),
                    _menuItem(
                      title: "Materi",
                      icon: Icons.folder_copy_outlined,
                      colors: const [Color(0xFF9627CF), Color(0xFF6E35FF)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MateriScreen(filterType: "materi"),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "Video",
                      icon: Icons.play_circle_outline,
                      colors: const [Color(0xFFFF4B4B), Color(0xFFFF3B3B)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VideoScreen(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "Formatif",
                      icon: Icons.calendar_month,
                      colors: const [Color(0xFF4CCB47), Color(0xFF92F441)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const QuizListScreen(type: "formatif"),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "Simulasi",
                      icon: Icons.cable,
                      colors: const [Color(0xFF3E52C9), Color(0xFF506BFF)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SimulasiScreen(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "Sumatif",
                      icon: Icons.assignment_turned_in_outlined,
                      colors: const [Color(0xFF0EB6A8), Color(0xFF64EFD2)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const QuizListScreen(type: "sumatif"),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "About",
                      icon: Icons.info_outline,
                      colors: const [Color(0xFF8A6B58), Color(0xFFF2A938)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      title: "Help",
                      icon: Icons.help_outline,
                      colors: const [Color(0xFF08B0F4), Color(0xFF19C8FF)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 LINGKARAN ICON
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.20),
              ),
              child: Icon(icon, size: 38, color: Colors.white),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
