import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panduan Penggunaan")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpItem(
            title: "Login",
            content:
                "Masukkan email dan password yang telah diberikan, lalu tekan tombol Login.",
          ),

          _HelpItem(
            title: "Materi",
            content:
                "Pilih menu Materi untuk melihat bahan pembelajaran. Tekan tombol PDF untuk membuka materi.",
          ),

          _HelpItem(
            title: "Video Pembelajaran",
            content:
                "Masuk ke menu Video untuk menonton video pembelajaran yang tersedia.",
          ),

          _HelpItem(
            title: "Simulasi",
            content:
                "Gunakan fitur simulasi untuk memahami penyusunan kabel LAN secara interaktif.",
          ),

          _HelpItem(
            title: "Quiz (Formatif & Sumatif)",
            content:
                "Pilih quiz, jawab semua soal, lalu tekan Kirim Jawaban. Pastikan semua soal telah diisi.",
          ),

          _HelpItem(
            title: "Diskusi",
            content:
                "Gunakan fitur diskusi untuk bertanya dan berdiskusi dengan teman atau guru.",
          ),

          _HelpItem(
            title: "Masalah Umum",
            content:
                "Jika aplikasi tidak memuat data, periksa koneksi internet Anda dan coba refresh.",
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String title;
  final String content;

  const _HelpItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(padding: const EdgeInsets.all(12), child: Text(content)),
        ],
      ),
    );
  }
}
