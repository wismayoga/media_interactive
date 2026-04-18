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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: simulasiList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = simulasiList[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        item['image'] as String,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        item['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
