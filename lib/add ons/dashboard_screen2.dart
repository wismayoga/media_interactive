import 'package:flutter/material.dart';
import 'package:media_interactive_app/screens/about_screen.dart';
import 'package:media_interactive_app/screens/formatif_screen.dart';
import 'package:media_interactive_app/screens/help_screen.dart';
import 'package:media_interactive_app/screens/materi_screen.dart';
import 'package:media_interactive_app/screens/simulation_screen.dart';
import 'package:media_interactive_app/screens/sumatif_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

// Screens
import 'login_screen.dart';
import 'cp_screen.dart';
import 'tp_screen.dart';
import 'video_list_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final menus = [
      DashboardMenu(
        title: "CP",
        icon: Icons.menu_book_rounded,
        colors: [Colors.blue, Colors.lightBlueAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CpScreen()),
        ),
      ),
      DashboardMenu(
        title: "TP",
        icon: Icons.lightbulb_outline,
        colors: [Colors.orange, Colors.deepOrangeAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TpScreen()),
        ),
      ),
      DashboardMenu(
        title: "Formatif",
        icon: Icons.calendar_month,
        colors: [Colors.green, Colors.lightGreenAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormatifScreen()),
        ),
      ),
      DashboardMenu(
        title: "Materi",
        icon: Icons.folder_copy,
        colors: [Colors.purple, Colors.deepPurpleAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MateriScreen()),
        ),
      ),
      DashboardMenu(
        title: "Video",
        icon: Icons.play_circle_fill,
        colors: [Colors.red, Colors.redAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VideoListScreen()),
        ),
      ),
      DashboardMenu(
        title: "Sumatif",
        icon: Icons.assignment_turned_in,
        colors: [Colors.teal, Colors.tealAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SumatifScreen()),
        ),
      ),
      DashboardMenu(
        title: "Simulasi",
        icon: Icons.cable,
        colors: [Colors.indigo, Colors.indigoAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SimulationScreen()),
        ),
      ),
      DashboardMenu(
        title: "About",
        icon: Icons.info_outline,
        colors: [Colors.brown, Colors.orangeAccent],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ),
      DashboardMenu(
        title: "Help",
        icon: Icons.help_outline,
        colors: [Colors.cyan, Colors.lightBlue],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpScreen()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          auth.user == null ? 'Loading...' : 'Hei, ${auth.user!.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 24,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, i) {
            return DashboardMenuCard(menu: menus[i]);
          },
        ),
      ),
    );
  }
}

// =======================================================
// MODEL MENU
// =======================================================

class DashboardMenu {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  DashboardMenu({
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });
}

// =======================================================
// MENU CARD WIDGET
// =======================================================

class DashboardMenuCard extends StatelessWidget {
  final DashboardMenu menu;

  const DashboardMenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menu.onTap,
      borderRadius: BorderRadius.circular(22),
      splashColor: Colors.white24,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: menu.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: menu.colors.first.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(menu.icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              menu.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
