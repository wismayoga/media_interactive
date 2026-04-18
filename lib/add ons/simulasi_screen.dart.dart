import 'dart:math';
import 'package:flutter/material.dart';

class SimulasiStraightScreen extends StatefulWidget {
  const SimulasiStraightScreen({super.key});

  @override
  State<SimulasiStraightScreen> createState() => _SimulasiStraightScreenState();
}

class _SimulasiStraightScreenState extends State<SimulasiStraightScreen> {
  List<Color?> ujungA = List.filled(8, null);
  List<Color?> ujungB = List.filled(8, null);

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

  // urutan straight T568B
  final List<Color> straightOrder = [
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
    // Cek apakah semua slot terisi
    if (ujungA.contains(null) || ujungB.contains(null)) {
      _showFillAllDialog();
      return;
    }

    final benar =
        _listEquals(ujungA, straightOrder) &&
        _listEquals(ujungB, straightOrder);

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
        content: Text(benar ? 'Rangkaian sudah sesuai.' : 'Coba lagi.'),
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
    // Ukuran yang bisa diubah cepat:
    final double portCircleSize = 18; // lingkaran port di visualisasi
    final double slotSize = 52; // <-- DIPERBESAR: ukuran dropbox
    final double paletteHeight = 200;

    return Scaffold(
      appBar: AppBar(title: const Text('Simulasi Kabel Straight')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _visualColumnCompact("Ujung A (T568B)", ujungA, portCircleSize),
                _visualColumnCompact("Ujung B (T568B)", ujungB, portCircleSize),
              ],
            ),

            const SizedBox(height: 8),
            const Text(
              'Visualisasi koneksi: Straight (A → B)',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),

            // PALET DRAGGABLE
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
                children: warna.map((w) => _colorDraggableTiny(w)).toList(),
              ),
            ),

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ujung A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    8,
                    (i) => _dropBoxTiny(ujungA, i, slotSize),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ujung B',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    8,
                    (i) => _dropBoxTiny(ujungB, i, slotSize),
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
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset'),
                ),
                ElevatedButton.icon(
                  onPressed: cekHasil,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Cek Hasil'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _visualColumnCompact(
    String title,
    List<Color?> list,
    double portSize,
  ) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: List.generate(8, (i) {
                final c = list[i] ?? Colors.transparent;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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

  Widget _dropBoxTiny(List<Color?> target, int index, double size) {
    return DragTarget<Color>(
      // ⛔ Tidak boleh drop jika kotak terisi
      onWillAccept: (c) => target[index] == null,
      onAccept: (c) => setState(() => target[index] = c),
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
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: candidateData.isNotEmpty
                    ? (occupied ? Colors.red : Colors.blue)
                    : Colors.black26,
                width: candidateData.isNotEmpty ? 2.0 : 1,
              ),
              boxShadow: [
                if (occupied)
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: target[index] == null
                ? Icon(Icons.add, size: size * 0.35, color: Colors.black45)
                : null,
          ),
        );
      },
    );
  }

  Widget _colorDraggableTiny(Map<String, dynamic> w) {
    return Draggable<Color>(
      data: w['color'],
      feedback: Material(color: Colors.transparent, child: _colorBoxTiny(w)),
      childWhenDragging: Opacity(opacity: 0.45, child: _colorBoxTiny(w)),
      child: _colorBoxTiny(w),
    );
  }

  Widget _colorBoxTiny(Map<String, dynamic> w) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
