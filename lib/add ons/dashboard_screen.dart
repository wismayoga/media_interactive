import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

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

    // tampilkan dialog saat pertama masuk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showChallengeDialog();
    });
  }

  void _showChallengeDialog() {seConptyDll` setting..
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tantangan Praktik Perakitan Kabel Jaringan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              """Pada saat praktik di laboratorium jaringan, sebuah komputer tidak dapat terhubung ke jaringan lokal (LAN), meskipun perangkat telah dinyalakan dan konfigurasi IP address sudah dilakukan dengan benar.

                Setelah dilakukan pemeriksaan awal, tidak ditemukan kerusakan pada perangkat jaringan. Namun, indikator pada LAN tester menunjukkan adanya kesalahan pada susunan kabel.

                Berdasarkan kondisi tersebut:

                1. Apa kemungkinan penyebab kegagalan koneksi?
                2. Apakah jenis kabel yang digunakan sudah sesuai kebutuhan jaringan?
                3. Apakah urutan warna kabel telah mengikuti standar TIA/EIA 568A atau 568B?

                Silakan pelajari materi dan amati video pembelajaran untuk mengidentifikasi permasalahan sebelum Anda merancang solusi melalui simulasi.
                """,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Mengerti"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.user == null ? 'Loading...' : 'Hei, ${auth.user!.name}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Dashboard')),
    );
  }
}
