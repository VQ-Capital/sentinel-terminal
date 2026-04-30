// ========== DOSYA: sentinel-terminal/lib/main.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: VQTerminalApp()));
}

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sentinel-quant',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121214),
          elevation: 0,
          centerTitle: false,
        ),
        cardColor: const Color(0xFF18181B),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          padding: const EdgeInsets.all(12),
          waitDuration: const Duration(milliseconds: 200),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
