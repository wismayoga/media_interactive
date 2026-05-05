import 'dart:math';
import 'package:flutter/material.dart';

class SimulasiCrossScreen extends StatefulWidget {
  const SimulasiCrossScreen({super.key});

  @override
  State<SimulasiCrossScreen> createState() => _SimulasiCrossScreenState();
}

class _SimulasiCrossScreenState extends State<SimulasiCrossScreen> {
  List<Color?> ujungA = List.filled(8, null);
  List<Color?> ujungB = List.filled(8, null);

  final List<Map<String, dynamic>> warna = [
    {'nama': 'Putih-Orange', 'color': Color(0xFFEED2A2)},
    {'nama': 'Orange', 'color': Colors.orange},
    {'nama': 'Putih-Hijau', 'color': Color(0xFFB8D2B6)},
    {'nama': 'Hijau', 'color': Colors.green},
    {'nama': 'Putih-Biru', 'color': Color(0xFFA9C7E2)},
    {'nama': 'Biru', 'color': Colors.blue},
    {'nama': 'Putih-Coklat', 'color': Color(0xFFBBAEA8)},
    {'nama': 'Coklat', 'color': Colors.brown},
  ];

  // 🔥 CROSS
  // A = T568A
  final List<Color> orderA = [
    Color(0xFFB8D2B6),
    Colors.green,
    Color(0xFFEED2A2),
    Colors.blue,
    Color(0xFFA9C7E2),
    Colors.orange,
    Color(0xFFBBAEA8),
    Colors.brown,
  ];

  // B = T568B
  final List<Color> orderB = [
    Color(0xFFEED2A2),
    Colors.orange,
    Color(0xFFB8D2B6),
    Colors.blue,
    Color(0xFFA9C7E2),
    Colors.green,
    Color(0xFFBBAEA8),
    Colors.brown,
  ];

  void resetAll() {
    setState(() {
      ujungA = List.filled(8, null);
      ujungB = List.filled(8, null);
    });
  }

  void cek() {
    if (ujungA.contains(null) || ujungB.contains(null)) {
      dialog("Belum Lengkap", "Isi semua slot terlebih dahulu.");
      return;
    }

    bool benar = _same(ujungA, orderA) && _same(ujungB, orderB);

    dialog(
      benar ? "🎉 Benar!" : "❌ Salah!",
      benar ? "Susunan kabel cross sudah tepat." : "Coba lagi.",
    );
  }

  bool _same(List<Color?> a, List<Color> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void dialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double slot = 40;

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4EFF5),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Simulasi Kabel Cross",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _visual("Ujung A (T568A)", ujungA),
                _visual("Ujung B (T568B)", ujungB),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Visualisasi koneksi: Cross (A ↔ B)",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
                children: warna.map((e) => _drag(e)).toList(),
              ),
            ),

            const SizedBox(height: 18),

            _dropArea("Ujung A", ujungA, slot),

            const SizedBox(height: 16),

            _dropArea("Ujung B", ujungB, slot),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: resetAll,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 3,
                    minimumSize: const Size(140, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: cek,
                  icon: const Icon(Icons.check),
                  label: const Text("Cek Hasil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 3,
                    minimumSize: const Size(150, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _visual(String title, List<Color?> data) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Container(
          width: 118,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: List.generate(
              8,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 1.5,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data[i] ?? Colors.transparent,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text("P${i + 1}", style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropArea(String title, List<Color?> target, double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            8,
            (i) => DragTarget<Color>(
              onWillAccept: (c) => target[i] == null,
              onAccept: (c) {
                setState(() {
                  target[i] = c;
                });
              },
              builder: (context, cand, rej) {
                return GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      target[i] = null;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: target[i] ?? Colors.white38,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: target[i] == null
                        ? const Icon(Icons.add, size: 18, color: Colors.black45)
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _drag(Map<String, dynamic> item) {
    final color = item['color'] as Color;

    return Draggable<Color>(
      data: color,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 82, height: 70, child: _box(item)),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: _box(item)),
      child: _box(item),
    );
  }

  Widget _box(Map<String, dynamic> item) {
    final color = item['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          item['nama'],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: useWhite(color) ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  bool useWhite(Color c) {
    final v = sqrt(
      c.red * c.red * 0.299 +
          c.green * c.green * 0.587 +
          c.blue * c.blue * 0.114,
    );
    return v < 130;
  }
}
