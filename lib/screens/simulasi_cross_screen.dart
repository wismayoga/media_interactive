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

  bool selesai = false;

  final List<Map<String, dynamic>> warna = [
    {'nama': 'Putih-Orange', 'color': Colors.orange.shade100},
    {'nama': 'Orange', 'color': Colors.orange},
    {'nama': 'Putih-Hijau', 'color': Colors.green.shade100},
    {'nama': 'Hijau', 'color': Colors.green},
    {'nama': 'Putih-Biru', 'color': Colors.blue.shade100},
    {'nama': 'Biru', 'color': Colors.blue},
    {'nama': 'Putih-Coklat', 'color': Colors.brown.shade200},
    {'nama': 'Coklat', 'color': Colors.brown},
  ];

  // 🔥 Ujung A (T568A)
  final List<Color> orderA = [
    Colors.green.shade100,
    Colors.green,
    Colors.orange.shade100,
    Colors.blue,
    Colors.blue.shade100,
    Colors.orange,
    Colors.brown.shade200,
    Colors.brown,
  ];

  // 🔥 Ujung B (T568B)
  final List<Color> orderB = [
    Colors.orange.shade100,
    Colors.orange,
    Colors.green.shade100,
    Colors.blue,
    Colors.blue.shade100,
    Colors.green,
    Colors.brown.shade200,
    Colors.brown,
  ];

  bool isColorUsed(Color color) {
    return ujungA.contains(color) || ujungB.contains(color);
  }

  void cekHasil() {
    if (ujungA.contains(null) || ujungB.contains(null)) {
      _showDialog("Belum lengkap", "Isi semua slot pada Ujung A dan Ujung B.");
      return;
    }

    final benar = _listEquals(ujungA, orderA) && _listEquals(ujungB, orderB);

    if (benar) selesai = true;

    _showDialog(
      benar ? "🎉 Benar!" : "❌ Salah!",
      benar ? "Kabel Cross sudah benar!" : "Coba lagi.",
      showReset: !benar,
    );
  }

  bool _listEquals(List<Color?> a, List<Color> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] == null || a[i] != b[i]) return false;
    }
    return true;
  }

  void _resetAll() {
    setState(() {
      ujungA = List.filled(8, null);
      ujungB = List.filled(8, null);
      selesai = false;
    });
  }

  void _showDialog(String title, String msg, {bool showReset = false}) {
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
          if (showReset)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetAll();
              },
              child: const Text("Reset"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double slotSize = 50;

    return Scaffold(
      appBar: AppBar(title: const Text("Simulasi Kabel Cross")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Susun kabel Cross (A=T568A, B=T568B)",
              style: TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _visualColumn("Ujung A (T568A)", ujungA),
                _visualColumn("Ujung B (T568B)", ujungB),
              ],
            ),

            const SizedBox(height: 10),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: warna.map((w) => _draggable(w)).toList(),
            ),

            const SizedBox(height: 10),

            _dropRow("Ujung A", ujungA, slotSize),
            const SizedBox(height: 8),
            _dropRow("Ujung B", ujungB, slotSize),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
                ElevatedButton.icon(
                  onPressed: cekHasil,
                  icon: const Icon(Icons.check),
                  label: const Text("Cek"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _visualColumn(String title, List<Color?> list) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Column(
          children: List.generate(8, (i) {
            return Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: list[i] ?? Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                Text("P${i + 1}", style: const TextStyle(fontSize: 12)),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _dropRow(String title, List<Color?> target, double size) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            8,
            (i) => DragTarget<Color>(
              onWillAccept: (c) => !selesai && target[i] == null,
              onAccept: (c) => setState(() => target[i] = c),
              builder: (context, candidate, rejected) {
                return GestureDetector(
                  onDoubleTap: () => setState(() => target[i] = null),
                  child: Container(
                    width: size,
                    height: size,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: target[i] ?? Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: candidate.isNotEmpty
                            ? Colors.blue
                            : Colors.black26,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: target[i] == null
                        ? Text(
                            "${i + 1}",
                            style: const TextStyle(color: Colors.grey),
                          )
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

  Widget _draggable(Map<String, dynamic> w) {
    final color = w['color'];

    return Draggable<Color>(
      data: color,
      feedback: Material(color: Colors.transparent, child: _colorBox(w)),
      childWhenDragging: Opacity(opacity: 0.3, child: _colorBox(w)),
      child: Opacity(
        opacity: isColorUsed(color) ? 0.3 : 1,
        child: _colorBox(w),
      ),
    );
  }

  Widget _colorBox(Map<String, dynamic> w) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: w['color'],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black26),
      ),
      alignment: Alignment.center,
      child: Text(
        w['nama'],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: useWhiteForeground(w['color']) ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  bool useWhiteForeground(Color c) {
    final v = sqrt(
      c.red * c.red * 0.299 +
          c.green * c.green * 0.587 +
          c.blue * c.blue * 0.114,
    );
    return v < 130;
  }
}
