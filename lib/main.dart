import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // flutter_riverpod olmalı
import 'core/network/terminal_stream.dart';

void main() {
  // ProviderScope eklemeyi unutma, riverpod için zorunlu
  runApp(const ProviderScope(child: VQTerminalApp()));
}

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Canlı fiyat provider'ını dinle
    final lastTradeAsync = ref.watch(liveTradesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('🦅 VQ-CAPITAL PRO TERMINAL'),
        actions: [
          lastTradeAsync.when(
            data: (t) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  '${t.symbol}: ${t.price.toStringAsFixed(2)} USD', 
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            loading: () => const SizedBox(width: 50, child: CircularProgressIndicator()),
            error: (_, __) => const Icon(Icons.error, color: Colors.red),
          )
        ],
      ),
      body: const ExecutionList(),
    );
  }
}

class ExecutionList extends ConsumerWidget {
  const ExecutionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pipeline'ı dinleyip sadece raporları göstermek için bir yapı
    final pipelineAsync = ref.watch(vqPipelineProvider);
    
    return pipelineAsync.when(
      data: (bundle) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt, color: Colors.yellow, size: 64),
              const SizedBox(height: 16),
              const Text("BİNERİ HATTI AKTİF", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (bundle.hasReport())
                Text("Son İşlem: ${bundle.report.symbol} - ${bundle.report.executionPrice}")
              else
                const Text("Sinyal Bekleniyor...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Hata: $e")),
    );
  }
}