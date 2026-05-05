import 'package:flutter/material.dart';
import 'simulasi_cross_screen.dart';
import 'simulasi_straight_screen.dart';

class SimulasiScreen extends StatelessWidget {
  const SimulasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> simulasiList = [
      {
        "title": "Kabel LAN Cross",
        "image": "assets/images/cross_lan.png",
        "screen": const SimulasiCrossScreen(),
      },
      {
        "title": "Kabel LAN Straight",
        "image": "assets/images/straight_lan.png",
        "screen": const SimulasiStraightScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Simulasi")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: simulasiList.length,
        itemBuilder: (context, index) {
          final item = simulasiList[index];

          return Center(
            child: SizedBox(
              width: 350,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  // 🔥 ROW (KIRI - KANAN)
                  child: Row(
                    children: [
                      // 🔥 GAMBAR (KIRI)
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          item['image'] as String,
                          fit: BoxFit.contain, // 🔥 tidak crop
                        ),
                      ),

                      const SizedBox(width: 16),

                      // 🔤 TEXT (KANAN)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
