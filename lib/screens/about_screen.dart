import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int tapCount = 0;

  void _handleTap() {
    tapCount++;

    if (tapCount >= 5) {
      tapCount = 0; // reset

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 Selamat 🎉"),
          content: const Text(
            "Dikembangkan oleh Waru Dev\n\nInstagram: @pergihari",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Mantap"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tentang Aplikasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 120),

            const SizedBox(height: 20),

            const Text(
              "RakitanKU",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Aplikasi pembelajaran interaktif untuk memahami materi jaringan komputer, simulasi kabel LAN, serta latihan soal.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            _infoTile(
              icon: Icons.school,
              title: "Tujuan",
              content:
                  "Membantu siswa memahami konsep jaringan komputer secara interaktif melalui materi, video, simulasi, dan kuis.",
            ),

            const SizedBox(height: 10),

            _infoTile(
              icon: Icons.person,
              title: "Pengembang",
              content: "Pradnyani\nUniversitas Pendidikan Ganesha",
            ),

            const SizedBox(height: 10),

            _infoTile(
              icon: Icons.code,
              title: "Teknologi",
              content: "Flutter • Laravel API",
            ),

            const SizedBox(height: 10),

            _infoTile(
              icon: Icons.info,
              title: "Versi Aplikasi",
              content: "1.0.0",
            ),

            const SizedBox(height: 30),

            // 🔥 EASTER EGG CLICK AREA
            GestureDetector(
              onTap: _handleTap,
              child: const Text(
                "© 2026 RakitanKU App",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}
