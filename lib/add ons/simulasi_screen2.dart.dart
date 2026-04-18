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

  // draggable palette (order visual only)
  final List<Map<String, dynamic>> warna = [
    {'nama': 'Putih-Orange', 'color': Colors.orange.shade100},
    {'nama': 'Orange', 'color': Colors.orange},
    {'nama': 'Putih-Biru', 'color': Colors.blue.shade100},
    {'nama': 'Biru', 'color': Colors.blue},
    {'nama': 'Putih-Hijau', 'color': Colors.green.shade100},
    {'nama': 'Hijau', 'color': Colors.green},
    {'nama': 'Putih-Coklat', 'color': Colors.brown.shade200},
    {'nama': 'Coklat', 'color': Colors.brown},
  ];

  // CROSS OVER RULE:
  // A = T568A
  // B = T568B

  final List<Color> orderA = [
    Colors.green.shade100, // Putih-Hijau
    Colors.green, // Hijau
    Colors.orange.shade100, // Putih-Orange
    Colors.blue, // Biru
    Colors.blue.shade100, // Putih-Biru
    Colors.orange, // Orange
    Colors.brown.shade200, // Putih-Coklat
    Colors.brown, // Coklat
  ];

  final List<Color> orderB = [
    Colors.orange.shade100, // Putih-Orange
    Colors.orange, // Orange
    Colors.green.shade100, // Putih-Hijau
    Colors.blue, // Biru
    Colors.blue.shade100, // Putih-Biru
    Colors.green, // Hijau
    Colors.brown.shade200, // Putih-Coklat
    Colors.brown, // Coklat
  ];

  void cekHasil() {
    if (ujungA.contains(null) || ujungB.contains(null)) {
      _showFillAllDialog();
      return;
    }

    final benar = _listEquals(ujungA, orderA) && _listEquals(ujungB, orderB);
    _showResult(benar);
  }

  void _showFillAllDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Belum lengkap'),
        content: const Text(
          'Isi semua slot pada Ujung A dan Ujung B terlebih dahulu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _listEquals(List<Color?> a, List<Color> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _showResult(bool benar) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(benar ? 'Benar!' : 'Salah!'),
        content: Text(
          benar
              ? 'Kabel crossover benar (A = T568A, B = T568B).'
              : 'Coba lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (!benar)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetAll();
              },
              child: const Text('Reset'),
            ),
        ],
      ),
    );
  }

  void _resetAll() {
    setState(() {
      ujungA = List.filled(8, null);
      ujungB = List.filled(8, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double portCircleSize = 15;
    final double slotSize = 30;
    final double paletteHeight = 120;

    return Scaffold(
      appBar: AppBar(title: const Text('Simulasi Kabel Cross (Crossover)')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            /// VISUALISASI T568A & T568B
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _visualColumn("Ujung A (T568A)", ujungA, portCircleSize),
                _visualColumn("Ujung B (T568B)", ujungB, portCircleSize),
              ],
            ),

            const SizedBox(height: 8),
            const Text(
              'Visualisasi: A = T568A,  B = T568B',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),

            /// PALET DRAGGABLE
            Container(
              height: paletteHeight,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                physics: const NeverScrollableScrollPhysics(),
                children: warna.map((w) => _colorDraggable(w)).toList(),
              ),
            ),

            const SizedBox(height: 8),

            /// INPUT UJUNG A
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ujung A (T568A)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    8,
                    (i) => _dropBox(ujungA, i, slotSize),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// INPUT UJUNG B
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ujung B (T568B)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    8,
                    (i) => _dropBox(ujungB, i, slotSize),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                ElevatedButton.icon(
                  onPressed: cekHasil,
                  icon: const Icon(Icons.check),
                  label: const Text('Cek Hasil'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _visualColumn(String title, List<Color?> list, double portSize) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(8, (i) {
                final c = list[i] ?? Colors.transparent;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: portSize,
                        height: portSize,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('P${i + 1}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropBox(List<Color?> target, int index, double size) {
    return DragTarget<Color>(
      onWillAccept: (c) => target[index] == null,
      onAccept: (c) {
        if (target[index] == null) setState(() => target[index] = c);
      },
      builder: (context, candidateData, rejectedData) {
        final occupied = target[index] != null;
        return GestureDetector(
          onDoubleTap: () => setState(() => target[index] = null),
          child: Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: target[index] ?? Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: candidateData.isNotEmpty
                    ? (occupied ? Colors.red : Colors.blue)
                    : Colors.black26,
                width: candidateData.isNotEmpty ? 1.8 : 1,
              ),
            ),
            child: target[index] == null
                ? const Icon(Icons.add, size: 16, color: Colors.black45)
                : null,
          ),
        );
      },
    );
  }

  Widget _colorDraggable(Map<String, dynamic> w) {
    return Draggable<Color>(
      data: w['color'],
      feedback: Material(color: Colors.transparent, child: _colorBox(w)),
      childWhenDragging: Opacity(opacity: 0.45, child: _colorBox(w)),
      child: _colorBox(w),
    );
  }

  Widget _colorBox(Map<String, dynamic> w) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          fontSize: 12,
          color: useWhiteForeground(w['color']) ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  bool useWhiteForeground(Color c, {double bias = 0.0}) {
    final double v = sqrt(
      c.red * c.red * 0.299 +
          c.green * c.green * 0.587 +
          c.blue * c.blue * 0.114,
    );
    return v < 130 + bias;
  }
}
