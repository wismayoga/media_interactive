import 'package:flutter/material.dart';
import 'package:media_interactive/providers/discussion_provider.dart';
import 'package:media_interactive/screens/materi_screen.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/materi_provider.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => MateriProvider()),
        ChangeNotifierProvider(create: (_) => DiscussionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // 👇 ini penting
        initialRoute: '/',

        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/materi': (_) => const MateriScreen(),

          // nanti kita isi:
          // '/quiz': (_) => QuizScreen(),
          // '/materi': (_) => MateriScreen(),
        },
      ),
    );
  }
}
