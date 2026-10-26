import 'package:flutter/material.dart';
import 'package:thermspot_mobile/screens/settings/settings_screen.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(const ThermspotApp());
}

class ThermspotApp extends StatelessWidget {
  const ThermspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thermspot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF43C7D9),
        ),
      ),
      home: const LoginScreen(),
      //home: const SettingsScreen(),
      //home: const MonitorScreen(),
    );
  }
}

class ThermspotStartScreen extends StatelessWidget {
  const ThermspotStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Thermspot',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}