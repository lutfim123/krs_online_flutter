import 'package:flutter/material.dart';
import 'screens/krs_page.dart';

void main() {
  runApp(const KrsOnlineApp());
}

class KrsOnlineApp extends StatelessWidget {
  const KrsOnlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem KRS Online Sederhana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const KrsPage(),
    );
  }
}
